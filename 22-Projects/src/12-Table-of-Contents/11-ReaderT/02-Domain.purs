module ToC.ReaderT.Domain
  ( program
  , class ReadPath, readDir, readFile, readPathType
  , class WriteToFile, writeToFile
  , class FileParser, parseFile
  , class Renderer, renderFile, renderDir, renderTopLevel, renderToC
  , class Logger, log, logInfo, logError, logDebug
  , class VerifyLink, verifyLink
  ) where

import Prelude

import Control.Monad.Reader (class MonadAsk, ask)
import Data.Array (catMaybes, intercalate, sortBy)
import Data.List (List)
import Data.Maybe (Maybe(..))
import Data.Traversable (traverse)
import Data.Tree (Tree, showTree)
import ToC.Core.FileTypes (HeaderInfo)
import ToC.Core.Paths (FilePath, PathType(..), IncludeablePathType(..), UriPath, WebUrl)
import ToC.Core.RenderTypes (TopLevelContent)
import ToC.Domain.Types (Env, LogLevel(..))

program :: forall m r.
           Monad m =>
           MonadAsk (Env r) m =>
           Logger m =>
           ReadPath m =>
           FileParser m =>
           Renderer m =>
           WriteToFile m =>
           VerifyLink m =>
           m Unit
program = do
  output <- renderFiles
  logInfo "Finished rendering files. Now writing to file."
  writeToFile output
  logInfo "Done."

-- | Recursively walks the file tree, starting at the root directory
-- | and renders each file and directory that should be included.
renderFiles :: forall m r.
               Monad m =>
               MonadAsk (Env r) m =>
               Logger m =>
               ReadPath m =>
               FileParser m =>
               Renderer m =>
               VerifyLink m =>
               m String
renderFiles = do
  env <- ask
  paths <- readDir env.rootUri.fs
  let sortedPaths = sortBy env.sortPaths paths
  logDebug $ "All possible top-level directories\n" <> intercalate "\n" sortedPaths
  sections <- catMaybes <$> renderSectionsOrNothing env sortedPaths
  renderToC sections

  where
    -- | More or less maps the unrendered top-level directory array into
    -- | rendered top-level directory array.
    renderSectionsOrNothing :: Env r -> Array FilePath -> m (Array (Maybe TopLevelContent))
    renderSectionsOrNothing env paths =
      -- the function that follows 'parTraverse' is done in parallel
      paths # traverse \topLevelPath -> do
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
                         FileParser m =>
                         Renderer m =>
                         VerifyLink m =>
                         UriPath -> FilePath -> m TopLevelContent
renderTopLevelSection topLevelFullPath topLevelPathSegment = do
  env <- ask
  unparsedPaths <- readDir topLevelFullPath.fs
  let sortedPaths = sortBy env.sortPaths unparsedPaths
  renderedPaths <- catMaybes <$> traverse (renderPath 0 topLevelFullPath) sortedPaths
  renderTopLevel topLevelPathSegment renderedPaths

-- | Renders the given path, whether it is a directory or a file.
renderPath :: forall m r.
              Monad m =>
              MonadAsk (Env r) m =>
              Logger m =>
              ReadPath m =>
              FileParser m =>
              Renderer m =>
              VerifyLink m =>
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
                   FileParser m =>
                   Renderer m =>
                   VerifyLink m =>
                   Int -> UriPath -> FilePath -> m String
renderDirectory depth fullDirPath dirPathSegment = do
  env <- ask
  unparsedPaths <- readDir fullDirPath.fs
  let sortedPaths = sortBy env.sortPaths unparsedPaths
  renderedPaths <- catMaybes <$> traverse (renderPath (depth + 1) fullDirPath) sortedPaths
  renderDir depth dirPathSegment renderedPaths

-- | Renders the given file and all of its headers
renderOneFile :: forall m r.
                  Monad m =>
                  MonadAsk (Env r) m =>
                  Logger m =>
                  ReadPath m =>
                  FileParser m =>
                  Renderer m =>
                  VerifyLink m =>
                  Int -> UriPath -> FilePath -> m String
renderOneFile depth fullFilePath filePathSegment = do
  let fullFsPath = fullFilePath.fs
  let fullUrl = fullFilePath.url
  env <- ask
  url <-
    if env.shouldVerifyLinks
      then do
        linkWorks <- verifyLink fullUrl
        if linkWorks
            then do
              logInfo $ "Successful link for: " <> fullFsPath
              pure $ Just fullUrl
            else do
              logError $ "File with invalid link: " <> fullFsPath
              logError $ "Link was: " <> fullUrl
              pure Nothing
      else do
        pure $ Just fullUrl
  content <- readFile fullFsPath
  headers <- parseFile filePathSegment content
  logDebug $ "Headers for file:"
  logDebug $ intercalate "\n" (showTree <$> headers)
  renderFile depth url filePathSegment headers

-- | A monad that has the capability of determining the path type of a path,
-- | reading a directory for its child paths, and reading a file for its
-- | content.
class (Monad m) <= ReadPath m where
  readDir :: FilePath -> m (Array FilePath)

  readFile :: FilePath -> m String

  readPathType :: FilePath -> m (Maybe PathType)

class (Monad m) <= FileParser m where
  parseFile :: FilePath -> String -> m (List (Tree HeaderInfo))

class (Monad m) <= Renderer m where
  renderFile :: Int -> Maybe WebUrl -> FilePath -> List (Tree HeaderInfo) -> m String

  renderDir :: Int -> FilePath -> Array String -> m String

  renderTopLevel :: FilePath -> Array String -> m TopLevelContent

  renderToC :: Array TopLevelContent -> m String

-- | A monad that has the capability of writing content to a given file path.
class (Monad m) <= WriteToFile m where
  writeToFile :: String -> m Unit

-- | A monad that has the capability of sending HTTP requests, which are
-- | used to verify that the URL is valid and receives a 200 OK code.
class (Monad m) <= VerifyLink m where
  verifyLink :: WebUrl -> m Boolean

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
