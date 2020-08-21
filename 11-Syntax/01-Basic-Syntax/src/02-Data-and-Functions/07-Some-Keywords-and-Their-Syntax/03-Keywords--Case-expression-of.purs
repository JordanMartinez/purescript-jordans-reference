module Syntax.Basic.Keyword.CaseOf where

import Prelude

-- Returning to our previous basic pattern match example:
data Fruit
  = Apple
  | Orange
  | Banana
  | Cherry
  | Tomato

-- The following is tedious to write due to rewriting 'mkString' on every line:
mkString :: Fruit -> String
mkString Apple = "apple"
mkString Orange = "orange"
mkString Banana = "banana"
mkString Cherry = "cherry"
mkString Tomato = "tomato"

-- Fortunately, there is an easier way using 'case _ of' syntax:
function1 :: String -> String
function1 expression =
  -- syntax
  case expression of
    -- pattern match -> bodyOfFunctionIfMatched

    -- These show a few examples from pattern matching
    "patternMatch1" -> bodyOfFunction
    "patternMatch2" -> bodyOfFunction
    x | length x == 4 -> bodyOfFunction    -- guards are also allowed here
      | length x == 5 -> bodyOfFunction
    _ -> bodyOfFunction -- catch all

-- If 'expression' is the next argument in a function, we could decide
-- to not bind to name (e.g. 'a') and instead use function abbreviation
-- using the underscore syntax:

data Data = Constructor1 | Constructor2 | Constructor3 | ConstructorN

function2 :: Data -> String
function2 = case _ of
  Constructor1 -> bodyOfFunction
  Constructor2 -> bodyOfFunction
  Constructor3 -> bodyOfFunction
  _ -> bodyOfFunction -- catch all


-- Returning to our example
mkString2 :: Fruit -> String
mkString2 = case _ of
  Apple -> "apple"
  Orange -> "orange"
  Banana -> "banana"
  Cherry -> "cherry"
  Tomato -> "tomato"

-- We can also match multiple expressions by adding commas between them:
-- Syntax:
function3 :: String -> String -> String
function3 firstExpression secondExpression =
  case firstExpression, secondExpression {-, nExpression -} of
    "firstResultPatternMatch", "secondResultPM" {-, nResult -} -> bodyOfFunction
    "firstResultPatternMatch", "secondResultPM" {-, nResult -} -> bodyOfFunction
    _, _ -> bodyOfFunction -- catchall

-- example
mkString3 :: Fruit -> Fruit -> String
mkString3 a b = case a, b of
  Apple, Apple -> "Two apples"
  Apple, Cherry -> "An apple and a cherry"
  _, _ -> "You didn't really think I would type out all of them, did you?!?"

-- This compiles: Pattern Matching -> Case -> Pattern guard
test :: Int -> Boolean
test a
  | false =
      case false of
        true | a > 12 -> true
        _ -> false
  | otherwise = true

-- Necessary to get this file to compile
length :: String -> Int
length _ = 4

bodyOfFunction :: String
bodyOfFunction = "body of function"
