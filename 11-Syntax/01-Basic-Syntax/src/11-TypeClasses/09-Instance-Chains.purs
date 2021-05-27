module Syntax.Basic.Typeclass.InstanceChains where

-- ## Instance Chains: Syntax

import Prelude -- imports the '+' operation below...

data Type1 = Type1
data Type2 = Type2
data Type3 = Type3

-- A kind signature is necessary here because `theType`
-- `ExampleClass1` doesn't define a function or value that refers to `theType`
-- in that function/value's type signature.
class ExampleClass1 :: Type -> Constraint
class ExampleClass1 theType

-- Instance chains are a workaround to the problem of "overlapping instances."
-- Here's how the syntax works:
instance ExampleClass1 Type1
else instance ExampleClass1 Type2
-- ...
else instance ExampleClass1 Type3

-- For readability, the `else` and `instance` keywords can appear on
-- their own line or with a newline separating the keywords
class ExampleClass2 :: Type -> Constraint
class ExampleClass2 theType

instance ExampleClass2 Type1
else
instance ExampleClass2 Type2
else

instance ExampleClass2 Type3

-- ## Instance Chains: Use Cases

-- Instance chains are useful because they allow you to define multiple
-- instances for a given type class, but define the order in which the
-- type class constraint is solved.

data SomeRandomType
  = FirstValue
  | SecondValue

class ProduceAnInt a where
  mkInt :: a -> Int

-- When solving for `ProduceAnInt someType`, the compiler will
-- solve for `someType` in the following order:
instance ProduceAnInt Int where
  mkInt theInt = theInt
else
instance ProduceAnInt String where
  mkInt _ = 13
else
instance ProduceAnInt SomeRandomType where
  mkInt FirstValue = 89
  mkInt SecondValue = 98
else
instance ProduceAnInt allOtherPossibleTypes where
  mkInt _ = 42

data HasNoInstance = HasNoInstance

example :: Int
example =
  (mkInt 1 ) + (mkInt "foo") + (mkInt FirstValue) + (mkInt HasNoInstance)     {-

  which, once the constraints are solved, will be the same as computing

  (1)        + (13)          + (89)               + (42)                      -}


-- ## Instance Chains Gotchas: No Backtracking

-- Given the following type class

class Stringify a where
  stringify :: a -> String

-- One might write an instance chain like so with the following idea:
-- 1. First attempt to show the item using that type class instance
-- 2. Otherwise, indicate that it cannot be shown.

instance (Show allPossibleTypes) => Stringify allPossibleTypes where
  stringify a = show a
else
instance Stringify a where
  stringify _ = "The value could not be converted into a String."

-- Then, one might attempt to use that code like so:
data Foo = Foo

-- failsToCompile :: String
-- failsToCompile = stringify "a normal string" <> stringify Foo

{-
Uncommenting that will produce the following compiler error:

  No type class instance was found for

      Data.Show.Show Foo


  while applying a function stringify
    of type Stringify t0 => t0 -> String
    to argument Foo
  while checking that expression stringify Foo
    has type String
  in value declaration failsToCompile

  where t0 is an unknown type

-}

-- Why does this occur? Because the `doMeFirst` instance will match on
-- every type since the parameter passed to Stringify is literally
-- `allPossibleTypes`. It will then attempt to find the `Show` instance
-- for `allPossibleTypes`. In the case of `Foo`, which does not
-- have such an instance, the compiler does not "backtrack" and
-- attempt to use the `defaultToMeOtherwise` instance. Rather, it immediately
-- fails with the above error.
-- Backtracking is a feature that has not yet been implemented in the
-- compiler.
