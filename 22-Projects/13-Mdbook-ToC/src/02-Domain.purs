module ToC.Domain
  ( program
  , class ReadPath, readDir, readFile, readPathType, exists
  , class WriteToFile, writeToFile, mkDir, copyFile
  , class Renderer, renderFile
  , class Logger, log, logInfo, logError, logDebug
  ) where

import Prelude

import Control.Monad.Reader (class MonadAsk, ask)
import Data.Array (catMaybes, intercalate, sortBy, filter)
import Data.Foldable (fold)
import Data.Function (applyN)
import Data.Maybe (Maybe(..))
import Data.String (lastIndexOf, Pattern(..), take, drop, joinWith)
import Data.Traversable (for)
import Node.Path (sep)
import ToC.Core.EOL (endOfLine)
import ToC.Core.Env (Env, LogLevel(..))
import ToC.Core.Paths (FilePath, PathType(..), IncludeablePathType(..), PathRec, fullPath, parentPath, addParentPrefix, addPath, mkPathRec)
import ToC.Renderer.MarkdownRenderer (renderDir)

program :: forall m r.
           Monad m =>
           MonadAsk (Env r) m =>
           Logger m =>
           ReadPath m =>
           Renderer m =>
           WriteToFile m =>
           m Unit
program = do
  env <- ask
  output <- renderFiles
  logInfo "Finished rendering files. Now writing to file."
  header <- readFile env.mdbook.headerFilePath
  writeToFile env.mdbook.summaryFilePath (header <> output)
  logInfo "Done."


-- | Recursively walks the file tree, starting at the root directory
-- | and renders each file and directory that should be included.
renderFiles :: forall m r.
               Monad m =>
               MonadAsk (Env r) m =>
               Logger m =>
               ReadPath m =>
               Renderer m =>
               WriteToFile m =>
               m String
renderFiles = do
  env <- ask
  paths <- readDir env.rootPath
  let sortedPaths = sortBy env.sortPaths paths
  logDebug $ "All possible top-level directories\n" <> intercalate "\n" sortedPaths
  sections <- catMaybes <$> renderSectionsOrNothing sortedPaths
  pure $ fold sections

  where
    -- | More or less maps the unrendered top-level directory array into
    -- | rendered top-level directory array.
    renderSectionsOrNothing :: Array FilePath -> m (Array (Maybe String))
    renderSectionsOrNothing paths = do
      env <- ask
      -- the function that follows 'parTraverse' is done in parallel
      for paths \topLevelPath -> do
        let
          topLevelPathRec = mkPathRec env.rootPath topLevelPath
          topLevelFullPath = fullPath topLevelPathRec
        pathType <- readPathType topLevelFullPath
        case pathType of
          Just Dir | env.includePath TopLevelDirectory topLevelPath -> do
            Just <$> renderDirectory 0 topLevelPathRec
          _ -> pure $ Nothing

-- | Renders the given path, whether it is a directory or a file.
renderPath :: forall m r.
              Monad m =>
              MonadAsk (Env r) m =>
              Logger m =>
              ReadPath m =>
              Renderer m =>
              WriteToFile m =>
              Int -> PathRec -> m (Maybe String)
renderPath depth pathRec = do
  env <- ask
  let
    fullChildPath = fullPath pathRec
    childPath = pathRec.path
  pathType <- readPathType fullChildPath
  case pathType of
    Just Dir
      | env.includePath NormalDirectory childPath -> do
          Just <$> renderDirectory depth pathRec
      | otherwise                       -> do
          logDebug $ "Excluding directory: " <> fullChildPath
          pure Nothing
    Just File
      | env.includePath A_File childPath -> do
          Just <$> renderOneFile depth pathRec
      | otherwise                 -> do
          logDebug $ "Excluding File: " <> fullChildPath
          pure Nothing
    _ -> do
      logInfo $ "Unknown path type: " <> fullChildPath
      pure Nothing

contentFilePath :: FilePath
contentFilePath = "content"

-- | Renders the given directory and all of its already-rendered child paths
renderDirectory :: forall m r.
                   Monad m =>
                   MonadAsk (Env r) m =>
                   Logger m =>
                   ReadPath m =>
                   Renderer m =>
                   WriteToFile m =>
                   Int -> PathRec -> m String
