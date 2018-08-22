module Syntax.PatternMatching where

import Prelude

-- Given a data type like this:
data Fruit
  = Apple
  | Orange
  | Banana
  | Cherry
  | Tomato -- because why not!?

-- Basic pattern matching: If the argument is _ then return _
mkString :: Fruit -> String
mkString Apple = "apple"
mkString Orange = "orange"
mkString Banana = "banana"
mkString Cherry = "cherry"
mkString Tomato = "tomato"

-- Now for a more complex example that shows the real power of pattern matching:

data A_Type
  = AnInt Int
  | Outer A_Type
  | Inner Int

-- Syntax
-- Note: "forall" will be explained in Keyword--Forall.purs
f :: A_Type -> String {-
-- Syntax
f patternMatch = bodyToRunIfPatternWasMatched

  where 'patternMatch' is:
    - ValueOrType
    - bindingForEntireObject@ValueOrType

    where 'ValueOrType' is
      - a literal value
      - a data constructor whose arguments
          are bound to bindings or
          are literal values

-- Example

f the pattern match     = description of what was matched -}
f (Inner 0)             = "an instance of type Inner whose value is 0"
f (Inner int)           = "an instance of type Inner, binding its value to 'int' \
                          \name for usage in function body"
f (Outer (Inner int))   = "an instance of type Outer, whose Inner value is bound\
                          \to `int` name for usage in function body"
f object@(AnInt 4)      = "an instance of type AnInt whose value is '4', \
                          \binding the entire object to the `object` name for \
                          \usage in function body"
-- This example makes use of regular "guards" via "|"
f (AnInt x) | x == 3         = "bind value to name 'x'. \
                               \Then: if x is 3, do..."
            | x == 5         =  "else if x is 5, do..."
            -- "pattern guards"
            | (Box 2) <- g x =  "else call g(x) and if it returns Box 2, do..."
        --  | (Box y) <- g x =  "else call g(x) and bind Box's value to 'y', then do..."
            | otherwise =       "else, do..."
f _                     = "ignores input and matches everything; \
                          \acts as a default / catch all case"

orderOfMatching :: String -> Int
orderOfMatching "hello"     = 0 -- if string was 'hello'
orderOfMatching "something" = 4 -- if previous case did not match and string was 'something'
orderOfMatching _           = 9 -- if all prior cases did not match and we don't care about the argument

arrayPatterns :: Array Int -> String
arrayPatterns []           = "an empty array"
arrayPatterns [0]          = "an array with one value that is 0"
arrayPatterns [0, 1]       = "an array with two values, 0 and 1"
arrayPatterns [0, 1, a, b] = "an array with four values, starting with 0 and 1 \
                             \and binding the third and fouth to names 'a' and 'b'"
arrayPatterns array@[1, 2] = "an array of two values, 1 and 2, that is bound to the 'array' name"
arrayPatterns [-1, _ ]     = "an array of two values, '-1' and another value that \
                             \will not be used in the body of this function."
arrayPatterns _            = "catchall for arrays. This is needed to make this file compile"


-- necesasry for this to compile
data Box a = Box a

g :: Int -> Box Int
g 1 = Box 2
g _ = Box 0
