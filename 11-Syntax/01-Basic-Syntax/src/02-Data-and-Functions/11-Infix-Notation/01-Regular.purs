module Syntax.InfixNotation.Regular where

import Prelude

two_arg_function :: Int -> Int -> Int
two_arg_function x y | x < 0 = (x + 1) * (y + 14)
                     | otherwise = y + x

infix_notation :: Int
infix_notation =
  -- infix notation available via backticks
  (1 `two_arg_function` 2)
  -- becomes two_arg_function 1 2

data List a = Nil | Cons a (List a)
data Box a = Box a

-- Some types given here to make things easier...
type TypeAlias = forall a b. List a -> Box b
data DataType = Constructor Int Int

{-
Infix Syntax:
infix/infixl/infixr precedence function/constructor as symbolicAlias

... or for type aliases:
infix/infixl/infixr precedence type TypeName as symbolicAlias

... where 'precedence' is a number (0..9)
    and 'symbolicAlias' is a sequence of symbolic character(s)
      (i.e. cannot use alphanumeric characters, nor an underscore character)
-}

-- Example
infixl 4 two_arg_function as >>
infix  2 Constructor as ?->
infix  4 type TypeAlias as :$>

-- Infix is all about where to put the parenthesis as indicated by precedence:
-- precedence is 0 = group first
--               n = group after first but before last
--               9 = group last
--
-- Each type of infix will be shown by reducing it to its final call

-- make depth small (like a tree)
-- infix 0 concatString as $$$$$

{-  "a" $$$$$ "b"  $$$$$  "c" $$$$$ "d"
== ("a" $$$$$ "b") $$$$$ ("c" $$$$$ "d"))
== ($$$$$ "a" "b") $$$$$ ($$$$$ "c" "d"))
== concatString (concatString "a" "b") (concatString "c" "d")  -- desugared
-}

-- infixl 9 concatString as |>>|

{-    "a" |>>| "b"  |>>| "c"  |>>| "d"
==   ("a" |>>| "b") |>>| "c"  |>>| "d"
==  (("a" |>>| "b") |>>| "c") |>>| "d"
== |>>| (("a" |>>| "b") |>>| "c") "d"
== |>>| (|>>| ("a" |>>| "b") "c") "d"
== |>>| (|>>| (|>>| "a" "b") "c") "d"
== concatString (concatString (concatString "a" "b") "c") "d"
-}

-- infixr 7 concatString as |<<|

{- "a" |<<|  "b" |<<|  "c" |<<| "d"
== "a" |<<|  "b" |<<| ("c" |<<| "d")
== "a" |<<| ("b" |<<| ("c" |<<| "d"))
== |<<| "a" ("b" |<<| ("c" |<<| "d"))
== |<<| "a" (|<<| "b" ("c" |<<| "d"))
== |<<| "a" (|<<| "b" (|<<| "c" "d"))
== concatString "a" (concatString "b" (concatString "c" "d"))
-}
