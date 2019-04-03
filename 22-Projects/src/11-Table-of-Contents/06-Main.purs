module ToC.Main where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import ToC.API.AppM (runAppM)
import ToC.Domain.BusinessLogic (program)
import ToC.Infrastructure.CLI.Yargs (runProgramViaCLI)

-- | Sets up the environment value via a CLI library
-- | and then runs the program using that value.
main :: Effect Unit
main = do
  runProgramViaCLI (\env -> launchAff_ $ runAppM env program)
