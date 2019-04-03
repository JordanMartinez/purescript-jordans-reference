module Games.RandomNumber.Free.Layered.Main.Console (main) where

import Prelude
import Effect (Effect)
import Effect.Aff (runAff_)
import Node.ReadLine (close, createConsoleInterface, noCompletion)

import Games.RandomNumber.Free.Layered.HighLevelDomain (game)
import Games.RandomNumber.Free.Layered.LowLevelDomain (runHighLevelDomain)
import Games.RandomNumber.Free.Layered.API (runLowLevelDomainInConsole)

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion

  runAff_
    (\_ -> close interface)
    (runLowLevelDomainInConsole interface (runHighLevelDomain game))
