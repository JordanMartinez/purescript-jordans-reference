module Games.RandomNumber.Core (module Exports) where

import Games.RandomNumber.Core.Bounded (
  Bounds, mkBounds, unBounds, totalPossibleGuesses
, BoundsCheckError(..), BoundsCreationError(..)
, Guess, mkGuess, guessEqualsRandomInt, (==#)
, RandomInt, mkRandomInt
) as Exports

import Games.RandomNumber.Core.RemainingGuesses (
  RemainingGuesses, mkRemainingGuesses, decrement, outOfGuesses
, RemainingGuessesCreationError(..)
) as Exports

import Games.RandomNumber.Core.GameTypes (
  GameInfo, mkGameInfo, GameResult(..)
) as Exports
