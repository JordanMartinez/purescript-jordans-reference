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

-- An example using the Boolean-like data type YesNo:
data YesNo = Yes | No

foreign import kind YesNoKind
foreign import data YesK :: YesNoKind
foreign import data NoK  :: YesNoKind
data YesNoProxy (a :: YesNoKind) = YesNoProxyInstance

{-
Read yesK and yesK as:
  yesK = (YesNoProxyInstance :: YesNoProxy Yes) - an instance of type "YesNoProxy Yes"
  noK  = (YesNoProxyInstance :: YesNoProxy No)  - an instance of type "YesNoProxy No" -}
yesK :: YesNoProxy YesK
yesK = YesNoProxyInstance

noK :: YesNoProxy NoK
noK = YesNoProxyInstance

class IsYesNoKind (a :: YesNoKind) where
  reflectYesNo :: YesNoProxy a -> YesNo

instance yesTL_VL :: IsYesNoKind YesK where
-- reflectYesNo (YesNoProxyInstance :: YesNoProxy Yes) = Yes
   reflectYesNo _                                      = Yes

instance noTL_VL :: IsYesNoKind NoK where
-- reflectYesNo (YesNoProxyInstance :: YesNoProxy No) = No
   reflectYesNo _                                     = No


-- We can also use instance chains here to distinguish
-- one from another

class IsYes (a :: YesNoKind) where
  isYes :: YesNoProxy a -> YesNo

instance isYes_Yes :: IsYes YesK where
  isYes _ = Yes
else instance isYes_catchall :: IsYes a where
  isYes _ = No

-- Using instance chains here is more convenient if we had
-- a lot more type-level instances than just 2. In some cases,
-- it is needed in cases where a type-level type can have an
-- infinite number of instances, such as a type-level String

-- Open a REPL, import this module, and then run this code:
--    reflectYesNo yesK
--    reflectYesNo noK
--    isYes yesK
--    isYes noK


-- necessary for not getting errors while trying the functions in the REPL

instance showYNVLT :: Show YesNo where
    show Yes = "Yes"
    show No  = "No"
