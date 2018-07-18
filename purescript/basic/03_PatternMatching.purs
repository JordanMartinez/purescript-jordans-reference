basicPatternMatch :: Boolean -> String
basicPatternMatch true = "true"
basicPatternMatch false = "false"

basicPatternMatch2 :: Int -> Int
basicPatternMatch2 0 = 0
basicPatternMatch2 n = n + 1

patternMatchWithGuards :: Int -> Int -> Int {-
patternMatchWithGuards n m | condition = body if condition is true -}
patternMatchWithGuards n m | m == 0 = 0
                           | n == 0 = 0
                           | otherweise = n * m

matchesAll :: Int -> Int
matchesAll x | x < 0 = x * 5
matchesAll _ = 0 -- ignore input if not less than 5 and just return 0
--
newtype Sum = Sum Int

arrayPatterns :: Array Int -> Sum
arrayPatterns [] = Sum 0
arrayPatterns [0] = Sum 0
arrayPatterns [0, 1] = Sum 1
arrayPatterns [0, 1, a, b] = Sum (1 + a + b)
arrayPatterns [-1, {- the rest of the array -} _ ] = Sum -1

--
data Value
  = IValue Int
  = SValue String

unconstructPatternMatch :: Value -> String
unconstructPatternMatch IValue (i) = show i
unconstructPatternMatch SValue (s) = s

namedPatternMatch :: Value -> Value
namedPatternMatch sval@SValue (_) = sval {- why create a new one? -}
namedPatternMatch ival@IValue (i) | i == 0    = ival
                                  | otherwise = IValue (i + 1)
