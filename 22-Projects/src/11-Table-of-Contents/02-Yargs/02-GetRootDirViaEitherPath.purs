module Learn.Yargs.GetRootDirViaEitherPath where

import Prelude
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (log)

-- This module provides an easier interface to Yargs
import Node.Yargs.Applicative (flag, yarg, runY)

-- For any bindings or custom things you need outside of the basic
-- things that the above module provides, you'll need to use
-- Node.Yargs.Setup
import Node.Yargs.Setup (example, usage)
import Node.Path (FilePath, normalize, sep)
import Node.Globals (__dirname)

-- The previous file's code works, but using an absolute path is rather verbose.
-- What if we could decide to pass in a relative path based on where we
-- start the program?
main :: Effect Unit
main = do
  let usageAndExample =
           usage "Shows how to pass in either an absolute or relative path \
                 \to this repository's root directory via the Yargs library."
        <> example
             "node getRootDir.js --rootDir \"/home/user/projects/purescript-reference/\""
             "Using an absolute path, prints all paths of files in repo to console."
        <> example
             "node getRootDir.js -r --rootDir '../../'"
             "Using an absolute path, prints all paths of files in repo to console."

  -- since we are only working with one value, we'll just use 'pure' to get it
  -- before doing something more with it.
  runY usageAndExample $ app
              <$> flag "r" ["use-relative-path"] (Just "Specifies that the rootdir argument is a relative path.")
              <*> yarg "rootdir" []
                    (Just "Indicates the root directory for this repository on a local computer.")
                    (Right "You need to provide an absolute path to the root directory of this repository.")
                    true

  where
    app :: Boolean -> FilePath -> Effect Unit
    app useRelativePath pathToDir = do
      log "The path you chose was:"
      if useRelativePath
        then
          -- Combine the name of the directory from which this program was run
          -- with the passed-in relative path, inserting the OS-specific
          -- file separator character in-between the two.
          --
          -- Then, normalize the path, so that "." and ".." are 'solved'
          log $ normalize (__dirname <> sep <> pathToDir)
        else
          -- Otherwise, assume that path is an absolute path and just print it.
          log pathToDir
