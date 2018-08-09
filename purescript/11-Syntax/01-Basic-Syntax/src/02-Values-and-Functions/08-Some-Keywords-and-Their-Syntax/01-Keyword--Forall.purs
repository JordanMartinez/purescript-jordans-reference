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

-- Another way to write 'forall' in a much more consie manner is
-- via Unicode syntax: "∀"
forAllUnicodeStyle :: ∀ a. a -> a
forAllUnicodeStyle a = a


-- Sometimes, we'll see multiple instances of 'forall' in the same type signature.
-- In such cases, the parenthesis determine 'who' gets to determine what
-- a given type is. For example, who gets to determine what type 'b' is
-- in the following functions?
genericFunction3 :: (forall b. b -> String) -> String
genericFunction3 functionArg = "body"

genericFunction4 :: forall b. (b -> String) -> String
genericFunction4 functionArg = "body"

-- In genericFunction3, functionArg gets to determine what the type of 'b' is.
-- However, genericFunction4 gets to determine what the type of 'b' type
--   is in `functionArg`.
