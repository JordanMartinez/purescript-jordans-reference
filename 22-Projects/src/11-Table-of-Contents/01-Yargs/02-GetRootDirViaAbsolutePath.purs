module Learn.Yargs.GetRootDirViaAbsolutePath where

import Prelude
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (log)

import Node.Yargs.Applicative (flag, yarg, runY)
import Node.Yargs.Setup (example, usage, version)
import Node.Path (FilePath, normalize, dirname, basename, extname, relative, concat, sep)
import Node.Globals (__dirname)

-- Since the path to this repository will change depending on which
-- local computer runs this program, we'll ask the user to
-- pass in the absolute path to this repository via a command line argument
-- via Yargs and then run the program based on that file path.
main :: Effect Unit
main = do
  let usageAndExample =
              usage "Shows how to pass in an absolute path to this repository's\
                    \root directory via the Yargs library."
           <> example
                "node getRootDir.js --rootDir \"/home/user/projects/purescript-reference/\""
                "Prints all paths of files in repo to console."

  -- since we are only working with one value, we'll just use 'pure' to get it
  -- before doing something more with it.
  runY usageAndExample $ app
              <$> yarg "rootdir" []
                    (Just "Indicates the root directory for this repository on a local computer.")
                    (Right "You need to provide an absolute path to the root directory of this repository.")
                    true
  where
    app :: String -> Effect Unit
    app rootDir = do
      log "The path you chose was:"
      log rootDir
