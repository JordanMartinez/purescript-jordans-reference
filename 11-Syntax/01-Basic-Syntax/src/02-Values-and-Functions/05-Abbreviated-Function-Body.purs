module Syntax.Function.BodyAbbreviation where

import Prelude

-- if the body of a function is another function that expects an argument,
-- one can omit the argument entirely.
--    Note: 'show' converts any type into a String
abbreviatedFunction2 :: Int -> String
abbreviatedFunction2   = show   {- is the same as...
abbreviatedFunction2 x = show x -} --

-- example
exampleAbbreviation2 :: Boolean
exampleAbbreviation2 = (abbreviatedFunction2 4) == "4"
