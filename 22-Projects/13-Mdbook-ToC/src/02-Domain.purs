module ToC.Domain
  ( program
  , class ReadPath, readDir, readFile, readPathType
  , class WriteToFile, writeToFile, mkDir
  , class Renderer, renderFile
  , class Logger, log, logInfo, logError, logDebug
  ) where

import Prelude

import Control.Monad.Reader (class MonadAsk, ask, asks)
import Data.Array (catMaybes, intercalate, sortBy)
import Data.List (List)
import Data.Maybe (Maybe(..))
import Data.Foldable (fold, for_)
import Data.Traversable (traverse, for)
import Data.Tree (Tree, showTree)
import Data.String (lastIndexOf, Pattern(..), take, drop, joinWith)
import ToC.Core.Paths (FilePath, PathType(..), IncludeablePathType(..), UriPath, WebUrl)
import ToC.Core.Env (Env, LogLevel(..))
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
  -- Make the directory that will store generated markdown files
  -- that wrap code's content in a code block
  mkDir env.mdbookCodeDir
  output <- renderFiles
  logInfo "Finished rendering files. Now writing to file."
  header <- readFile env.headerFilePath
  writeToFile env.outputFile (header <> output)
  logInfo "Done."


-- | Recursively walks the file tree, starting at the root directory
-- | and renders each file and directory that should be included.
renderFiles :: forall m r.
               Monad m =>
               MonadAsk (Env r) m =>
               Logger m =>
               ReadPath m =>
               Renderer m =>
               m String
renderFiles = do
  env <- ask
  paths <- readDir env.rootUri.fs
  let sortedPaths = sortBy env.sortPaths paths
  logDebug $ "All possible top-level directories\n" <> intercalate "\n" sortedPaths
  sections <- catMaybes <$> renderSectionsOrNothing env sortedPaths
  pure $ fold sections

  where
    -- | More or less maps the unrendered top-level directory array into
    -- | rendered top-level directory array.
    renderSectionsOrNothing :: Env r -> Array FilePath -> m (Array (Maybe String))
    renderSectionsOrNothing env paths =
      -- the function that follows 'parTraverse' is done in parallel
      for paths \topLevelPath -> do
        let fullPath = env.addPath env.rootUri topLevelPath
        pathType <- readPathType fullPath.fs
        case pathType of
          Just Dir | env.includePath TopLevelDirectory topLevelPath -> do
            logDebug $ "Rendering top-level directory (start): " <> fullPath.fs
            output <- renderTopLevelSection fullPath topLevelPath
            logDebug $ "Rendering top-level directory (done) : " <> fullPath.fs
            pure $ Just output
          _ -> pure $ Nothing

-- | Renders a single top-level directory, using its already-rendered
-- | child paths.
renderTopLevelSection :: forall m r.
                         Monad m =>
                         MonadAsk (Env r) m =>
                         Logger m =>
                         ReadPath m =>
                         Renderer m =>
                         UriPath -> FilePath -> m String
renderTopLevelSection topLevelFullPath topLevelPathSegment = do
  renderDirectory 0 topLevelFullPath topLevelPathSegment

-- | Renders the given path, whether it is a directory or a file.
renderPath :: forall m r.
              Monad m =>
              MonadAsk (Env r) m =>
              Logger m =>
              ReadPath m =>
              Renderer m =>
              Int -> UriPath -> FilePath -> m (Maybe String)
