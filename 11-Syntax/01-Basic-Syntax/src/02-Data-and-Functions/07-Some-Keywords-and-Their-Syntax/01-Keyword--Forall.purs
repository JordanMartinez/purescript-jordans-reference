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
-- This means that the third argument, the function with `forall c`,
-- can be used on different types. These are known as "Rank-N Types."
-- "Rank" is a term the compiler uses when inferring a given type.
-- Thus, we can write something like this:

ignoreArg_returnString :: forall a. a -> String
ignoreArg_returnString _ = "some string"

example
  :: forall first second
   . (forall anyType. anyType -> String)
   -> first
   -> second
   -> String
example function firstValue secondValue =
  concat (function firstValue) (function secondValue)

testExample :: String
testExample = example ignoreArg_returnString true 5

-- needed to compile

concat :: String -> String -> String
concat = append
