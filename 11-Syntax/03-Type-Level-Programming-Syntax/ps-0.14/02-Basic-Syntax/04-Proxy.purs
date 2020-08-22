module Syntax.TypeLevel.Proxy where

-- When we write programs, arguments and definitions are at the value-level.
-- Since the values of type-level types (i.e. kinds) are types themselves,
-- how do we pass type-level values around in our program when the program
-- is written at the value level?

-- For type-level values, we use a simple type that "stores" the type-level
-- value as a phantom type (see `Design Patterns/Phantom Types.md`).
-- By making that phantom type polymorphic on kinds (i.e polykinded),
-- one type will work for all kinds:
data Proxy :: forall kind. kind -> Type
data Proxy k = Proxy

-- Given that we have the following two custom kinds...

-- data Kind_1
--   = Kind_1_Value_1
--   = Kind_1_Value_2
data Kind_1
foreign import data Kind_1_Value_1 :: Kind_1
foreign import data Kind_1_Value_2 :: Kind_1

data Kind_2
foreign import data Kind_2_Value :: Kind_2

-- ... we can define a value that stores the type-level value via `Proxy` ...

kind1Value1 :: Proxy Kind_1_Value_1
kind1Value1 = Proxy

kind2Value :: Proxy Kind_2_Value
kind2Value = Proxy

-- ... and pass around the type-level values by passing around the Proxy value
-- and annotating the type signature with the type-level value.

-- This function only works on the first `Kind_1_Value`.
kind1_to_kind2_specific :: Proxy Kind_1_Value_1 -> Proxy Kind_2_Value
kind1_to_kind2_specific _ {- Proxy, which can be ignored -} =
  Proxy -- Proxy whose type is different than first Proxy type

-- This function only works on all possible `Kind_1_Value`s.
kind1_to_kind2_generic
  :: forall (kind1Values :: Kind_1) (kind2Values :: Kind_2)
   . Proxy kind1Values
  -> Proxy kind2Values
kind1_to_kind2_generic _ {- Proxy, which can be ignored -} =
  Proxy -- Proxy whose type is different than first Proxy type

-- The above definition will make more sense in the future.
