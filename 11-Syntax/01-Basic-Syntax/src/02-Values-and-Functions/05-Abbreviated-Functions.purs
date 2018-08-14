module Syntax.Function.BodyAbbreviation where

import Prelude

-- the underscore indicates the next argument that the function will receive
abbreviatedFunction :: Int -> Int
abbreviatedFunction   = (+) 3  {- is the same as...
abbreviatedFunction i = 3 + i  -}

-- if the body of a function is another function expected an argument,
-- one can omit the argument entirely.
--    Note: 'show' converts any type into a String
abbreviatedFunction2 :: Int -> String
abbreviatedFunction2   = show   {- is the same as...
abbreviatedFunction2 x = show x -} --

-- example
exampleAbbreviation1 :: Boolean
exampleAbbreviation1 = (abbreviatedFunction 4) == 7

exampleAbbreviation2 :: Boolean
exampleAbbreviation2 = (abbreviatedFunction2 4) == "4"
