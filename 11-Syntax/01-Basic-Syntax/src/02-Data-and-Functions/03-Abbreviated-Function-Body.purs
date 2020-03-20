module Syntax.Basic.Function.BodyAbbreviation where

import Prelude

-- if the body of a function is another function that expects an argument,
-- one can omit the argument entirely.
--    Note: 'show' converts any type into a String
abbreviatedFunction2 :: Int -> String
abbreviatedFunction2   = show   {- is the same as...
abbreviatedFunction2 x = show x -}

-- example
exampleAbbreviation2 :: Boolean
exampleAbbreviation2 = (abbreviatedFunction2 4) == "4"

warning :: String
warning = """

Sometimes, using an abbreviated function will cause problems.
See this issue for more details:
https://github.com/purescript/purescript/issues/950

To fix it, just use un-abbreviated functions by including the argument:
-- change this:
f :: Int -> String
f = show

-- to
f' :: Int -> String
f' x = show x

"""
