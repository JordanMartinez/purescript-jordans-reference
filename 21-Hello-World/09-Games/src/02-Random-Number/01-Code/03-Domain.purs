module Games.RandomNumber.Domain (RandomNumberOperationF(..)) where

import Games.RandomNumber.Core (Bounds, RandomInt, Guess, RemainingGuesses)

-- | Defines the operations we'll need to run
-- | a Random Number Guessing game
data RandomNumberOperationF a
  = NotifyUser String a
  | DefineBounds (Bounds -> a)
  | DefineTotalGuesses (RemainingGuesses -> a)
  | GenerateRandomInt Bounds (RandomInt -> a)
  | MakeGuess Bounds (Guess -> a)
