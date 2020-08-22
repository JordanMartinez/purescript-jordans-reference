module Syntax.TypeLevel.KindSignatures where

-- We showed previously that `data`, `type`, `newtype`, and `class` declarations
-- can all have explicit kind signatures. In previous situations,
-- kind signatures only used the kind, `Type`. Now that we know how to
-- define our own custom kind, let's use it below.

data A_Kind_I_Created
foreign import data Only_Value_For_My_Kind :: A_Kind_I_Created

data DataExample :: A_Kind_I_Created -> Type
data DataExample a_kind_I_created_type_level_value = DataExample

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

type TypeExample :: A_Kind_I_Created -> Type
type TypeExample a_kind_I_created_type_level_value = Int

newtype NewtypeExample :: A_Kind_I_Created -> Type
newtype NewtypeExample a_kind_I_created_type_level_value = NewtypeExample Int

-- Similarly, a type class can use kinds other than `Type`. This type class
-- does not have any functions/values:
class TypeClassExample :: A_Kind_I_Created -> Constraint
class TypeClassExample a_kind_I_created_type_level_value
