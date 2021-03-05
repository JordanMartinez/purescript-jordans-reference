module Syntax.Basic.Keyword.Forall where

import Prelude

{-
When using generic data types in functions, such as the one below...
genericFunction0 :: a -> a
  Read:
    Given a value of any type,
  this function will return a value of the same type. -}

-- ... we need to explicitly say the function works for all types.
-- We do so by adding the "forall a." syntax to the front of our
-- type signature. Note: the "forall" syntax is still a part of our type
-- signature, but it always appears first before anything else.
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

-- Sometimes, we'll see multiple 'forall' in the same type signature.
--
--    f :: forall a b. a -> b -> (forall c. c -> String) -> String
--
-- These are called "Rank-N Types."
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
