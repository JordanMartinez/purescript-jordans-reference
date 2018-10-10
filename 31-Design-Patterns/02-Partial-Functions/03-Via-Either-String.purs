module PartialFunctions.ViaEitherString where

import Prelude

-- new imports
import Data.Either (Either(..))

-- `Maybe` is useful when we don't care about the error.
-- However, what if we do? In such cases, we use `Either:`

data Either_ a b  -- a type that is either 'a' or 'b'
  = Left_ a         -- the 'a' / failure type
  | Right_ b        -- the 'b' / success type

{-
In this next example, we'll use a different way to notify the user
that the user attempted to divide by zero. Rather than returning `Nothing`
for the "divide by zero" error, we'll return a String with the error message.
-}

safeDivision :: Int -> Int -> Either String Int
safeDivision _ 0 = Left "Error: Attempted to divide by zero!"
safeDivision x y = Right (x / y)
