module Projects.ToC.Domain.BusinessLogic
  ( Env
  , FileExtension
  , RootToParentDir(..)
  , program
  , class GetTopLevelDirs, getTopLevelDirs
  , class ReadPath, readDir, readFile, readPathType
  , class WriteToFile, writeToFile
  , class LogToConsole, log
  ) where

import Prelude

import Control.Monad.Reader (class MonadAsk, ask, asks)
import Data.Either (Either(..))
import Data.Foldable (foldl, intercalate)
import Data.List (reverse)
import Data.List.Types (List(..), (:))
import Data.Maybe (Maybe(..), maybe)
import Data.Tree (Tree)
import Node.Path (FilePath, extname, sep)
import Projects.ToC.Core.FileTypes (GenHeaderLink, Directory(..), DirectoryPath(..), ParsedDirContent, PathType(..), TopLevelDirectory(..))

type FileExtension = String
newtype RootToParentDir = RootToParentDir FilePath

type Env = { rootDir :: FilePath
           , matchesTopLevelDir :: FilePath -> Boolean
           , includeRegularDir :: FilePath -> Boolean
           , includeFile :: FilePath -> Boolean
           , outputFile :: FilePath
           , parseContent :: FileExtension -> String -> List (Tree GenHeaderLink)
           , renderToCFile :: List TopLevelDirectory -> String
           }

program :: forall m.
           Monad m =>
           MonadAsk Env m =>
           LogToConsole m =>
           GetTopLevelDirs m =>
           ReadPath m =>
           WriteToFile m =>
           m Unit
program = do
  topLevelDirs <- getTopLevelDirs
  log $ "Top level dirs are: " <> intercalate "\n" (show <$> topLevelDirs)
  results <- foldl parseTopLevelDirContent (pure Nil) topLevelDirs
  output <- asks $ (\env -> env.renderToCFile results)
  writeToFile output

parseTopLevelDirContent :: forall m.
                           Monad m =>
                           MonadAsk Env m =>
                           LogToConsole m =>
                           LogToConsole m =>
                           ReadPath m =>
                           m (List TopLevelDirectory) -> DirectoryPath -> m (List TopLevelDirectory)
parseTopLevelDirContent listInMonad p = do
  let pString = show p
  log $ "Parsing toplevel content for path: " <> pString
  children <- recursivelyGetAndParseFiles (RootToParentDir "") p
  log $ "Finished parsing toplevel content for path: " <> pString <> "\n"
  listInMonad <#> (\list -> (TopLevelDirectory p children) : list)

recursivelyGetAndParseFiles :: forall m.
                               Monad m =>
                               MonadAsk Env m =>
                               LogToConsole m =>
                               ReadPath m =>
                               RootToParentDir -> DirectoryPath -> m ParsedDirContent
recursivelyGetAndParseFiles (RootToParentDir rtpDir) (DirectoryPath path) = do
  env <- ask
  let absoluteDirPath = env.rootDir <> rtpDir <> path
  log $ "Reading dir: " <> absoluteDirPath
  unparsedPaths <- readDir absoluteDirPath

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
    let fullDirPath = absoluteDirPath <> sep
    let fullChildPath = fullDirPath <> p
    pathType <- readPathType fullChildPath
    case pathType of
      Just Dir -> do
        if env.includeRegularDir p
          then do
            log $ "Directory found: " <> fullChildPath
            let rootToParent = rtpDir <> path <> sep
            let dirPath = DirectoryPath p
            children <- recursivelyGetAndParseFiles (RootToParentDir rootToParent) dirPath
            recInMonad <#> (\rec -> rec { list = (Left $ Directory dirPath children) : rec.list })
          else do
            log $ "Ignoring directory: " <> fullChildPath
            recInMonad
      Just File -> do
        if env.includeFile p
          then do
            log $ "File found: " <> fullChildPath
            content <- readFile fullChildPath
            -- TODO: parseContent needs to be fixed now, so that it will return 'fileWithHeaders' in correct type
            let fileWithHeaders = Right $
                  { fileName: p
                  , headers: env.parseContent (extname p) content
                  }
            recInMonad <#> (\rec ->
              if p == "ReadMe.md" || p == "Readme.md"
                then rec { readMe = Just fileWithHeaders }
                else rec { list = fileWithHeaders : rec.list }
              )
          else do
            log $ "Ignoring file: " <> fullChildPath
            recInMonad
      _ -> do
        log $ "Ignoring unknown path type: " <> fullChildPath
        recInMonad
  ) (pure { list: Nil, readMe: Nothing }) unparsedPaths
  log $ "Finished reading dir: " <> absoluteDirPath
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

-- | Gets the list of top-level directory paths where the first path is
-- | at the bottom of the list and the last path is at the top:
-- | `last path : ... : first path : Nil`
-- |
-- | The list should only contain the paths of top-level directories whose
-- | files (recusively) should be parsed.
class (Monad m) <= GetTopLevelDirs m where
  getTopLevelDirs :: m (List DirectoryPath)

class (Monad m) <= LogToConsole m where
  log :: String -> m Unit