renderPath depth fullParentPath childPath = do
  env <- ask
  let fullChildPath = env.addPath fullParentPath childPath
  pathType <- readPathType fullChildPath.fs
  case pathType of
    Just Dir
      | env.includePath NormalDirectory childPath -> do
          logDebug $ "Rendering directory (start): " <> fullChildPath.fs
          output <- renderDirectory depth fullChildPath childPath
          logDebug $ "Rendering directory (done) : " <> fullChildPath.fs
          pure $ Just output
      | otherwise                       -> do
          logDebug $ "Excluding directory: " <> fullChildPath.fs
          pure Nothing
    Just File
      | env.includePath A_File childPath -> do
          logDebug $ "Rendering File (start): " <> fullChildPath.fs
          output <- renderOneFile depth fullChildPath childPath
          logDebug $ "Rendering File (done) : " <> fullChildPath.fs
          pure $ Just output
      | otherwise                 -> do
          logDebug $ "Excluding File: " <> fullChildPath.fs
          pure Nothing
    _ -> do
      logInfo $ "Unknown path type: " <> fullChildPath.fs
      pure Nothing

-- | Renders the given directory and all of its already-rendered child paths
renderDirectory :: forall m r.
                   Monad m =>
                   MonadAsk (Env r) m =>
                   Logger m =>
                   ReadPath m =>
                   Renderer m =>
                   Int -> UriPath -> FilePath -> m String
renderDirectory depth fullDirPath dirPathSegment = do
  env <- ask
  unparsedPaths <- readDir fullDirPath.fs
  let sortedPaths = sortBy env.sortPaths unparsedPaths
  renderedPaths <- catMaybes <$> traverse (renderPath (depth + 1) fullDirPath) sortedPaths
  pure $ renderDir depth dirPathSegment renderedPaths

-- | Renders the given file and all of its headers
renderOneFile :: forall m r.
                  Monad m =>
                  MonadAsk (Env r) m =>
                  Logger m =>
                  ReadPath m =>
                  Renderer m =>
                  Int -> UriPath -> FilePath -> m String
renderOneFile depth fullFilePath filePathSegment = do
  let
    fullUrl = fullFilePath.url
    fullPath = fullFilePath.fs
  case parseFileExtension filePathSegment of
    Nothing ->
      renderFile depth fullUrl filePathSegment
    Just rec -> do
      env <- ask
      let
        mdFilepath = env.mdbookCodeDir <> fsSep <> rec.name <> rec.suffix <> ".md"
        mdContent = mkMarkdownContent rec fullPath filePathSegment
      -- write a file
      -- writeTextFile mdFilePath mdContent
      -- renderFile depth mdbookPathFullUrl mdbookPat
      -- writeTextFile mdbookCodeDir <> fsSep <> rec.name <> rec.suffix <> ".md")
      renderFile depth fullUrl filePathSegment

type CodeFileParts =
  { name :: String
  , ext :: String
  , langHighlight :: String
  , suffix :: String
  }

parseFileExtension :: FilePath -> Maybe CodeFileParts
parseFileExtension filePathSegment = do
  idx <- lastIndexOf (Pattern ".") filePathSegment
  let
    name = take idx filePathSegment
    ext = drop (idx + 1) filePathSegment
  case ext of
    ".purs" -> Just { name, ext, langHighlight: "haskell", suffix: "-ps" }
    ".js" -> Just { name, ext, langHighlight: "javascript", suffix: "-js" }
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
mkMarkdownContent :: CodeFileParts -> FilePath -> FilePath -> String
mkMarkdownContent { langHighlight } fullFilePath filePathSegment = do
  joinWith "\n"
    [ "# " <> filePathSegment
    , ""
    , "```" <> langHighlight
    , "{{#include ../../" <> fullFilePath <> "}}"
    , "```"
    ]

-- | A monad that has the capability of determining the path type of a path,
-- | reading a directory for its child paths, and reading a file for its
-- | content.
class (Monad m) <= ReadPath m where
  readDir :: FilePath -> m (Array FilePath)

  readFile :: FilePath -> m String

  readPathType :: FilePath -> m (Maybe PathType)

class (Monad m) <= Renderer m where
  renderFile :: Int -> WebUrl -> FilePath -> m String

-- | A monad that has the capability of writing content to a given file path.
class (Monad m) <= WriteToFile m where
  writeToFile :: FilePath -> String -> m Unit

  mkDir :: FilePath -> m Unit

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
