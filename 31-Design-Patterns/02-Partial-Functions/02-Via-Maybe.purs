module PartialFunctions.ViaMaybe where

import Prelude

{-
We can often turn our partial functions into total functions
by changing the output type from `OuputType` to `Maybe OutputType`:
-}

-- new imports
import Data.Maybe (Maybe(..))

data Maybe_ a   -- a type that indicates an instance of 'a' might exist
  = Nothing_      -- a box with nothing in it (empty box)
  | Just_ a       -- a box with 'just' an instance of "a" in it

{-
`Maybe` is often used in situations where
  - a function might return `null`.
  - we don't need to do anything with the error itself.

Using our example of division:

  | Expression | Explanation   | OO returns | FP returns |
  --------------------------------------------------------
  | 5 / 1      | Valid value   | 5          | Just 5
  | x / 0      | Invalid value | null       | Nothing

The following function, safeDivision, demonstrates this:
-}

-- No matter what arguments you pass into this,
-- you will always get a value out
safeDivision :: Int -> Int -> Maybe Int
safeDivision _ 0 = Nothing -- x / 0
safeDivision x y = Just (x / y)
