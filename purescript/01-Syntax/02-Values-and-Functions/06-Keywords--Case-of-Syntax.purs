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
function :: forall a b. a -> b
function a =
  -- syntax
  case expression of
    -- see Pattern Matching in Functions file for a full review of
    -- what a pattern match looks like
    patternMatch1 -> bodyOfFunctionIfMatched
    patternMatch2 -> bodyOfFunctionIfMatched
    patternMatch3 -> bodyOfFunctionIfMatched

    -- These show a few examples from pattern matching
    "literal string value" -> bodyOfFunction
    (Box 4) -> bodyOfFunction
    Constructor3 -> bodyOfFunction
    ConstructorWithTypes typeArg1 typeArg2 -> bodyOfFunction
    object@(SomeValue 4) -> bodyOfFunction
    (AnIntValue x) | x == 4 -> bodyOfFunction    -- guards are also allowed here
                   | x == 5 -> bodyOfFunction
                   | otherwise -> bodyOfFunction
    _ -> catchAllAndBodyOfFunction

-- If 'expression' is 'a', we could also emit the 'a'
--  and use function abbreviation:
function :: forall a b. a -> b
function = case _ of
  Constructor1 -> bodyOfFunction
  Constructor2 -> bodyOfFunction
  Constructor3 -> bodyOfFunction
  _ -> catchAllAndBodyOfFunction


-- Returning to our example
mkString :: Fruit -> String
mkString = case _ of
  Apple -> "apple"
  Orange -> "orange"
  Banana -> "banana"
  Cherry -> "cherry"
  Tomato -> "tomato"

-- We can also match multiple expressions by adding commas between them:
-- Syntax:
function = case firstExpression, secondExpression {-, nExpression -} of
  firstResultPatternMatch, secondResultPM {-, nResult -} -> bodyOfFunction
  firstResultPatternMatch, secondResultPM {-, nResult -} -> bodyOfFunction

-- example
mkString2 :: Fruit -> Fruit -> String
mkString2 a b = case a, b of
  Apple, Apple -> "Two apples"
  Apple, Cherry -> "An apple and a cherry"
  _, _ -> "You didn't really think I would type out all of them, did you?!?"
