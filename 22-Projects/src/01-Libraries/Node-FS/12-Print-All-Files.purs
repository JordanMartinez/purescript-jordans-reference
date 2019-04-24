module Learn.NodeFS.PrintAllFiles where

import Prelude

import Control.MonadPlus ((<|>))
import Data.Array (cons, snoc)
import Data.Foldable (foldl, intercalate)
import Data.List.Types (List(..), (:))
import Data.String.Utils (startsWith)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Node.FS.Aff as FS
import Node.FS.Stats as Stats
import Node.Path (FilePath, concat, normalize, sep)
import Node.Process (cwd)
import Options.Applicative (Parser, execParser, fullDesc, help, helper, info, long, metavar, progDesc, short, showDefault, strOption, value)

-- NOTE: this file uses Yargs. Overview that to fully understand
-- what is going on in the below code.

main :: Effect Unit
main = do
    rootDir <- execParser opts
    printAllFilesRecursively rootDir
  where
    opts = info (  helper
               <*> rootDirOption
                )
                ( fullDesc
               <> progDesc "This program will recursively print the paths of a \
                           \directory's files."
                )

rootDirOption :: Parser String
rootDirOption =
  strOption ( long "root-dir"
           <> short 'r'
           <> metavar "ROOT_DIR"
           <> help "Indicates the root directory for this repository on \
                   \a local computer. The default is '.' or the current \
                   \working directory."
           <> value "."
           <> showDefault
            )

printAllFilesRecursively :: String -> Effect Unit
printAllFilesRecursively rootDir = do
  -- Effect monadic context:
  currentWorkingDir <- cwd
  log "Root directory is:"
  log $ if rootDir == "." || (rootDir # startsWith ("." <> sep))
      then normalize $ concat [currentWorkingDir, rootDir]
      else rootDir

  log "Printing all paths within the root directory and all of its directories recursively:"
  launchAff_ do
    -- Aff monadic context:
    allFiles <- recursivelyIterateDir rootDir []
    liftEffect $ log $ "Files:\n" <>
      -- Combine all the paths (i.e. String instances) together but stick
      -- a "\n" character in-between each.
      intercalate "\n" allFiles

recursivelyIterateDir :: FilePath -> Array FilePath -> Aff (List FilePath)
recursivelyIterateDir baseDir baseToParentDir = do
  let folderPath = baseDir `cons` baseToParentDir
  paths <- FS.readdir $ concat folderPath

  {-
    In this next code block, we want to convert a path to the full path,
    relative to the root directory. In other words, if the root directory is,
    "/home/user/Documents/" and the full path is "/home/user/Documents/other/someFile.txt"
    we only want the "other/someFile.txt" part.

    Once we convert a path, we want to combine that result with
    all the other results we have already done. Thus, we can use Foldable's
    `foldl` to accomplish this: convert each path into its final result
    and then combine that with the other results we have.

    However, we can only determine whether a path is a file
    or a directory via `Stats.isFile`. To get the type that `Stats.isFile`
    requires as its input, we must use `FS.stat`, whose return type is `Aff Stats`.

    Thus, the accumulator function that we pass to `foldl` must use
    the Aff monad as its initial and return type. Otherwise, we will not be
    able to determine whether a path is a file/directory using this approach.
    See the type signature of `accumulator` for more info.

    For our initial value, we'll lift an empty List instance (Nil) into
    the Aff context via `pure`:
  -}
  foldl (accumulator baseDir baseToParentDir) (pure Nil) paths

accumulator :: FilePath -> Array FilePath -> Aff (List FilePath) -> FilePath -> Aff (List FilePath)
accumulator
  -- pass in the arguments from before, so we can re-use them here...
  baseDir baseToParentDir

  -- these arguments are the actual accumulator part
  listInAffMonad p = do
    let relativePath = baseToParentDir `snoc` p
    let fullPath = baseDir `cons` relativePath

    ifM (Stats.isFile <$> (FS.stat $ concat fullPath))

        -- path is a file (base case)
        (
          -- (\list -> cons relativePath list) <$> listInAffMonad
          ((concat relativePath) : _) <$> listInAffMonad
        )

        -- path is a directory (recursive case)
        (do
          -- get all file paths for this directory path
          children <- recursivelyIterateDir baseDir relativePath
          -- Semigroup's `append`/`<>` is for types with kind `Type` (e.g. String)
          -- Alt's `alt`/`<|>` is the same as Semigroup but for
          --    types with kind "Type -> Type" (e.g. List)
          -- Thus, `list1 <|> list2` will combine list1's contents with list2's contents
          -- and return a new list

          -- (\list -> children <|> list) <$> listInAffMonad
          (children <|> _) <$> listInAffMonad
        )
