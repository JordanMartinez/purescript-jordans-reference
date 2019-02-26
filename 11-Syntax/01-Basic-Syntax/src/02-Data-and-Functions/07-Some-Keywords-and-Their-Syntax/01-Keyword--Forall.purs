module Keyword.Forall where

import Prelude

{-
When using generic data types in functions, such as the one below...
genericFunction0 :: a -> a
  Read:
    Given an instance of any type,
  this function will return an instance of the same type. -}

-- ... we need to explicitly say the function works for for all types
-- using the "forall a. Function Type Signature" syntax:
genericFunction1 :: forall aType {- bType ... nType -}. aType -> aType
genericFunction1 x = x
{- Read:
    For any type,
      which we'll refer to as, 'a',
  when given a value of type 'a',
then I will return a value of type 'a'
-}

genericFunction2 :: forall a b c. a -> b -> c -> a
genericFunction2 a b c = a
{- Read:
    For any three types,
      which we'll refer to as, 'a', 'b', and 'c',
  when given
    a value of type 'a', and
    a value of type 'b', and
    a value of type 'c',
then I will return a value of type 'a'
-}

-- Another way to write 'forall' in a much more concise manner is
-- via Unicode syntax: "∀"
forAllUnicodeStyle :: ∀ a. a -> a
forAllUnicodeStyle a = a


-- Sometimes, we'll see multiple instances of 'forall' in the same type signature.
--
--    f :: forall a b. a -> b -> (forall c. c -> String) -> String
--
-- This means that the third argument, the function with `forall c`,
-- can be used on different types. Thus, we can write something like this:

ignoreArg_returnString :: forall a. a -> String
ignoreArg_returnString _ = "some string"

example :: forall a b. a -> b -> (forall c. c -> String) -> String
example a b function = concat (function a) (function b)

testExample :: String
testExample = example true 5 ignoreArg_returnString

-- needed to compile

concat :: String -> String -> String
concat = append
