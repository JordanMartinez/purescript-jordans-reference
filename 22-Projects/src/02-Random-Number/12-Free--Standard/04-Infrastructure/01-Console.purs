module Games.RandomNumber.Free.Standard.Infrastructure.Console (main) where

import Prelude
import Effect (Effect)
import Effect.Aff (runAff_)
import Node.ReadLine (close, createConsoleInterface, noCompletion)

import Games.RandomNumber.Free.Standard.Domain (game)
import Games.RandomNumber.Free.Standard.API (runDomain)
import Games.RandomNumber.Infrastructure.ReadLineAff (question)

-- Level 0 / Machine Code
main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion

  runAff_
    (\_ -> close interface)
    (runDomain (\prompt -> question interface prompt) game)
