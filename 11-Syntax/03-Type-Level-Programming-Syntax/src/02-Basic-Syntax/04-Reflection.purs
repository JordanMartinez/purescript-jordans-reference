module Syntax.TypeLevel.Reflection where

-- ignore this
import Prelude (class Show)

-- Reflection syntax
--  Converting a type-level instance into a value-level instance

-- This code...
----------------------------
type Value_Level_Type = String -- for easier readability

data CustomType = TypeInstance

reflectVL :: CustomType -> Value_Level_Type
reflectVL TypeInstance = "value-level instance"
----------------------------
-- ... converts to...
----------------------------
foreign import kind CustomKind
foreign import data CustomKindInstance :: CustomKind

data CustomKindProxy (a :: CustomKind) = CustomKindProxyInstance

-- "type-level instance to value-level instance"
class TLI_to_VLI (a :: CustomKind) where
  reflectCustomKind :: CustomKindProxy a -> Value_Level_Type

instance tli_to_vlI :: TLI_to_VLI CustomKindInstance where {-
  reflectCustomKind CustomKindProxyInstance = "value-level instance" -}
  reflectCustomKind _                       = "value-level instance"
----------------------------

-- An example using Booleans:
data Boolean_ = True_Value | False_Value

foreign import kind BooleanKind
foreign import data True :: BooleanKind
foreign import data False :: BooleanKind
data BooleanProxy (a :: BooleanKind) = BooleanProxyInstance

{-
Read trueK and falseK as:
  trueK  = (BooleanProxyInstance :: BooleanProxy True) - an instance of type "BooleanProxy True"
  falseK = (BooleanProxyInstance :: BooleanProxy False) - an instance of type "BooleanProxy False" -}
trueK :: BooleanProxy True
trueK = BooleanProxyInstance

falseK :: BooleanProxy False
falseK = BooleanProxyInstance

class IsBooleanKind (a :: BooleanKind) where
  reflectBoolean :: BooleanProxy a -> Boolean_

instance trueTL_VL :: IsBooleanKind True where
-- reflectBoolean (BooleanProxyInstance :: BooleanProxy True) = True_Value
   reflectBoolean _                                           = True_Value

instance falseTL_VL :: IsBooleanKind False where
-- reflectBoolean (BooleanProxyInstance :: BooleanProxy False) = False_Value
   reflectBoolean _                                            = False_Value


-- We can also use instance chains here to distinguish
-- one from another

class IsTrue (a :: BooleanKind) where
  isTrue :: BooleanProxy a -> Boolean_

instance isTrue_True :: IsTrue True where
  isTrue _ = True_Value
else instance isTrue_catchall :: IsTrue a where
  isTrue _ = False_Value

-- Using instance chains here is more convenient if we had
-- a lot more type-level instances than just 2. In some cases,
-- it is needed in cases where a type-level type can have an
-- infinite number of instances, such as a type-level String

-- Open a REPL, import this module, and then run this code:
--    reflectBoolean trueK
--    reflectBoolean falseK
--    isTrue trueK
--    isTrue falseK


-- necessary for not getting errors while trying the functions in the REPL

instance showBVLT :: Show Boolean_ where
    show True_Value  = "True_Value"
    show False_Value = "False_Value"
