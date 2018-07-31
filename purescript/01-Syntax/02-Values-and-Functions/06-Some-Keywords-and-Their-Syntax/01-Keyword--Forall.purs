{-
When using generic data types in functions, such as the one below:
Read:
  Given an instance of any type,
this function will return an instance of the same type. -}
genericFunction0 :: a -> a -- Compiler error!

-- We need to explicitly say the function works for for all types
-- using the "forall a. Type Signature" syntax:
genericFunction1 :: forall aType {- bType ... nType -}. a -> a
{- Read:
    For any type,
      which we'll refer to as, 'a',
  when given a value of type 'a',
then I will return a value of type 'a'
-}

genericFunction2 :: forall a b c. a -> b -> c
{- Read:
    For any three types,
      which we'll refer to as, 'a', 'b', and 'c',
  when given
    a value of type 'a', and
    a value of type 'b',
then I will return a value of type 'c'
-}


-- Sometimes, we'll see multiple instances of 'forall' in the same type signature.
-- In such cases, the parenthesis determine 'who' gets to determine what
-- a given type is. For example, who gets to determine what type 'b' is
-- in the following functions?
genericFunction3 :: forall a. (forall b. b -> a) -> a
genericFunction3 functionArg = -- implementation

genericFunction4 :: forall a b. (b -> a) -> a
genericFunction4 functionArg = -- implementation

-- In genericFunction3, functionArg gets to determine what the type of 'b' is.
-- However, genericFunction4 gets to determine what the type of 'b' type
--   is in `functionArg`.
-- Thus, genericFunction4 can add an additional
--   parameter ("-> b") whereas genericFunction3 cannot.

genericFunction4 :: forall a b. (b -> a) -> b -> a
genericFunction4 bToA b = bToA b