renderDirectory depth pathRec = do
  let entirePath = fullPath pathRec
  logDebug $ "Rendering directory of depth " <> show depth <> " - (start): " <> entirePath

  renderedDirPath <- renderDirectoryPath
  renderedContents <- renderDirectoryContents entirePath

  logDebug $ "Rendering directory of depth " <> show depth <> " - (done) : " <> entirePath
  pure $ renderedDirPath <> renderedContents
  where
    renderDirectoryPath :: m String
    renderDirectoryPath = do
      let readmePath = addPath pathRec "Readme.md"
      readmeExists <- exists (fullPath readmePath)
      case readmeExists of
        true -> do
          env <- ask
          logDebug $ "Readme exists."
          let
            updateRootToMdbookDir = readmePath { root = env.mdbook.outputDir }
            mdbookContentDirPathRec = addParentPrefix updateRootToMdbookDir contentFilePath

          logDebug $ "Copying file: " <> (fullPath readmePath) <> " -> " <> (fullPath mdbookContentDirPathRec)
          copyFile pathRec mdbookContentDirPathRec

          logDebug "Rendering directory via its `Readme.md` file"
          renderFile depth pathRec.path mdbookContentDirPathRec
        false -> do
          logDebug $ "Readme does not exist"
          logDebug "Rendering directory as placeholder path"
          pure $ renderDir depth pathRec.path

    renderDirectoryContents :: FilePath -> m String
    renderDirectoryContents entirePath = do
      env <- ask
      unparsedPaths <- (filter (_ /= "Readme.md")) <$> readDir entirePath
      let sortedPaths = sortBy env.sortPaths unparsedPaths
      mbRenderedPaths <- for sortedPaths \p ->
        renderPath (depth + 1) (addPath pathRec p)
      pure $ fold (catMaybes mbRenderedPaths)

-- | Renders the given file and all of its headers
renderOneFile :: forall m r.
                  Monad m =>
                  MonadAsk (Env r) m =>
                  Logger m =>
                  ReadPath m =>
                  Renderer m =>
                  WriteToFile m =>
                  Int -> PathRec -> m String
renderOneFile depth pathRec = do
  let fullChildPath = fullPath pathRec
  logDebug $ "Rendering File (start): " <> fullChildPath

  env <- ask
  logDebug $ "Copying file into mdbook folder path"
  let
    updateRootToMdbookDir = pathRec { root = env.mdbook.outputDir }
    mdbookContentDirPathRec = addParentPrefix updateRootToMdbookDir contentFilePath

  logDebug $ "Copying file: " <> (fullPath pathRec) <> " -> " <> (fullPath mdbookContentDirPathRec)
  copyFile pathRec mdbookContentDirPathRec

  let p = mdbookContentDirPathRec.path
  result <- case parseFileExtension p of
    Nothing -> do
      logDebug $ "Rendering markdown file"
      renderFile depth p mdbookContentDirPathRec
    Just extRec -> do
      logDebug $ "Found code file"

      logDebug $ "Creating markdown file"
      let
        mdFilePath = mdbookContentDirPathRec { path = extRec.mdFileName }
        -- parentPrefix = applyN (\r -> r <> sep <> "..") depth env.codeFilePathPrefix
        -- relativeCodePath = pathRec { root = parentPrefix }
        mdContent = mkMarkdownContent extRec p mdbookContentDirPathRec
      mkDir (parentPath mdFilePath)
      writeToFile (fullPath mdFilePath) mdContent

      logDebug $ "Rendering code file"
      renderFile depth p mdFilePath
  logDebug $ "Rendering File (done) : " <> fullChildPath
  pure result

type CodeFileParts =
  { langHighlight :: String
  , mdFileName :: String
  }

parseFileExtension :: FilePath -> Maybe CodeFileParts
parseFileExtension filePathSegment = do
  idx <- lastIndexOf (Pattern ".") filePathSegment
  let
    name = take idx filePathSegment
    ext = drop idx filePathSegment
  case ext of
    ".purs" -> Just { langHighlight: "haskell", mdFileName: name <> "-ps.md" }
    ".js" -> Just { langHighlight: "javascript", mdFileName: name <> "-js.md" }
    _ -> Nothing

-- | Generates the following markdown file based on the
-- | file extension of the `filePathSegment` argument.
-- | ---
-- | # file-name.purs
-- |
-- | ```haskell
-- | {{#include file-name.purs}}
-- | ```
-- ---
mkMarkdownContent :: CodeFileParts -> FilePath -> PathRec -> String
mkMarkdownContent { langHighlight } fileName fileUrl = do
  joinWith endOfLine
    [ "# " <> fileName
    , ""
    , "```" <> langHighlight
    , "{{#include " <> (fullPath fileUrl) <> "}}"
    , "```"
    ]

-- | A monad that has the capability of determining the path type of a path,
-- | reading a directory for its child paths, and reading a file for its
-- | content.
class (Monad m) <= ReadPath m where
  readDir :: FilePath -> m (Array FilePath)

  readFile :: FilePath -> m String

  readPathType :: FilePath -> m (Maybe PathType)

  exists :: FilePath -> m Boolean

class (Monad m) <= Renderer m where
  renderFile :: Int -> FilePath -> PathRec -> m String

-- | A monad that has the capability of writing content to a given file path.
class (Monad m) <= WriteToFile m where
  writeToFile :: FilePath -> String -> m Unit

  mkDir :: FilePath -> m Unit

  copyFile :: PathRec -> PathRec -> m Unit

-- | A monad that has the capability of logging messages, whether to the
-- | console or a file.
class (Monad m) <= Logger m where
  log :: LogLevel -> String -> m Unit

-- | Logs a message using the Error level
logError :: forall m. Logger m => String -> m Unit
logError msg = log Error msg

-- | Logs a message using the Info level
logInfo :: forall m. Logger m => String -> m Unit
logInfo msg = log Info msg

-- | Logs a message using the Debug level
logDebug :: forall m. Logger m => String -> m Unit
logDebug msg = log Debug msg
