module PartialFunctions.ViaRefinedTypes where

import Prelude

import Data.Either (Either(..))
{-
Rather than making our function take any `Int` as its second argument,
why not guarantee that the second argument is not a zero?

Thus, we can 'refine' our `Int` type using a newtype to insure
that it is non-zero:
-}

newtype NonZeroInt = NonZero Int

safeDivision :: Int -> NonZeroInt -> Int
safeDivision x (NonZero y) = x / y

{-
To create an instance of `NonZeroInt`, we still need to use
a function that verifies that our `Int` is really non-zero.
-}

mkNonZeroInt :: Int -> Either NonZeroIntError NonZeroInt
mkNonZeroInt 0 = Left IntWasZero
mkNonZeroInt x = Right x

data NonZeroIntError = IntWasZero

-- Then we'll make it printable to the screen
instance divisionErrorShow :: Show NonZeroIntError where
  show IntWasZero = "Error: the integer was 0."
