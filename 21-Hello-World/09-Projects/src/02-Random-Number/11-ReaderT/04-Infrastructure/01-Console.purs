module Games.RandomNumber.ReaderT.Infrastructure.Console
  ( question
  , runAPI

  , main
  )
  where

import Prelude
import Data.Either (Either(..))
import Effect.Random (randomInt)
import Control.Monad.Reader.Trans (ReaderT, runReaderT)
import Control.Monad.Reader.Class (class MonadAsk, ask, asks)
import Effect (Effect)
import Effect.Console (log)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Aff (Aff, runAff_, makeAff)
import Node.ReadLine (
  Interface
, createConsoleInterface, noCompletion
, close
)
import Node.ReadLine as NR

import Games.RandomNumber.Core (Bounds, unBounds, RandomInt, Guess, RemainingGuesses)
import Games.RandomNumber.ReaderT.Domain (game)
import Games.RandomNumber.ReaderT.API (AppM, runAppM)

-- Code for Infrastructure

question :: Interface -> String -> Aff String
question interface message = do
  makeAff go
  where
    go handler = NR.question message (handler <<< Right) interface $> mempty

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
