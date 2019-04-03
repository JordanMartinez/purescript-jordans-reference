-- | This modules simply re-exports all the underlying 'Core' submodules
module RandomNumber.Core (module Exports) where

import RandomNumber.Core.Bounded (
  Bounds, mkBounds, unBounds, totalPossibleGuesses
, BoundsCheckError(..), BoundsCreationError(..)
, Guess, mkGuess, guessEqualsRandomInt, (==#)
, RandomInt, mkRandomInt
) as Exports

import RandomNumber.Core.RemainingGuesses (
  RemainingGuesses, mkRemainingGuesses, unRemainingGuesses
, decrement, outOfGuesses
, RemainingGuessesCreationError(..)
) as Exports

import RandomNumber.Core.GameTypes (
  GameInfo, mkGameInfo, GameResult(..)
) as Exports
