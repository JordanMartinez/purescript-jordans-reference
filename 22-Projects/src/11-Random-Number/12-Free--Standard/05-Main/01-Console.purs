module RandomNumber.Free.Standard.Infrastructure.Console (main) where

import Prelude
import Effect (Effect)
import Effect.Aff (runAff_)
import Node.ReadLine (close, createConsoleInterface, noCompletion)

import RandomNumber.Free.Standard.Domain (game)
import RandomNumber.Free.Standard.API (runDomainInConsole)

-- Level 0 / Machine Code
main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion

  runAff_
    (\_ -> close interface)
    (runDomainInConsole interface game)
