module Syntax.Basic.PatternMatching where

import Prelude

-- Given a data type like this:
data Fruit
  = Apple
  | Orange
  | Banana
  | Cherry
  | Tomato -- because why not!?

-- Pattern Matching: Basic idea and order of matching
mkString :: Fruit -> String {-
         if the arg is _ = then return _ -}
mkString Apple           = "apple"

{-  else if the arg is _ = then return _ -}
mkString Orange          = "orange"

{-  else if the arg is _ = then return _ -}
mkString Banana          = "banana"

{-  else if the arg is _ = then return _ -}
mkString Cherry          = "cherry"

{-  else if the arg is _ = then return _ -}
mkString Tomato          = "tomato"

-- The above pattern match is "exhaustive" because there are no other
-- Fruit values against which one could match.

-- Pattern Matching: Literal values and catching all values

literalValue :: String -> String
literalValue "a" = "Return this string if arg is 'a'"
literalValue "b" = "Return this string if arg is 'b'"
literalValue "c" = "Return this string if arg is 'c'"
literalValue _   = "ignore input and return this default value"

-- syntax sugar for pattern-matching literal arrays
array :: Array Int -> String
array []           = "an empty array"
array [0]          = "an array with one value that is 0"
array [0, 1]       = "an array with two values, 0 and 1"
array [0, 1, a, b] = "an array with four values, starting with 0 and 1 \
                       \ and binding the third and fouth to names 'a' and 'b'"
array [-1, _ ]     = "an array of two values, '-1' and another value that \
                       \ will not be used in the body of this function."
array _            = "catchall for arrays. This is needed to make this \
                       \ example compile"


-- Pattern Matching: Unwrapping Data Constructors
data A_Type
  = AnInt Int
  | Outer A_Type -- recursive type!
  | Inner Int

f :: A_Type -> String {-
-- Syntax
f patternMatch = bodyToRunIfPatternWasMatched

  where 'patternMatch' is:
    - literal value
    - DataConstructorWithNoArgs
    - (DataConstructor withArgBoundToThisBinding)
    - (DataConstructor "with arg whose value is this literal value")
    - bindingForEntireValue@(literalValue)
    - bindingForEntireValue@(DataConstructorWithNoArgs)
    - bindingForEntireValue@(DataConstructor withArgBoundToThisBinding)
    - bindingForEntireValue@(DataConstructor "with arg whose value is this literal value")

-- Example

f the pattern match     = description of what was matched -}
f (Inner 0)             = "a value of type Inner whose value is 0"
f (Inner int)           = "a value of type Inner, binding its value to 'int' \
                          \name for usage in function body"
f (Outer (Inner int))   = "a value of type Outer, whose Inner value is bound \
                          \to `int` name for usage in function body"
f object@(AnInt 4)      = "a value of type AnInt whose value is '4', \
                          \binding the entire object to the `object` name for \
                          \usage in function body"
f _                     = "ignores input and matches everything; \
                          \acts as a default / catch all case"

-- Pattern Matching: Regular Guards
g :: Int -> Int -> String {-
g x y | condition1  = return this if condition1 is true
      | condition2  = return this if condition2 is true
      | ...         = ...
      | conditionN  = return this if conditionN is true
      | otherwise   = default case-}
g x y | x + y == 0 = "x == -y"
      | x - y == 0 = "x == y"
      | x * y == 0 = "x == 0 || y == 0"
      | otherwise = "some other value"

-- Pattern Matching: Single and Multiple Guards
h :: Int -> Int -> String
h x y | x == 4 && y == 5 = "body"

   -- | condition1, condition2 = body
      | x == 4, y == 6   = "body"

  {-  ... or when using syntax sugar...
      | condition1
      , condition2 = body -}
      | x == 3
      , y == 2           = "body"

-- It's wise to separate mulitple guards with a blank line for readability.
      | otherwise        = "default"

-- Pattern Matching: Single Pattern Guard
j :: Int -> String {-
j x | returnedValue <- function arg1 arg2 argN = body if match occurs -}
j x | (Box 2) <- toBox x = "Calling toBox x returned a Box with 2 inside of it"
    | (Box y) <- toBox x = concat "The 'y' value was: " (toString y)

-- Pattern Matching: Multiple Pattern Guards
p :: Int -> Int -> String {-
p x y | returnedValue1 <- functionCall1, returnedValue2 <- functionCall2 = body -}
p x y | (Box 2) <- toBox x, (Box 3) <- toBox (x - 1) = "without syntax sugar"

 {-   ... or for easier reading, there is sugar syntax:
p x y | returnedValue1 <- functionCall1
      , returnedValue2 <- functionCall2 = body -}
      | (Box a) <- toBox x
      , (Box b) <- toBox (x * 2) = "with syntax sugar"

      | otherwise = "some other value"

-- Different guards can be mixed:
q :: Int -> Int -> String
q x y | x == 3                   = "3"
      | x == 5, y == 5           = "5"
      | (Box 2) <- toBox x       = "2?"

      | (Box 2) <- toBox x
      , y == 4                   = "curious, no?"

      | (Box a) <- toBox x
      , (Box b) <- toBox (y * 2) = "something?"

      | otherwise                = "catch-all"

-- necessary for this to compile
data Box a = Box a

toBox :: Int -> Box Int
toBox 1 = Box 2
toBox _ = Box 0

concat :: String -> String -> String
concat left right = left <> right

toString :: forall a. Show a => a -> String
toString = show
