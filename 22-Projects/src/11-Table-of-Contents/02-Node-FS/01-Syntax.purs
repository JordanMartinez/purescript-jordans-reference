module Learn.NodeFS.Syntax where

import Prelude
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Aff (launchAff_)
import Node.FS.Stats as Stats
import Node.FS.Aff as FS
import Node.Path (normalize, sep)
import Node.Globals (__dirname)
import Data.Traversable (for)
import Data.Maybe (Maybe(..))
import Data.Either (Either(..))

-- This module provides an easier interface to Yargs
import Node.Yargs.Applicative (flag, yarg, runY)

-- For any bindings or custom things you need outside of the basic
-- things that the above module provides, you'll need to use
-- Node.Yargs.Setup
import Node.Yargs.Setup (example, usage)

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
                "Prints all paths of files in repo to console."
                "node dist/table-of-contents/nodefs-syntax.js --rootDir \"/home/user/projects/purescript-reference/\""

  runY usageAndExample $ printAll1stLevelFiles
              <$> flag "r" ["use-relative-path"] (Just "Specifies that the rootdir argument is a relative path.")
              <*> yarg "rootdir" []
                    (Just "Indicates the root directory for this repository on a local computer.")
                    (Right "You need to provide an absolute path to the root directory of this repository.")
                    true

printAll1stLevelFiles :: Boolean -> String -> Effect Unit
printAll1stLevelFiles pathIsRelative pathToDir = do
  let absolutePath =
        if pathIsRelative then normalize (__dirname <> sep <> pathToDir) else pathToDir
  log "Root directory is:"
  log absolutePath

  log "Printing paths of children for the root directory:"
  launchAff_ do
    paths <- FS.readdir absolutePath
    for paths (\p -> do
      stat <- FS.stat (absolutePath <> p)
      if (Stats.isFile stat)
        then
          liftEffect $ log $ "File found: " <> p
        else
          liftEffect $ log $ "Directory found: " <> p

      {-
        or... one could also write the above as:

          ifM (Stats.isFile <$> FS.stat (absolutePath <> p))
              (liftEffect $ log $ "File found: " <> p)
              (liftEffect $ log $ "Directory found: " <> p)
      -}

      -- We could also write content to a file here:
      -- FS.writeTextFile UTF8 path "some content"
    )
