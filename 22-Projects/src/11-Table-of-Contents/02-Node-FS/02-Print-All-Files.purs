module Learn.NodeFS.PrintAllFiles where

import Prelude
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Aff (Aff, launchAff_)
import Node.FS.Stats as Stats
import Node.FS.Aff as FS
import Node.Encoding (Encoding(UTF8))
import Node.Path (FilePath, normalize, dirname, basename, extname, relative, concat, sep)
import Node.Globals (__dirname)
import Data.Foldable (foldl, elem, intercalate)
import Data.Traversable (for)
import Data.String (length)
import Control.MonadPlus ((<|>))
import Data.List.Types (List(..), (:))
import Data.List as List
import Data.Array as Array
import Data.Maybe (Maybe(..))
import Data.Either (Either(..))

-- This module provides an easier interface to Yargs
import Node.Yargs.Applicative (flag, yarg, runY)

-- For any bindings or custom things you need outside of the basic
-- things that the above module provides, you'll need to use
-- Node.Yargs.Setup
import Node.Yargs.Setup (example, usage, version)

main :: Effect Unit
main = do
  let usageAndExample =
              usage "This program will print the paths of a directory's \
                    \contents (other directories or files)."
           <> example
                "node dist/table-of-contents/nodefs-syntax.js -r --rootDir '../"
                "If run in the 'Projects' folder, outputs paths of repository's\
                \top-level files and folders."
           <> example
                "node dist/table-of-contents/nodefs-syntax.js \
                  \--rootDir \"/home/user/projects/purescript-reference/22-Projects\""
                "Prints all paths of files in repo to console."

  runY usageAndExample $ printAllFilesRecursively
              <$> flag "r" ["use-relative-path"] (Just "Specifies that the rootdir argument is a relative path.")
              <*> yarg "rootdir" []
                    (Just "Indicates the root directory for this repository on a local computer.")
                    (Right "You need to provide an absolute path to the root directory of this repository.")
                    true

printAllFilesRecursively :: Boolean -> String -> Effect Unit
printAllFilesRecursively pathIsRelative pathToDir = do
  -- Effect monadic context:
  let absolutePath =
        if pathIsRelative then normalize (__dirname <> sep <> pathToDir) else pathToDir
  log "Root directory is:"
  log absolutePath

  log "Printing all paths within the root directory and all of its directories recursively:"
  launchAff_ do
    -- Aff monadic context:
    allFiles <- recursivelyIterateDir absolutePath ""
    liftEffect $ log $ "Files:\n" <>
      -- Combine all the paths (i.e. String instances) together but stick
      -- a "\n" character in-between each.
      intercalate "\n" allFiles

recursivelyIterateDir :: FilePath -> FilePath -> Aff (List FilePath)
recursivelyIterateDir baseDir baseToParentDir = do
  let folderPath = baseDir <> baseToParentDir
  paths <- FS.readdir folderPath

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

accumulator :: FilePath -> FilePath -> Aff (List FilePath) -> FilePath -> Aff (List FilePath)
accumulator
  -- pass in the arguments from before, so we can re-use them here...
  baseDir baseToParentDir

  -- these arguments are the actual accumulator part
  listInAffMonad p = do
    let relativePath = baseToParentDir <> p
    let fullPath = baseDir <> relativePath

    ifM (Stats.isFile <$> FS.stat fullPath)

        -- path is a file (base case)
        (
          -- (\list -> cons relativePath list) <$> listInAffMonad
          (relativePath : _) <$> listInAffMonad
        )

        -- path is a directory (recursive case)
        (do
          -- get all file paths for this directory path
          children <- recursivelyIterateDir baseDir (relativePath <> sep)
          -- Semigroup's `append`/`<>` is for types with kind `Type` (e.g. String)
          -- Alt's `alt`/`<|>` is the same as Semigroup but for
          --    types with kind "Type -> Type" (e.g. List)
          -- Thus, `list1 <|> list2` will combine list1's contents with list2's contents
          -- and return a new list

          -- (\list -> children <|> list) <$> listInAffMonad
          (children <|> _) <$> listInAffMonad
        )
