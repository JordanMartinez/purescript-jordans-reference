module Games.RandomNumber.Free.Core
  ( GameInfo(..), mkGameInfo
  , GameResult(..)
  , GameF(..)
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

type GameInfo = { bound :: Bounds
                , number :: RandomInt
                , remaining :: RemainingGuesses
                }

-- | Convenience function for easily creating a GameInfo object
mkGameInfo :: Bounds -> RandomInt -> RemainingGuesses -> GameInfo
mkGameInfo bounds number remaining =
  { bound: bounds, number: number, remaining: remaining }

-- | Sum type that defines the number of remaining guesses
-- | the player had before they won, or the random integer
-- | if they lost.
data GameResult
  = PlayerWins RemainingGuesses
  | PlayerLoses RandomInt

derive instance grE :: Eq GameResult

instance grs :: Show GameResult where
  show (PlayerWins rg) = "PlayerWins(" <> show rg <> ")"
  show (PlayerLoses ri) = "PlayerLoses(" <> show ri <> ")"

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
