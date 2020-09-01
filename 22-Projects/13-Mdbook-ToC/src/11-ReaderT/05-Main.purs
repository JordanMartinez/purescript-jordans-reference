module ToC.ReaderT.Main where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import Options.Applicative (execParser)
import ToC.Infrastructure.OptParse (parseCLIArgs)
import ToC.ReaderT.API (runAppM)
import ToC.ReaderT.Domain (program)

-- | Sets up the environment value via a CLI library
-- | and then runs the program using that value.
main :: Effect Unit
main = do
  env <- execParser parseCLIArgs
  launchAff_ $ runAppM env program
