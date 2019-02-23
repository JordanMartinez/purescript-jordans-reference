module Projects.ToC.Domain.BusinessLogic
  ( Env
  , program
  , class ReadPath, readDir, readFile, readPathType
  , class WriteToFile, writeToFile
  , class LogToConsole, log
  , LogLevel(..)
  ) where

import Prelude

import Control.Monad.Reader (class MonadAsk, ask, asks)
import Data.Either (Either(..))
import Data.Foldable (foldl, intercalate)
import Data.List (reverse)
import Data.List.Types (List(..), (:))
import Data.Maybe (Maybe(..), maybe)
import Data.Tree (Tree)
import Node.Path (extname)
import Projects.ToC.Core.FileTypes (GenHeaderLink, Directory(..), ParsedDirContent, TopLevelDirectory(..))
import Projects.ToC.Core.Paths (AddPath, DirectoryPath(..), FileExtension, FilePath, PathType(..), PathUri, WebUrl)

type Env = { rootUri :: PathUri
           , addPath :: AddPath
           , matchesTopLevelDir :: FilePath -> Boolean
           , includeRegularDir :: FilePath -> Boolean
           , includeFile :: FilePath -> Boolean
           , outputFile :: FilePath
           , parseContent :: WebUrl -> FileExtension -> String -> List (Tree GenHeaderLink)
           , renderToCFile :: List TopLevelDirectory -> String
           , logLevel :: LogLevel
           }

program :: forall m.
           Monad m =>
           MonadAsk Env m =>
           LogToConsole m =>
           ReadPath m =>
           WriteToFile m =>
           m Unit
program = do
  topLevelDirs <- getTopLevelDirs
  logInfo $ "Top level dirs are: "
  logInfo $ intercalate "\n" topLevelDirs <> "\n"

  logInfo "Parsing top level directories..."
  results <- foldl parseTopLevelDirContent (pure Nil) topLevelDirs

  logInfo "Rendering parsed content..."
  output <- asks $ (\env -> env.renderToCFile results)

  logInfo "Writing content to file..."
  writeToFile output

  logInfo "Finished."

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
  paths <- readDir env.rootUri.fs
  foldl (\listInMonad path -> do
    let fullPath = env.addPath env.rootUri path
    pathType <- readPathType fullPath.fs
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
  children <- recursivelyGetAndParseFiles $ env.addPath env.rootUri p
  logInfo $ "Finished parsing toplevel content for path: " <> p
  listInMonad <#> (\list -> (TopLevelDirectory (DirectoryPath p) children) : list)

recursivelyGetAndParseFiles :: forall m.
                               Monad m =>
                               MonadAsk Env m =>
                               LogToConsole m =>
                               ReadPath m =>
                               PathUri -> m ParsedDirContent
recursivelyGetAndParseFiles fullPathUri = do
  env <- ask
  logDebug $ "Reading dir: " <> fullPathUri.fs
  unparsedPaths <- readDir fullPathUri.fs

  {-
    We're going to do 2 things in the next few lines of code
      - primary:
          Walk the file tree and only include the directories and files
            that should be included.
          When we come across a file that should be included, we'll attempt
            to parse it for any headers.
      - secondary:
          sort the output, so that the order of content in the ToC appears like so:
            1. ReadMe.md (if it exists)
            2. Numerical paths (e.g. paths starting with 01..99)
            3. All other paths

    The 'numerical paths' will naturally be read by the filesystem
    before the 'all other paths'. While one could go further and insure that
    the files are sorted no matter what, I'm not going to do that here
    because it is outside the scope of this project.

    Thus, we only need to account for the ReadMe file. To do this,
    we'll store the ReadMe file separately from the other files and then
    append it to our final list, so that it is first.
  -}
  rec <- foldl (\recInMonad p -> do
    let fullChildPath = env.addPath fullPathUri p
    pathType <- readPathType fullChildPath.fs
    case pathType of
      Just Dir -> do
        if env.includeRegularDir p
          then do
            logDebug $ "Directory found: " <> fullChildPath.fs
            children <- recursivelyGetAndParseFiles fullChildPath
            let dirPath = DirectoryPath p
            recInMonad <#> (\rec -> rec { list = (Left $ Directory dirPath children) : rec.list })
          else do
            logDebug $ "Ignoring directory: " <> fullChildPath.fs
            recInMonad
      Just File -> do
        if env.includeFile p
          then do
            logDebug $ "File found: " <> fullChildPath.fs
            -- TODO: check file's URL to ensure it's valid before parsing it for headers.
            content <- readFile fullChildPath.fs
            let fileWithHeaders = Right $
                  { fileName: p
                  , headers: env.parseContent fullChildPath.url (extname p) content
                  }
            recInMonad <#> (\rec ->
              if p == "ReadMe.md" || p == "Readme.md"
                then rec { readMe = Just fileWithHeaders }
                else rec { list = fileWithHeaders : rec.list }
              )
          else do
            logDebug $ "Ignoring file: " <> fullChildPath.fs
            recInMonad
      _ -> do
        logDebug $ "Ignoring unknown path type: " <> fullChildPath.fs
        recInMonad
  ) (pure { list: Nil, readMe: Nothing }) unparsedPaths
  logDebug $ "Finished reading dir: " <> fullPathUri.fs
  -- now we append the readme to the front of the list, if it exists,
  -- and use "pure" to lift the final list into the monad we're using.
  let reversedList = reverse rec.list
  pure $ maybe reversedList (\readMe -> readMe : reversedList) rec.readMe

-- | Reads the filesystem path from the root d
class (Monad m) <= ReadPath m where
  readDir :: FilePath -> m (Array FilePath)

  readFile :: FilePath -> m String

  readPathType :: FilePath -> m (Maybe PathType)

class (Monad m) <= WriteToFile m where
  writeToFile :: String -> m Unit

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
