module Games.RandomNumber.Free.Core
  ( GameF(..)
  , Game, game
  , module ExportCore
  ) where

import Games.RandomNumber.Core (
  Bounds, mkBounds, unBounds, totalPossibleGuesses
, BoundsCheckError(..), BoundsCreationError(..)
, Guess, mkGuess, guessEqualsRandomInt, (==#)
, RandomInt, mkRandomInt

, RemainingGuesses, mkRemainingGuesses, decrement, outOfGuesses
, RemainingGuessesCreationError(..)

, GameInfo, mkGameInfo, GameResult(..)
) as ExportCore

import Prelude
import Control.Monad.Free (Free, liftF)
import Games.RandomNumber.Core ( Bounds, RandomInt, RemainingGuesses
                               , GameInfo, GameResult
                               )


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
