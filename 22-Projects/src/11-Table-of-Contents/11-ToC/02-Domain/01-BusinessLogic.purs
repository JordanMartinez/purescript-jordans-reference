module Projects.ToC.Domain.BusinessLogic
  ( AllTopLevelContent
  , TopLevelContent
  , Env
  , program
  , class ReadPath, readDir, readFile, readPathType
  , class WriteToFile, writeToFile
  , class Logger, log, logInfo, logError, logDebug
  , class VerifyLink, verifyLink
  , LogLevel(..)
  ) where

import Prelude

import Control.Monad.Reader (class MonadAsk, ask)
import Control.Parallel (class Parallel, parTraverse)
import Data.Array (catMaybes)
import Data.List (List)
import Data.Maybe (Maybe(..))
import Data.Tree (Tree)
import Projects.ToC.Core.FileTypes (HeaderInfo)
import Projects.ToC.Core.Paths (FilePath, PathType(..), WebUrl, UriPath, AddPath)

type AllTopLevelContent = { allToCHeaders :: String
                          , allSections :: String
                          }

type TopLevelContent = { tocHeader :: String
                       , section :: String
                       }

type Env = { rootUri :: UriPath
           , addPath :: AddPath
           , matchesTopLevelDir :: FilePath -> Boolean
           , includeRegularDir :: FilePath -> Boolean
           , includeFile :: FilePath -> Boolean
           , outputFile :: FilePath
           , parseFile :: FilePath -> String -> List (Tree HeaderInfo)
           , renderToC :: Array TopLevelContent -> String
           , renderTopLevel :: FilePath -> Array String -> TopLevelContent
           , renderDir :: Int -> FilePath -> Array String -> String
           , renderFile :: Int -> Maybe WebUrl -> FilePath -> List (Tree HeaderInfo) -> String
           , logLevel :: LogLevel
           }

program :: forall m f.
           Monad m =>
           MonadAsk Env m =>
           Parallel f m =>
           Logger m =>
           ReadPath m =>
           WriteToFile m =>
           VerifyLink m =>
           m Unit
program = do
  output <- renderFiles
  writeToFile output

renderFiles :: forall m f.
               Monad m =>
               MonadAsk Env m =>
               Parallel f m =>
               Logger m =>
               ReadPath m =>
               WriteToFile m =>
               VerifyLink m =>
               m String
renderFiles = do
  env <- ask
  paths <- readDir env.rootUri.fs
  sections <- catMaybes <$> renderSectionsOrNothing env paths
  pure $ env.renderToC sections

  where
    renderSectionsOrNothing :: Env -> Array FilePath -> m (Array (Maybe TopLevelContent))
    renderSectionsOrNothing env paths =
      paths # parTraverse \topLevelPath -> do
        let fullPath = env.addPath env.rootUri topLevelPath
        pathType <- readPathType fullPath.fs
        case pathType of
          Just Dir | env.matchesTopLevelDir topLevelPath -> do
            output <- renderTopLevelSection fullPath topLevelPath
            pure $ Just output
          _ -> pure $ Nothing

renderTopLevelSection :: forall m f.
                         Monad m =>
                         MonadAsk Env m =>
                         Parallel f m =>
                         Logger m =>
                         ReadPath m =>
                         WriteToFile m =>
                         VerifyLink m =>
                         UriPath -> FilePath -> m TopLevelContent
renderTopLevelSection topLevelFullPath topLevelPathSegment = do
  unparsedPaths <- readDir topLevelFullPath.fs
  renderedPaths <- catMaybes <$> parTraverse (renderPath 0 topLevelFullPath) unparsedPaths
  env <- ask
  pure $ env.renderTopLevel topLevelPathSegment renderedPaths

renderPath :: forall m f.
              Monad m =>
              MonadAsk Env m =>
              Parallel f m =>
              Logger m =>
              ReadPath m =>
              WriteToFile m =>
              VerifyLink m =>
              Int -> UriPath -> FilePath -> m (Maybe String)
renderPath depth fullParentPath childPath = do
  env <- ask
  let fullChildPath = env.addPath fullParentPath childPath
  pathType <- readPathType fullChildPath.fs
  case pathType of
    Just Dir
      | env.includeRegularDir childPath -> do
          output <- renderDir depth fullChildPath childPath
          pure $ Just output
      | otherwise                       -> pure Nothing
    Just File
      | env.includeFile childPath -> do
          output <- renderFile depth fullChildPath childPath
          pure $ Just output
      | otherwise                 -> pure Nothing
    _ -> pure Nothing

renderDir :: forall m f.
             Monad m =>
             MonadAsk Env m =>
             Parallel f m =>
             Logger m =>
             ReadPath m =>
             WriteToFile m =>
             VerifyLink m =>
             Int -> UriPath -> FilePath -> m String
renderDir depth fullDirPath dirPathSegment = do
  env <- ask
  unparsedPaths <- readDir fullDirPath.fs
  renderedPaths <- catMaybes <$> parTraverse (renderPath (depth + 1) fullDirPath) unparsedPaths
  pure $ env.renderDir depth dirPathSegment renderedPaths

renderFile :: forall m.
              Monad m =>
              MonadAsk Env m =>
              Logger m =>
              ReadPath m =>
              WriteToFile m =>
              VerifyLink m =>
              Int -> UriPath -> FilePath -> m String
renderFile depth fullFilePath filePathSegment = do
  let fullFsPath = fullFilePath.fs
  let fullUrl = fullFilePath.url
  linkWorks <- verifyLink fullUrl
  let url = if linkWorks then Just fullUrl else Nothing
  content <- readFile fullFsPath
  env <- ask
  let headers = env.parseFile filePathSegment content
  pure $ env.renderFile depth url filePathSegment headers

-- | Reads the filesystem path from the root d
class (Monad m) <= ReadPath m where
  readDir :: FilePath -> m (Array FilePath)

  readFile :: FilePath -> m String

  readPathType :: FilePath -> m (Maybe PathType)

class (Monad m) <= WriteToFile m where
  writeToFile :: String -> m Unit

class (Monad m) <= VerifyLink m where
  verifyLink :: WebUrl -> m Boolean

data LogLevel
  = Error
  | Info
  | Debug

derive instance eqLogLevel :: Eq LogLevel
derive instance ordLogLevel :: Ord LogLevel

class (Monad m) <= Logger m where
  log :: LogLevel -> String -> m Unit

logError :: forall m. Logger m => String -> m Unit
logError msg = log Error msg

logInfo :: forall m. Logger m => String -> m Unit
logInfo msg = log Info msg

logDebug :: forall m. Logger m => String -> m Unit
logDebug msg = log Debug msg
