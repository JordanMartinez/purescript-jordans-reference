module Syntax.TypeLevel.DefiningCustomKinds where

----------------------
-- To change the value-level type into a type-level type:
data Value_Level_Type
  = Value_Level_Value1
  | Value_Level_Value2
----------------------
-- We use this FFI-like syntax:
-- equivalent to    Kind
foreign import kind Type_Level_Type

-- and do not declare a right hand side (RHS) since it has no values
--                    |--------- RHS -------|
--      data SomeType = Value1 | Value2
foreign import data Type_Level_Value1 :: Type_Level_Type
foreign import data Type_Level_Value2 :: Type_Level_Type

-- Note: there is no corresponding javascript file for this one
-- despite the "foreign import" syntax!
----------------------

-- Using a Boolean-like value-level type as an example...
data YesNo = Yes | No

foreign import kind YesNoKind

foreign import data YesK :: YesNoKind
foreign import data NoK  :: YesNoKind
----------------------
