module Syntax.TypeLevel.KindSignatures where

-- We showed previously that `data`, `type`, `newtype`, and `class` declarations
-- can all have explicit kind signatures. In previous situations,
-- kind signatures only used the kind, `Type`. Now that we know how to
-- define our own custom kind, let's use it below.

data A_Kind_I_Created
foreign import data Only_Value_For_My_Kind :: A_Kind_I_Created

data DataExample :: A_Kind_I_Created -> Type
data DataExample a_kind_I_created_type_level_value = DataExample

type DataExample :: A_Kind_I_Created -> Type
type DataExample a_kind_I_created_type_level_value = Int

newtype NewtypeExample :: A_Kind_I_Created -> Type
newtype NewtypeExample a_kind_I_created_type_level_value = NewtypeExample Int

-- This will succesfully compile because `Only_Value_For_My_Kind` has
-- kind, `A_Kind_I_Created`, which matches the one expected in the
-- declaration for `DataExample`.
compileStatus_success :: DataExample Only_Value_For_My_Kind
compileStatus_success = DataExample

-- This will fail to compile because `String` has
-- kind, `Type`, not kind, `A_Kind_I_Created`.
-- 
-- compileStatus_fail :: DataExample String
-- compileStatus_fail = DataExample

-- To fix this, we use a Proxy type,
--    a value-level type that wraps a kind:
data Proxy (kindValue :: Kind) = ProxyValue

-- The above definition will make more sense in the future.

-- We can use Proxy to create type-level values
