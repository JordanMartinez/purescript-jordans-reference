module Projects.ToC.Domain.BusinessLogic
  ( Env
  , program
  , class ReadPath, readDir, readFile, readPathType
  , class WriteToFile, writeToFile
  , class LogToConsole, log, logInfo, logError, logDebug
  , class VerifyLinks, verifyLinks
  , LogLevel(..)
  ) where

import Prelude

import Control.Monad.Reader (class MonadAsk, ask, asks)
import Data.Either (Either(..), either)
import Data.Foldable (foldl, intercalate)
import Data.List (null, sortBy)
import Data.List.Types (List(..), (:))
import Data.Maybe (Maybe(..))
import Data.Traversable (for)
import Data.Tree (Tree)
import Node.Path (extname)
import Projects.ToC.Core.FileTypes (Directory(..), HeaderInfo, ParsedDirContent, TopLevelDirectory(..))
import Projects.ToC.Core.Paths (AddPath, DirectoryPath(..), FileExtension, FilePath, PathType(..), WebUrl, addPath')

type Env = { rootDir :: FilePath
           , rootUrl :: WebUrl
           , addFilePath :: AddPath
           , matchesTopLevelDir :: FilePath -> Boolean
           , includeRegularDir :: FilePath -> Boolean
           , includeFile :: FilePath -> Boolean
           , outputFile :: FilePath
           , parseContent :: FileExtension -> String -> List (Tree HeaderInfo)
           , renderToC :: AddPath -> WebUrl -> List TopLevelDirectory -> { content :: String, links :: List WebUrl }
           , logLevel :: LogLevel
           }

program :: forall m.
           Monad m =>
           MonadAsk Env m =>
           LogToConsole m =>
           ReadPath m =>
           WriteToFile m =>
           VerifyLinks m =>
           m Unit
program = do
  topLevelDirs <- getTopLevelDirs
  logInfo $ "Top level dirs are: "
  logInfo $ intercalate "\n" topLevelDirs <> "\n"

  logInfo "Parsing top level directories..."
  results <- foldl parseTopLevelDirContent (pure Nil) topLevelDirs

  logInfo "Rendering parsed content..."
  env <- ask
  let output = env.renderToC (addPath' "/") env.rootUrl results

  logInfo "Verifying that all links work..."
  badLinks <- verifyLinks output.links
  if null badLinks
    then do
      logInfo "All links are valid."
      logInfo "Writing content to file..."
      writeToFile output.content

      logInfo "Finished."
    else do
      logError "Error. The following links did not return an 'OK' / \
               \200 Status Code. Bad links will be printed and program \
               \will exit."
      void $ for badLinks (\link ->
        logError $ "Invalid Link: " <> link
      )

-- | Gets the list of top-level directory paths where the first path is
-- | at the bottom of the list and the last path is at the top:
-- | `last path : ... : first path : Nil`
-- |
-- | The list should only contain the paths of top-level directories whose
-- | files (recusively) should be parsed.
getTopLevelDirs :: forall m.
                   Monad m =>
                   MonadAsk Env m =>
                   ReadPath m => m (List FilePath)
getTopLevelDirs = do
  env <- ask
  paths <- readDir env.rootDir
  foldl (\listInMonad path -> do
    let fullPath = env.addFilePath env.rootDir path
    pathType <- readPathType fullPath
    case pathType of
      Just Dir | env.matchesTopLevelDir path ->
        (\list -> path : list) <$> listInMonad
      _ -> listInMonad
  ) (pure Nil) paths

parseTopLevelDirContent :: forall m.
                           Monad m =>
                           MonadAsk Env m =>
                           LogToConsole m =>
                           ReadPath m =>
                           m (List TopLevelDirectory) -> FilePath -> m (List TopLevelDirectory)
parseTopLevelDirContent listInMonad p = do
  env <- ask
  logInfo $ "Parsing toplevel content for path: " <> p
  children <- recursivelyGetAndParseFiles $ env.addFilePath env.rootDir p
  logInfo $ "Finished parsing toplevel content for path: " <> p
  listInMonad <#> (\list -> (TopLevelDirectory (DirectoryPath p) children) : list)

recursivelyGetAndParseFiles :: forall m.
                               Monad m =>
                               MonadAsk Env m =>
                               LogToConsole m =>
                               ReadPath m =>
                               FilePath -> m ParsedDirContent
recursivelyGetAndParseFiles fullPathUri = do
  env <- ask
  logDebug $ "Reading dir: " <> fullPathUri
  unparsedPaths <- readDir fullPathUri

  list <- foldl (accumulate env) (pure Nil) unparsedPaths
  logDebug $ "Finished reading dir: " <> fullPathUri
  pure $ list # sortBy \l r ->
    let
      getPath = either (\(Directory (DirectoryPath p) _)-> p) _.fileName
      left = getPath l
      right = getPath r
    in
      if left == "ReadMe.md" || left == "Readme.md"
        then LT
        else compare left right

  where
    -- | Walk the file tree and only include the directories and files
    -- | that should be included. When we come across a file that should be
    -- | included, we'll attempt to parse it for any headers.
    accumulate :: Env ->
                  m ParsedDirContent ->
                  FilePath ->
                  m ParsedDirContent
    accumulate env listInMonad p = do
      let fullChildPath = env.addFilePath fullPathUri p
      pathType <- readPathType fullChildPath
      case pathType of
        Just Dir
          | env.includeRegularDir p -> do
              logDebug $ "Directory found: " <> fullChildPath
              children <- recursivelyGetAndParseFiles fullChildPath
              listInMonad <#> (\list ->
                (Left $ Directory (DirectoryPath p) children) : list
              )
          | otherwise -> do
              logDebug $ "Ignoring directory: " <> fullChildPath
              listInMonad
        Just File
          | env.includeFile p -> do
              logDebug $ "File found: " <> fullChildPath
              content <- readFile fullChildPath
              let headers = env.parseContent (extname p) content
              let fileWithHeaders = Right $
                    { fileName: p
                    , headers: headers
                    }
              listInMonad <#> (\list -> fileWithHeaders : list )
          | otherwise -> do
              logDebug $ "Ignoring file: " <> fullChildPath
              listInMonad
        _ -> do
          logDebug $ "Ignoring unknown path type: " <> fullChildPath
          listInMonad

-- | Reads the filesystem path from the root d
class (Monad m) <= ReadPath m where
  readDir :: FilePath -> m (Array FilePath)

  readFile :: FilePath -> m String

  readPathType :: FilePath -> m (Maybe PathType)

class (Monad m) <= WriteToFile m where
  writeToFile :: String -> m Unit

class (Monad m) <= VerifyLinks m where
  verifyLinks :: List WebUrl -> m (List WebUrl)

data LogLevel
  = Error
  | Info
  | Debug

derive instance eqLogLevel :: Eq LogLevel
derive instance ordLogLevel :: Ord LogLevel

class (Monad m) <= LogToConsole m where
  log :: LogLevel -> String -> m Unit

logError :: forall m. LogToConsole m => String -> m Unit
logError msg = log Error msg

logInfo :: forall m. LogToConsole m => String -> m Unit
logInfo msg = log Info msg

logDebug :: forall m. LogToConsole m => String -> m Unit
logDebug msg = log Debug msg
