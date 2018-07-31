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

data Inner = Inner Int
data Outer = Outer Inner

data AnInt = AnInt Int

-- Syntax
f :: forall a. a -> String {-
f literalValue / type = code to run -}

f :: forall a. a -> String {-
f the pattern match     = description of what was matched -}
f 0                     = "a literal value"
f (Inner 0)             = "an instance of type Inner whose value is 0"
f (Inner int)           = "an instance of type Inner, binding its value to 'int' \
                          \name for usage in function body"
f (Outer (Inner int))   = "an instance of type Outer, whose Inner value is bound\
                          \to `int` name for usage in function body"
f object@(AnInt 4)      = "an instance of type AnInt whose value is '4', \
                          \binding the entire object to the `object` name for \
                          \usage in function body"
-- This example makes use of "guards" via "|"
f (AnInt x) | x == 3    = "bind value to name 'x'. \
                          \Then: if x is 3, do..."
            | x == 5    =       "else if x is 5, do..."
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
arrayPatterns [-1, _ ]     = "an array whose first value is '-1' and \
                             \which has 0 or more additional elements"
