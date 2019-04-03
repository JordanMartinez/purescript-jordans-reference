module RandomNumber.Free.Layered.Main.Console (main) where

import Prelude
import Effect (Effect)
import Effect.Aff (runAff_)
import Node.ReadLine (close, createConsoleInterface, noCompletion)

import RandomNumber.Free.Layered.HighLevelDomain (game)
import RandomNumber.Free.Layered.LowLevelDomain (runHighLevelDomain)
import RandomNumber.Free.Layered.API (runLowLevelDomainInConsole)

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion

  runAff_
    (\_ -> close interface)
    (runLowLevelDomainInConsole interface (runHighLevelDomain game))
