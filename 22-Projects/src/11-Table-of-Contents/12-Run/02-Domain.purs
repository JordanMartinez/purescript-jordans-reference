module ToC.Run.Domain
  ( program
  , ReadPathF(..), _readPath, READ_PATH, readDir, readFile, readPathType
  , WriteToFileF(..), _writeToFile, WRITE_TO_FILE, writeToFile
  , LoggerF(..), _logger, LOGGER, log, logInfo, logError, logDebug
  , VerifyLinkF(..), _verifyLink, VERIFY_LINK, verifyLink
  ) where

import Prelude

import Data.Array (catMaybes, intercalate, sortBy)
import Data.Maybe (Maybe(..))
import Data.Symbol (SProxy(..))
import Data.Traversable (traverse)
import Data.Tree (showTree)
import Data.Variant.Internal (FProxy)
import Run (Run, lift)
import Run.Reader (READER, ask)
import ToC.Core.Paths (FilePath, PathType(..), UriPath, WebUrl)
import ToC.Core.RenderTypes (TopLevelContent)
import ToC.Domain.Types (Env, LogLevel(..))
import Type.Row (type (+))

-- Define language / capabilties

data ReadPathF a
  = ReadDir FilePath (Array FilePath -> a)
  | ReadFile FilePath (String -> a)
  | ReadPathType FilePath (Maybe PathType -> a)

derive instance functorReadPathF :: Functor ReadPathF

_readPath = SProxy :: SProxy "readPath"

type READ_PATH r = (readPath :: FProxy ReadPathF | r)

readDir :: forall r. FilePath -> Run (READ_PATH + r) (Array FilePath)
readDir path = lift _readPath (ReadDir path identity)

readFile :: forall r. FilePath -> Run (READ_PATH + r) String
readFile path = lift _readPath (ReadFile path identity)

readPathType :: forall r. FilePath -> Run (READ_PATH + r) (Maybe PathType)
readPathType path = lift _readPath (ReadPathType path identity)

data WriteToFileF a = WriteToFile String a

derive instance functorWriteToFileF :: Functor WriteToFileF

_writeToFile = SProxy :: SProxy "writeToFile"

type WRITE_TO_FILE r = (writeToFile :: FProxy WriteToFileF | r)

writeToFile :: forall r. String -> Run (WRITE_TO_FILE + r) Unit
writeToFile content = lift _writeToFile (WriteToFile content unit)


data VerifyLinkF a = VerifyLink WebUrl (Boolean -> a)
derive instance functorVerifyLinkF :: Functor VerifyLinkF

_verifyLink = SProxy :: SProxy "verifyLink"

type VERIFY_LINK r = (verifyLink :: FProxy VerifyLinkF | r)

verifyLink :: forall r. WebUrl -> Run (VERIFY_LINK + r) Boolean
verifyLink url = lift _verifyLink (VerifyLink url identity)

data LoggerF a = Log LogLevel String a
derive instance functorLoggerF :: Functor LoggerF

_logger = SProxy :: SProxy "logger"

type LOGGER r = (logger :: FProxy LoggerF | r)

log :: forall r. LogLevel -> String -> Run (LOGGER + r) Unit
log level msg = lift _logger (Log level msg unit)

-- | Logs a message using the Error level
logError :: forall r. String -> Run (LOGGER + r) Unit
logError = log Error

-- | Logs a message using the Info level
logInfo :: forall r. String -> Run (LOGGER + r) Unit
logInfo = log Info

-- | Logs a message using the Debug level
logDebug :: forall r. String -> Run (LOGGER + r) Unit
logDebug = log Debug

program :: forall r
         . Run ( reader :: READER Env
               | READ_PATH
               + WRITE_TO_FILE
               + VERIFY_LINK
               + LOGGER
               + r
               )
               Unit
program = do
  output <- renderFiles
  logInfo "Finished rendering files. Now writing to file."
  writeToFile output
  logInfo "Done."

-- | Recursively walks the file tree, starting at the root directory
-- | and renders each file and directory that should be included.
renderFiles :: forall r
             . Run ( reader :: READER Env
                   | READ_PATH
                   + VERIFY_LINK
                   + LOGGER
                   + r
                   )
                   String
