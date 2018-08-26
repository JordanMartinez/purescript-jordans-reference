module Syntax.TypeLevel.Reflection where

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
data BooleanProxy (a :: BooleanKind) = BProxyInstance

trueK :: BooleanProxy True
trueK = BProxyInstance

falseK :: BooleanProxy False
falseK = BProxyInstance

class IsBooleanKind (a :: BooleanKind) where
  reflectBoolean :: BooleanProxy a -> Boolean

instance trueTL_VL :: IsBooleanKind True where
  reflectBoolean _  = true

instance falseTL_VL :: IsBooleanKind False where
  reflectBoolean _  = false

-- Open a REPL, import this module, and then run this code:
--    reflectBoolean trueK
--    reflectBoolean falseK
