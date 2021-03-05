module Syntax.Basic.Function.BodyAbbreviation where

import Prelude

-- if the body of a function is another function that expects an argument,
-- one can omit the argument entirely.
--    Note: 'show' converts a value of most types into a `String` value.

function_normal      :: Int -> String
function_normal         x    = show    x
--    is the same as ...
function_abbreviated :: Int -> String
function_abbreviated {- x -} = show {- x -}
--    which is better written as ...
function_abbreviated2 :: Int -> String
function_abbreviated2 = show

-- example
exampleAbbreviation2 :: Boolean
exampleAbbreviation2 = (function_abbreviated2 4) == "4"

-- Going from "function_normal" to "function_abbreviated2" is called
-- "eta-reduction".
-- Goind from "function_abbreviated2" to "function_normal" is called
-- "eta-expansion" or "eta-abstraction"

warning :: String
warning = """

Sometimes, using an abbreviated function / eta-reduction will cause problems.
See this issue for more details:
https://github.com/purescript/purescript/issues/950

To fix it, just un-abbreviate the function body by eta-expanding it
(i.e. include the argument):
-- change this:
f :: Int -> String
f = show

-- to
f' :: Int -> String
f' x = show x
"""
