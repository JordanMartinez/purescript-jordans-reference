module Syntax.Basic.Typeclass.KindSignatures where

import Prelude

{-
We saw previously that a data type can have a kind signature:
-}

-- Kind Signature: Type -> Type -> Type
data ImplicitKindSignature1 a b = ImplicitKindSignature2 a b String

data ExplicitKindSignature1 :: Type -> Type -> Type
data ExplicitKindSignature1 a b = ExplicitKindSignature1 a b String

-- Kind Signature:         Type -> Type
type ImplicitKindSignature2 a = ImplicitKindSignature1 a Int

type ExplicitKindSignature2 :: Type -> Type
type ExplicitKindSignature2 a = ExplicitKindSignature1 a Int

-- We also saw that we can use type classes to constrain data types
showStuff :: forall a. Show a => a -> String
showStuff a = "Showing 'a' produces " <> show a

{-
It turns out that type classes can also have kind signatures.
However, rather than the right-most value representing a "concrete" type,
these represent a "concrete" constraint.                                      -}

-- Kind Signature: Type -> Consraint
class ImplicitKindSignature a where
  someValue1 :: a -> String

class ExplicitKindSignature :: Type -> Constraint
class ExplicitKindSignature a where
  someValue2 :: a -> String

-- Remember, `data` and `type`'s right-most entity/kind is `Type` whereas
-- type classes' right-most entity/kind is `Constraint`.