renderFiles = do
  env <- ask
  paths <- readDir env.rootUri.fs
  let sortedPaths = sortBy env.sortPaths paths
  logDebug $ "All possible top-level directories\n" <> intercalate "\n" sortedPaths
  sections <- catMaybes <$> renderSectionsOrNothing env sortedPaths
  pure $ env.renderToC sections

  where
    -- | More or less maps the unrendered top-level directory array into
    -- | rendered top-level directory array.
    renderSectionsOrNothing :: Env -> Array FilePath ->
                               Run ( reader :: READER Env
                                   | READ_PATH
                                   + VERIFY_LINK
                                   + LOGGER
                                   + r
                                   ) (Array (Maybe TopLevelContent))
    renderSectionsOrNothing env paths =
      -- the function that follows 'parTraverse' is done in parallel
      paths # traverse \topLevelPath -> do
        let fullPath = env.addPath env.rootUri topLevelPath
        pathType <- readPathType fullPath.fs
        case pathType of
          Just Dir | env.matchesTopLevelDir topLevelPath -> do
            logDebug $ "Rendering top-level directory (start): " <> fullPath.fs
            output <- renderTopLevelSection fullPath topLevelPath
            logDebug $ "Rendering top-level directory (done) : " <> fullPath.fs
            pure $ Just output
          _ -> pure $ Nothing

-- | Renders a single top-level directory, using its already-rendered
-- | child paths.
renderTopLevelSection :: forall r.
                         UriPath -> FilePath ->
                         Run ( reader :: READER Env
                             | READ_PATH
                             + VERIFY_LINK
                             + LOGGER
                             + r
                             ) TopLevelContent
renderTopLevelSection topLevelFullPath topLevelPathSegment = do
  env <- ask
  unparsedPaths <- readDir topLevelFullPath.fs
  let sortedPaths = sortBy env.sortPaths unparsedPaths
  renderedPaths <- catMaybes <$> traverse (renderPath 0 topLevelFullPath) sortedPaths
  pure $ env.renderTopLevel topLevelPathSegment renderedPaths

-- | Renders the given path, whether it is a directory or a file.
renderPath :: forall r.
              Int -> UriPath -> FilePath ->
              Run ( reader :: READER Env
                  | READ_PATH
                  + VERIFY_LINK
                  + LOGGER
                  + r
                  ) (Maybe String)
renderPath depth fullParentPath childPath = do
  env <- ask
  let fullChildPath = env.addPath fullParentPath childPath
  pathType <- readPathType fullChildPath.fs
  case pathType of
    Just Dir
      | env.includeRegularDir childPath -> do
          logDebug $ "Rendering directory (start): " <> fullChildPath.fs
          output <- renderDir depth fullChildPath childPath
          logDebug $ "Rendering directory (done) : " <> fullChildPath.fs
          pure $ Just output
      | otherwise                       -> do
          logDebug $ "Excluding directory: " <> fullChildPath.fs
          pure Nothing
    Just File
      | env.includeFile childPath -> do
          logDebug $ "Rendering File (start): " <> fullChildPath.fs
          output <- renderFile depth fullChildPath childPath
          logDebug $ "Rendering File (done) : " <> fullChildPath.fs
          pure $ Just output
      | otherwise                 -> do
          logDebug $ "Excluding File: " <> fullChildPath.fs
          pure Nothing
    _ -> do
      logInfo $ "Unknown path type: " <> fullChildPath.fs
      pure Nothing

-- | Renders the given directory and all of its already-rendered child paths
renderDir :: forall r.
             Int -> UriPath -> FilePath ->
             Run ( reader :: READER Env
                 | READ_PATH
                 + VERIFY_LINK
                 + LOGGER
                 + r
                 ) String
renderDir depth fullDirPath dirPathSegment = do
  env <- ask
  unparsedPaths <- readDir fullDirPath.fs
  let sortedPaths = sortBy env.sortPaths unparsedPaths
  renderedPaths <- catMaybes <$> traverse (renderPath (depth + 1) fullDirPath) sortedPaths
  pure $ env.renderDir depth dirPathSegment renderedPaths

-- | Renders the given file and all of its headers
renderFile :: forall r.
              Int -> UriPath -> FilePath ->
              Run ( reader :: READER Env
                  | READ_PATH
                  + VERIFY_LINK
                  + LOGGER
                  + r
                  ) String
renderFile depth fullFilePath filePathSegment = do
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
  let headers = env.parseFile filePathSegment content
  logDebug $ "Headers for file:"
  logDebug $ intercalate "\n" (showTree <$> headers)
  pure $ env.renderFile depth url filePathSegment headers
