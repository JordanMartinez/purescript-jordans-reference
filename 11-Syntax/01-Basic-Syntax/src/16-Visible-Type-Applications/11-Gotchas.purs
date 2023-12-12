module Syntax.Basic.VisibleTypeApplications.Gotchas where

-- Gotcha #1: Different orders between definition and usage
-- One can define two VTA-supported type variables but use the second one in the
-- type signature before the first one.

possibleGotcha
  :: forall @definedFirstUsedSecond @definedSecondUsedFirst
   . definedSecondUsedFirst
  -> definedFirstUsedSecond
  -> Int
possibleGotcha _firstArg _secondArg = 2

-- Type-applying `String` here affects the type of the second argument to this function,
-- not the first, because that's where `definedFirstUsedSecond` is used.
unexpectedFunction :: forall firstArg. firstArg -> String -> Int
unexpectedFunction = possibleGotcha @String


-- Gotcha #2: forgetting to opt-in to VTA support when deriving a function

mainFunction :: forall @a @b. a -> b -> Int
mainFunction _a _b = 1

-- Unless we specify `forall @b` here, the type signature will be `forall b`
derivedFunction :: forall b. Int -> b -> Int
derivedFunction = mainFunction @Int
