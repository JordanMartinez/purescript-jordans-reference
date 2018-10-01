module Games.RandomNumber.Free.Core
  ( GameF(..)
  , Game, game
  , module Exports
  ) where

import Prelude

import Control.Monad.Free (Free, liftF)
import Games.RandomNumber.Free.Core.Bounded (Bounds, RandomInt)
import Games.RandomNumber.Free.Core.Bounded (
  Bounds, mkBounds, unBounds, showTotalPossibleGuesses
, BoundsCheckError(..), BoundsCreationError(..)
, Guess, mkGuess, guessEqualsRandomInt, (==#)
, RandomInt, mkRandomInt
) as Exports

import Games.RandomNumber.Free.Core.RemainingGuesses (RemainingGuesses)
import Games.RandomNumber.Free.Core.RemainingGuesses (
  RemainingGuesses, mkRemainingGuesses, decrement, outOfGuesses
, RemainingGuessesCreationError(..)
) as Exports

import Games.RandomNumber.Free.Core.GameTypes (GameInfo, GameResult)
import Games.RandomNumber.Free.Core.GameTypes (
  GameInfo, mkGameInfo, GameResult(..)
) as Exports


-- | High-level overview of our game's control flow
data GameF a
  = ExplainRules a
  | SetupGame (GameInfo -> a)
  | PlayGame GameInfo (GameResult -> a)

derive instance functor :: Functor GameF

-- `Free` stuff

type Game = Free GameF

explainRules :: Game Unit
explainRules = liftF $ (ExplainRules unit)

setupGame :: Game GameInfo
setupGame = liftF $ (SetupGame identity)

playGame :: GameInfo -> Game GameResult
playGame info = liftF $ (PlayGame info identity)

-- endGame :: GameResult -> Game Unit
-- endGame result = liftF $ (EndGame result unit)

game :: Game GameResult
game = do
  explainRules
  info <- setupGame
  playGame info
  -- result <- playGame info
  -- endGame result
