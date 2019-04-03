module RandomNumber.ReaderT.Standard.Main.Console
  ( runAPI

  , main
  )
  where

import Prelude
import Effect.Random (randomInt)
import Effect (Effect)
import Effect.Console (log)
import Effect.Class (liftEffect)
import Effect.Aff (Aff, runAff_)
import Node.ReadLine (
  Interface
, createConsoleInterface, noCompletion
, close
)

import RandomNumber.ReaderT.Standard.Domain (game)
import RandomNumber.ReaderT.Standard.API (AppM, runAppM)
import RandomNumber.Infrastructure.ReadLineAff (question)

-- Code for Infrastructure

runAPI :: Interface -> AppM ~> Aff
runAPI iface =
  runAppM { notifyUser: liftEffect <<< log
          , getUserInput: question iface
          , createRandomInt: (\l u -> liftEffect $ randomInt l u) }

-- Level 0 / Machine Code
main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion

  runAff_
    (\_ -> close interface)
    (runAPI interface game)
