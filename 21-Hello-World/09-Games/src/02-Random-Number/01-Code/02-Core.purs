module Games.RandomNumber.Core
  ( GameInfo(..), mkGameInfo, getRandomInt
  , GameResult(..)
  , GameF(..)
  , module Exports
  ) where

import Data.Tuple (Tuple(..))

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

newtype GameInfo
  = GameInfo { bound :: Bounds
             , number :: RandomInt
             }

-- | Convenience function for easily creating a GameInfo object
mkGameInfo :: Bounds -> RandomInt -> GameInfo
mkGameInfo b r =
  GameInfo { bound: b, number: r }

getRandomInt :: GameInfo -> RandomInt
getRandomInt (GameInfo { bound: _, number: n }) = n

-- | Sum type that defines the number of remaining guesses
-- | the player had before they won, or the random integer
-- | if they lost.
data GameResult
  = PlayerWins RemainingGuesses
  | PlayerLoses RandomInt

-- | High-level overview of our game's control flow
data GameF a
  = ExplainRules a
  | SetupGame (Tuple GameInfo RemainingGuesses -> a)
  | PlayGame GameInfo RemainingGuesses (GameResult -> a)
  | EndGame GameResult a
