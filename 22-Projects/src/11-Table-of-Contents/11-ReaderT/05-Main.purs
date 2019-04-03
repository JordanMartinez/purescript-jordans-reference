module ToC.ReaderT.Main where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import ToC.ReaderT.Domain (program)
import ToC.ReaderT.API (runAppM)
import ToC.ReaderT.Infrastructure.Yargs (runProgramViaCLI)

-- | Sets up the environment value via a CLI library
-- | and then runs the program using that value.
main :: Effect Unit
main = do
  runProgramViaCLI (\env -> launchAff_ $ runAppM env program)
