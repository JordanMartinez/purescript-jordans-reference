module Games.RandomNumber.Run.Standard.Infrastructure.Console
  ( main
  ) where

import Prelude
import Effect (Effect)
import Effect.Aff (runAff_)
import Node.ReadLine (close, createConsoleInterface, noCompletion)

import Games.RandomNumber.Run.Standard.Domain (game)
import Games.RandomNumber.Run.Standard.API (runDomain)
import Games.RandomNumber.Infrastructure.ReadLineAff (question)

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion

  runAff_
    (\_ -> close interface)
    (runDomain (\prompt -> question interface prompt) game)
