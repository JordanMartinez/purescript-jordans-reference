module PartialFunctions.ViaEitherErrorType where

import Prelude

import Data.Either (Either(..))
{-
The previous file demonstrates how to use "Either String a" for error handling.
The problem with this approach is that the error type isn't type-safe.
In other words, why use Strings when we could define our own error types?

Creating our own error types has these benefits:
  - Less bugs / runtime errors: the program works or it fails to compile
  - Self-documenting errors: all possible errors (instances) are grouped
      under a human-readable type, not an error number that requires a lookup,
      or a String that is subject to modification

Thus, we'll define a type for our DivisionError:
-}

data DivisionError = DividedByZero

-- Then we'll make it printable to the screen
instance Show DivisionError where
  show DividedByZero = "Error: you attempted to divide by zero!"

-- We'll update `safeDivision` to return the error type rather than a String
safeDivision :: Int -> Int -> Either DivisionError Int
safeDivision _ 0 = Left DividedByZero
safeDivision x y = Right (x / y)
