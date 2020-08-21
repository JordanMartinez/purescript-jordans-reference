module Syntax.Basic.Keyword.WhereAndLetIn where

import Prelude

data Box a = Box a
{-
The 'let..in' keywords and the `where` keyword enables us to break large
  functions down into smaller functions (or values) that compose.             -}

{-
The 'let...in' syntax lets us define "bindings" before we use them
in the block that follows the `in` keyword: -}
letInFunction1 :: String -> String
letInFunction1 expression =
  let
    -- Start of the "let" block
    binding = expression
    -- End of the "let" block
  in
    -- Start of the "in" block
    somethingThatUses binding -- wherever `binding` is used, we mean `expression`
    -- End of the "in" block

{-
We can define multiple bindings. Earlier bindings cannot refer to later
bindings, but later ones can refer to earlier ones. -}
letInFunction2 :: String -> String -> String
letInFunction2 expression1 expression2 =
  let
    -- Start of the "let" block
    binding1 = expression1
    binding2 = expression2
    binding3 = binding1
    -- End of the "let" block
  in
    -- Start of the "in" block
    somethingThatUses (binding1 <> binding2 <> binding3)
    -- End of the "in" block

letInFunction2_WithTypeSignatures :: String -> String -> String
letInFunction2_WithTypeSignatures expression1 expression2 =
  let
    -- we can also add type signatures above the bindings to help with
    -- readability or type inference.
    binding1 :: String
    binding1 = expression1

    binding2 :: String
    binding2 = expression2
  in
    somethingThatUses (binding1 <> binding2)

-- One can also define functions as a let binding
letInFunction3 :: String -> String
letInFunction3 value =
  let
    function "firstMatch"  = bodyOfPatternMatch
    function "secondMatch" = bodyOfPatternMatch
    function catchAll      = bodyOfPatternMatch
  in
    function value

letInFunction3_WithTypeSignatures :: String -> String
letInFunction3_WithTypeSignatures value =
  let
    function :: String -> String
    function "firstMatch"  = bodyOfPatternMatch
    function "secondMatch" = bodyOfPatternMatch
    function catchAll      = bodyOfPatternMatch
  in
    function value

-- One can also use guards with let
letWithGuards :: Int -> String
letWithGuards x =
  let result
        | x == 0 = "zero"
        | x == 1 = "one"
        | otherwise = "something else"
  in computeSomethingWithString result

-- Let bindings can also have type signatures. We'll see in the next file
-- why this can be very important.
letWithGuards_WithTypeSignatures :: Int -> String
letWithGuards_WithTypeSignatures x =
  let
    result :: String
    result
          | x == 0 = "zero"
          | x == 1 = "one"
          | otherwise = "something else"
  in computeSomethingWithString result

{-
The `where` clause is "syntax sugar" for let bindings.
Using the `where` clause, we could rewrite the below function using the
`where` clause
    whereFunction0 = let x = 4 in x        -}
whereFunction0 :: Int
whereFunction0 = x
  where
  x = 4

-- Here is a more typical example where multiple bindings are defined
-- in a single "where block"
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
See the indentation rules to correctly indent your `where` clause
  and the expressions that define a given binding.
-}

-- necessary to make this file compile:

somethingThatUses :: String -> String
somethingThatUses x = x

bodyOfPatternMatch :: String
bodyOfPatternMatch = "body of pattern match"

computeSomethingWithString :: String -> String
computeSomethingWithString _ = "string value"
