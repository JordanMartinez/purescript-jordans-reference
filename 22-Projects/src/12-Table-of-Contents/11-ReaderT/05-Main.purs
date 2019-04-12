module ToC.ReaderT.Main where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import ToC.Infrastructure.Yargs (runProgramViaCLI)
import ToC.ReaderT.API (runAppM)
import ToC.ReaderT.Domain (program)

-- | Sets up the environment value via a CLI library
-- | and then runs the program using that value.
main :: Effect Unit
main = do
  runProgramViaCLI (\env -> launchAff_ $ runAppM env program)
