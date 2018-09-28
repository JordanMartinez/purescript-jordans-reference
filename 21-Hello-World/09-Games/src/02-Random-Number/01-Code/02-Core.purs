module Games.RandomNumber.Core
  ( GameInfo(..), mkGameInfo
  , GameResult(..)
  , GameF(..)
  , module Exports
  ) where

import Data.Tuple (Tuple(Tuple))

import Games.RandomNumber.Core.Bounded (Bounds, RandomInt)
import Games.RandomNumber.Core.Bounded (
  Bounds, mkBounds, unBounds, showTotalPossibleGuesses
, BoundsCheckError(..), BoundsCreationError(..)
, Guess, mkGuess, guessEqualsRandomInt, (==#)
, RandomInt, mkRandomInt
) as Exports

import Games.RandomNumber.Core.RemainingGuesses (RemainingGuesses)
import Games.RandomNumber.Core.RemainingGuesses (
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

-- | High-level overview of our game's control flow
data GameF a
  = ExplainRules a
  | SetupGame (GameInfo -> a)
  | PlayGame GameInfo (GameResult -> a)
  | EndGame GameResult a
