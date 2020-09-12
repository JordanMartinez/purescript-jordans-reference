module ToC.Run.Main where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import ToC.Run.Domain (program)
import ToC.Run.API (runDomain)
import Options.Applicative (execParser)
import ToC.Infrastructure.OptParse (parseCLIArgs)

-- | Sets up the environment value via a CLI library
-- | and then runs the program using that value.
main :: Effect Unit
main = do
  env <- execParser parseCLIArgs
  launchAff_ $ runDomain env program
