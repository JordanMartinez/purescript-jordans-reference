module Games.RandomNumber.Run.Layered.Main.Console where

import Prelude

import Effect (Effect)
import Effect.Aff (runAff_)
import Games.RandomNumber.Run.Layered.HighLevelDomain (game)
import Games.RandomNumber.Run.Layered.LowLevelDomain (runHighLevelDomain)
import Games.RandomNumber.Run.Layered.API (runLowLevelDomainInConsole)
import Node.ReadLine (createConsoleInterface, noCompletion, close)

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion

  runAff_
    (\_ -> close interface)
    (runLowLevelDomainInConsole interface (runHighLevelDomain game))
