module Projects.ToC.Main2 where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import Projects.ToC.API.AppM2 (runAppM2)
import Projects.ToC.Domain.FixedLogic (program)
import Projects.ToC.Infrastructure.CLI.Yargs (runProgramViaCLI)

main :: Effect Unit
main = do
  runProgramViaCLI (\env -> launchAff_ $ runAppM2 env program)
