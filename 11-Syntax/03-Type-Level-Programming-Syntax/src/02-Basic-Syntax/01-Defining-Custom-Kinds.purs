module Syntax.TypeLevel.DefiningCustomKinds where

----------------------
-- To change the value-level type into a type-level type:
data Value_Level_Type
  = Value_Level_Value1
  | Value_Level_Value2
----------------------
-- We first define a data type that does not have any data constructors.
-- This indicates that `Type_Level_Type` is a kind we created.
data Type_Level_Type

-- Then, we use FFI-like syntax to declare the type-level values that kind
-- has. We do not declare a right hand side (RHS) since it has no values
--                    |--------- RHS -------|
--      data SomeType = Value1 | Value2
-- Rather, we indicate that the type is a member of that kind using
-- the following syntax:
foreign import data Type_Level_Value1 :: Type_Level_Type
foreign import data Type_Level_Value2 :: Type_Level_Type

-- Note: there is no corresponding javascript file for this one
-- despite the "foreign import" syntax!
----------------------

-- Using a Boolean-like value-level type as an example...
data YesNo = Yes | No

data YesNoKind

foreign import data YesK :: YesNoKind
foreign import data NoK  :: YesNoKind
----------------------
