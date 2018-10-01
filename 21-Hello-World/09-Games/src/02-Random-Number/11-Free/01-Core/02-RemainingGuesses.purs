module Games.RandomNumber.Free.Core.RemainingGuesses
  ( RemainingGuesses, mkRemainingGuesses, decrement, outOfGuesses
  , RemainingGuessesCreationError(..)
  )
  where

import Prelude (class Show, otherwise, show, ($), (-), (<=), (==), class Eq)
import Data.Either(Either(..))

------ RemainingGuesses ------

newtype RemainingGuesses = RemainingGuesses Int

derive newtype instance rgE :: Eq RemainingGuesses
instance cs :: Show RemainingGuesses where
  show (RemainingGuesses i) = show i

data RemainingGuessesCreationError = NotPositiveInteger
instance cces :: Show RemainingGuessesCreationError where
  show _ = "User did not input a positive integer."

mkRemainingGuesses :: Int -> Either RemainingGuessesCreationError RemainingGuesses
mkRemainingGuesses i | i <= 0    = Left NotPositiveInteger
                     | otherwise = Right $ RemainingGuesses i

decrement :: RemainingGuesses -> RemainingGuesses
decrement (RemainingGuesses n) = RemainingGuesses (n - 1)

outOfGuesses :: RemainingGuesses -> Boolean
outOfGuesses (RemainingGuesses i) = i == 0
