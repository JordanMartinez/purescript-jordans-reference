module Keyword.WhereAndLetIn where

import Prelude

data Box a = Box a
{-
The 'where' keyword enables us to break large functions
  down into smaller functions (or values) that compose.
Differences from the `let-in` syntax:
- functions/values are defined after the main function -}
whereFunction1 :: String -> String -> Int
whereFunction1 arg1 arg2 =
  returnFour (madeUpFunction arg1 arg2) 9

  where
  -- functions defined below the 'where' keyword can be used in the main
  -- function and any other made-up functions defined in this block
  madeUpFunction :: String -> String -> Int
  madeUpFunction s1 s2 =
    returnFour (createComplexDataTypeUsing s1)
      (mutuallyRecursiveFunction1 s2)

  createComplexDataTypeUsing :: String -> Box String
  createComplexDataTypeUsing s = Box s

  -- Note: If 'whereFunction1' had used 'forall' syntax above to specify
  -- generic types, we would not need to respecify them in any made-up functions
  -- that appear in this where block. However, since we want `returnFour` to work
  -- for multiple types, we'll need to specify that here.
  returnFour :: forall a b. a -> b -> Int
  returnFour _ _ = 4

  -- Mutually recursive functions are allowed
  mutuallyRecursiveFunction1 :: String -> String
  mutuallyRecursiveFunction1 "a" = "a"
  mutuallyRecursiveFunction1 x = mutuallyRecursiveFunction2 (x <> "b") -- "<>" means concat

  mutuallyRecursiveFunction2 :: String -> String
  mutuallyRecursiveFunction2 "b" = mutuallyRecursiveFunction1 "b"
  mutuallyRecursiveFunction2 x = mutuallyRecursiveFunction1 "a"


{-
The 'let...in' syntax does the same thing as 'where' but it defines things
  before they get used in an expression: -}
letInFunction1 :: String -> String
letInFunction1 expression =
  let
    binding = expression
  in
    somethingThatUses binding -- wherever `binding` is used, we mean `expression`

letInFunction2 :: String -> String -> String
letInFunction2 expression1 expression2 =
  let
    binding1 = expression1
    binding2 = expression2
  in
    somethingThatUses (binding1 <> binding2)

-- One can also define functions
letInFunction3 :: String -> String
letInFunction3 value =
  let
    function "firstMatch"  = bodyOfPatternMatch
    function "secondMatch" = bodyOfPatternMatch
    function catchAll      = bodyOfPatternMatch
  in
    function value

{-
See the indentation rules to correctly indent your where clause
   in the context of the containing function and how far to indent your
   madeUpFunctions.
-}

{-
WARNING!

The 'where' clause cannot be used with pattern matching due to a bug
in the Purescript langauge
GitHub Issue: https://github.com/purescript/purescript/issues/888

This will not compile:
-------------------------------------------------------------
patternMatchGuardWithWhere :: Int ->
patternMatchGuardWithWhere x | x == 0 = stringValue
                             | otherwise = "other value"
  where
  stringValue :: String
  stringValue = "string value"
-------------------------------------------------------------
-}

-- necessary to make this file compile:
somethingThatUses :: String -> String
somethingThatUses x = x

bodyOfPatternMatch :: String
bodyOfPatternMatch = "body of pattern match"
