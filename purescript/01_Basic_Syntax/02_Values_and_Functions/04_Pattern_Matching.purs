data Inner = Inner Int
data Outer = Outer Inner

data SomeValue = SomeValue Int

patternMatch :: forall a. a -> String
patternMatch 0                   = "a literal value"
patternMatch (Inner 0)           = "return this tring if inner value is 0"
patternMatch (Inner int)         = "unconstruct `Inner` and get its inner value, binding to 'int'"
patternMatch (Outer (Inner int)) = "unconstruct nested types and get int value"
patternMatch name@(SomeValue 4)  = "refer to entire object using 'name@object' syntax"
patternMatch x | x == 3          = "if x is 3, return this string"
               | x == 5          = "else if x is 5, return this string"
               | otherwise       = "else, return this string"

otherwise2 :: String -> Int
otherwise2 _ = 0 -- igore the input


--
data Sum = Sum Int

arrayPatterns :: Array Int -> Sum
arrayPatterns [] = Sum 0
arrayPatterns [0] = Sum 0
arrayPatterns [0, 1] = Sum 1
arrayPatterns [0, 1, a, b] = Sum (1 + a + b)
arrayPatterns array@[1, 2] = Sum (length array)
arrayPatterns [-1, {- the rest of the array -} _ ] = Sum -1
