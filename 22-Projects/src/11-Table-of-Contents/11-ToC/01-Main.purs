module Projects.ToC.Main where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import Projects.ToC.API.AppM (runAppM)
import Projects.ToC.Domain.BusinessLogic (program)
import Projects.ToC.Infrastructure.CLI.Yargs (runProgramViaCLI)

main :: Effect Unit
main = do
  runProgramViaCLI (\env -> launchAff_ $ runAppM env program)
