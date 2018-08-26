module Syntax.TypeLevel.DefiningCustomKinds where

----------------------
-- To change the value-level type into a type-level type:
data Value_Level_Type
  = Value_Level_Instance1
  | Value_Level_Instance2
----------------------
-- We use this FFI-like syntax:
foreign import kind Value_Level_Type_Kind

-- and do not declare a right hand side (RHS) since it has no instances
--                    |--------- RHS -------|
--      data SomeType = Instance1 | Instance2
foreign import data Value_Level_Instance1 :: Value_Level_Type_Kind
foreign import data Value_Level_Instance2 :: Value_Level_Type_Kind

-- Note: there is no corresponding javascript file for this one
-- despite the "foreign import" syntax!
----------------------

-- Using the value-level type Boolean as an example...
data Boolean_ = True_Value | False_Value

foreign import kind Boolean

foreign import data True :: Boolean
foreign import data False :: Boolean
----------------------
