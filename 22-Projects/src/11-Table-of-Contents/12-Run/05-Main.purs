module ToC.Run.Main where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import ToC.Run.Domain (program)
import ToC.Run.API (runDomain)
import ToC.Infrastructure.Yargs (runProgramViaCLI)

-- | Sets up the environment value via a CLI library
-- | and then runs the program using that value.
main :: Effect Unit
main = do
  runProgramViaCLI (\env -> launchAff_ $ runDomain env program)
