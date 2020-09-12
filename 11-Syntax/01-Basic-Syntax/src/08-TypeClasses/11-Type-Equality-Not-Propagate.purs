module Syntax.Basic.Typeclass.Gotchas.TypeEqualityNotPropagate where

import Unsafe.Coerce (unsafeCoerce)

-- ## Gotcha Number 1: Type Equality isn't yet included in Type Class Constraints

-- ### Example of the Problem

-- Given a type class like so...
class TwoTypesButTheyAreTheSameThing a b | a -> b, b -> a

-- and an instance like so...
instance exampleTypeClass :: TwoTypesButTheyAreTheSameThing Int Int

-- ... the below code will fail to compile
{-
foo :: forall int
     . TwoTypesButTheyAreTheSameThing Int int
    => int
foo = 8

Compiler Error:

  Could not match type

      Int

    with type

      int0


  while checking that type Int
    is at least as general as type int0
  while checking that expression 8
    has type int0
  in value declaration foo

  where sameAsInt0 is a rigid type variable
          bound at (line 9, column 7 - line 9, column 8)

-}

-- Why? Because the compiler does not also infer that `int` must be
-- the type, `Int`, when solving the type class constraint, even if the
-- instance and type class' functional dependencies indicate otherwise.

-- ### Current Workaround

class A_Determines_B a b | a -> b

instance aDeterminesB :: A_Determines_B Int String

-- The below "foreign import" syntax will be covered more in the FFI folder
foreign import data Computed :: Type -> Type

fromComputed :: forall a b. A_Determines_B a b => Computed a -> b
fromComputed = unsafeCoerce

toComputed :: forall a b. A_Determines_B a b => b -> Computed a
toComputed = unsafeCoerce

-- As hdgarood explained it,
-- "This is safe because you have to tell the compiler that you have an
-- `A_Determines_B a b` instance before it will coerce between the `a` and `b`.
-- But yes it’s expected that constraints with fundeps don’t propagate
-- type equalities. That’s not yet implemented."
