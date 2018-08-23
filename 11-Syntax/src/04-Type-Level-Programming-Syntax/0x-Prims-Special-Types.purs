module Syntax.TypeLevel.SpecialTypesAndTheirKinds where

import Prelude

{-
Every Purescript project imports the Prim package by default. This is what
was used to describe the kind of Int, Array, and Function. Now that we have
a deeper understanding of the language and know what type-level programming is,
we can show more types and kinds and explain them further.

Recall from earlier:
Type == Kind *
# Type = n-sized number of types known at compile time


Symbol = a type-level String of kind *
-}
--
-- data TypeString :: Type -> Symbol
--
-- data TypeConcat :: Symbol -> Symbol -> Symbol
--
-- class Union (l :: # Type) (r :: # Type) (u :: # Type) | l r -> u, r u -> l, u l -> r
--
-- class RowCons (l :: Symbol) (a :: Type) (i :: # Type) (o :: # Type) | l a i -> o, l o -> a i
