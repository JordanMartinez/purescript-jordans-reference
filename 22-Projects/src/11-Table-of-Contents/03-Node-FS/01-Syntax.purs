module Learn.NodeFS.Syntax where

import Prelude

import Data.Traversable (for)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Node.FS.Aff as FS
import Node.FS.Stats as Stats
import Node.Path (sep)
import Node.Process (cwd)

main :: Effect Unit
main = do
  currentWorkingDir <- cwd
  log $ "Current working directory: " <> currentWorkingDir
  launchAff_ do
    paths <- FS.readdir "."
    for paths \p -> do
      stat <- FS.stat $ "." <> sep <> p
      if (Stats.isFile stat)
        then
          liftEffect $ log $ "File found: " <> p
        else
          liftEffect $ log $ "Directory found: " <> p

      {-
        or... one could also write the above as:

          ifM (Stats.isFile <$> FS.stat ("." <> sep <> p))
              (liftEffect $ log $ "File found: " <> p)
              (liftEffect $ log $ "Directory found: " <> p)
      -}

    {-
    We could also write content to a file here:

    writeStuff :: Aff Unit
    writeStuff = do
      FS.writeTextFile UTF8 path "some content"
    -}
