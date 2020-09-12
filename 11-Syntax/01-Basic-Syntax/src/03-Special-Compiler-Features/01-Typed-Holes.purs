module Syntax.Basic.SpecialCompilerFeatures.Holes where

{-

Original credit: @paf31 / @kritzcreek

Link: https://github.com/paf31/24-days-of-purescript-2016/blob/master/23.markdown

Changes made:
- use meta-language to explain syntax and give a few very simple examples

Licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
https://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

----------------------------------

Sometimes, when writing code, we're not always sure which function/value
we should use. In such cases, we can use a feature called
"Typed Holes" / "Type Directed Search" to ask the compiler to tell us
what it thinks should go there.

This feature can often be very helpful when debugging a compiler error
or when exploring a new library for the first time.

Syntax:
`?placeholderName`

Replace the function/value you want the compiler to suggest for you with
the above syntax.
-}

-- Note to self: don't delete this as functions from Prelude will be suggested below
import Prelude

warning :: String
warning =
  """
  When we compile our code and it includes a hole,
  the compiler will output a compiler error.

  The error message will include the compiler's guess as to what should
  be put there.

  Since this outputs a compiler error, we have to comment out the following code
  to make this project build on Travis CI and on local computers

  Uncomment the following examples, one at a time, and then build the folder to
  see how it works
  """

-- This example will show what the type signature for "?placeholder_name"
-- should be.

-- example1 :: Int -> String
-- example1 i = ?placeholder_name i

-- Caveats: While this file has 2 "holes," the second one will not be reported
-- by the compiler because it produces an error at the first hole. Thus,
-- this feature can only be used once in a project per compilation.

-- notice the infix notation used here via the backticks
-- example2 :: String
-- example2 = "hello" `?I_Don't_know` " world"

-- example3 :: Int
-- example3 = 1 + ?what_could_this_be
