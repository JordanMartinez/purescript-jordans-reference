module Test.QuickCheckSyntax where

import Prelude

import Effect (Effect)
import Effect.Console (log)

-- needed to run tests
import Effect.Exception (catchException, message)

-- new imports
-- these will be explained below
import Test.QuickCheck (
      quickCheck, quickCheck'
    , (<?>)
    , (==?), (===), (/=?), (/==)
    , (<?), (<=?), (>?), (>=?)

    -- needed to reduce noise in syntax
    , class Testable
    )

-- wraps the test output with the name of the test
runTest :: String -> Effect Unit -> Effect Unit
runTest testName test = do
  log $ "=== Running test:  " <> testName
  test
  log $ "=== Test finished: " <> testName <> "\n\n"

-- runs our tests
main :: Effect Unit
main = do
  runTest "Pass - exhaustive"       passingTest_exhaustive
  runTest "Pass - normal threshold" passingTest_normal_threshold
  runTest "Pass - custom threshold" passingTest_custom_threshold

  runTest "Fail - no error message"       error_message_None
  runTest "Fail - standard error message" error_message_Standard
  runTest "Fail - custom error message"   error_message_Custom

{-
QuickCheck cannot always infer which type we're using for our
randomly-generated data.

  -- What is the type of `a` ? Answer: any instance of Eq
  quickCheck (\a -> a == a)

To fix this, we could use one of two things:                        -}
-- 1. (argName :: Type) syntax
noisySyntax1 :: Effect Unit
noisySyntax1 = quickCheck (\(i :: Int) -> true)

noisySyntax2 :: Effect Unit
noisySyntax2 = quickCheck (\i -> (\_ -> true) (i :: Int))

-- 2. Use a function that specifies its type
intOnlyFunction :: Int -> Boolean
intOnlyFunction _ = true

functionThatSpecifiesType :: Effect Unit
functionThatSpecifiesType = quickCheck (\i -> intOnlyFunction i)
{-
Each adds "noise" to the syntax.

So, the below functions specify what the type is. When you read
these functions in actual tests, remove the "_type" suffix:
  - quickCheck_int        =>  quickCheck
  - quickCheck'_int       =>  quickCheck'

The functions appear at the bottom of the file.
-}

-- test that "b && true" reduces to "b"
-- This test will not stop after 2 tries, even though that's all it needs.
passingTest_exhaustive :: Effect Unit
passingTest_exhaustive = quickCheck_boolean (\b -> (b && true) == b)

-- Test that "+" works regardless of argument order (i.e. commutative)
passingTest_normal_threshold :: Effect Unit
passingTest_normal_threshold = quickCheck_int       (\i -> i + 1 == 1 + i)

-- increase confidence by increasing the number of tests
passingTest_custom_threshold :: Effect Unit
passingTest_custom_threshold = quickCheck'_int 1000 (\i -> i + 1 == 1 + i)

-- A test that fails will crash our program, preventing us from
-- seeing the output of other failing tests. We'll fix this by
-- preceding such tests with `printErrorMessage`. The function appears
-- at the bottom of the file.

error_message_None :: Effect Unit
error_message_None =
  printErrorMessage $ quickCheck_int (\i -> i + 1 == i)

{-
Quickcheck uses "[operator]?" syntax to add a standard error message

Normal without message | ==  | /=  | <  | <=  | >  | >=
Normal with    message | ==? | /=? | <? | <=? | >? | >=?
Alternative            | === | /== |
-}
error_message_Standard :: Effect Unit
error_message_Standard = do
  printErrorMessage $ quickCheck_int (\i -> i + 1 ==? i)
  log "" -- add a blank line in-between tests
  printErrorMessage $ quickCheck_int (\i -> i + 1 === i)
  log ""
  printErrorMessage $ quickCheck_int (\i -> i     /=? i)
  log ""
  printErrorMessage $ quickCheck_int (\i -> i     /== i)
  log ""
  printErrorMessage $ quickCheck_int (\i -> i + 1 <=? i)
  log ""
  printErrorMessage $ quickCheck_int (\i -> i + 1  <? i)
  log ""
  printErrorMessage $ quickCheck_int (\i -> i - 1  >? i)
  log ""
  printErrorMessage $ quickCheck_int (\i -> i - 1 >=? i)

error_message_Custom :: Effect Unit
error_message_Custom =
  printErrorMessage $ quickCheck_int
    (\i -> i + 1 == i <?> show i <> " did not equal " <> (show $ i + 1))

-- Helper functions

printErrorMessage :: Effect Unit -> Effect Unit
printErrorMessage test = catchException (\error -> log $ message error) test

data Result_
  = Success_
  | Failure_ String -- error message
-- "a" is
--    either a Boolean, which is converted into a Result
--    or     a Result itself.

quickCheck_boolean :: forall a. Testable a => (Boolean -> a) -> Effect Unit
quickCheck_boolean test = quickCheck test

quickCheck_int ::  forall a. Testable a => (Int -> a) -> Effect Unit
quickCheck_int test = quickCheck test

-- variant that allows one to specify the number of tests
quickCheck'_int :: forall a. Testable a => Int -> (Int -> a) -> Effect Unit
quickCheck'_int numOfTests test = quickCheck' numOfTests test
