module Syntax.TypeLevel.Reflection where

-- ignore this
import Prelude (class Show)

-- Reflection syntax
--  Converting a type-level value into a value-level value

-- This code...
----------------------------
type Value_Level_Type = String -- for easier readability

data CustomType = TypeValue

reflectVL :: CustomType -> Value_Level_Type
reflectVL TypeValue = "value-level value"
----------------------------
-- ... converts to...
----------------------------
data CustomKind
foreign import data CustomKindValue :: CustomKind

data Proxy :: forall k. k -> Type
data Proxy kind = Proxy

-- "type-level value to value-level value"
class TLI_to_VLI :: CustomKind -> Constraint
class TLI_to_VLI customKind where
  reflectCustomKind :: Proxy customKind -> Value_Level_Type

instance tli_to_vlI :: TLI_to_VLI CustomKindValue where {-
  reflectCustomKind Proxy = "value-level value" -}
  reflectCustomKind _     = "value-level value"
----------------------------

-- An example using the Boolean-like data type YesNo:
data YesNo = Yes | No

data YesNoKind
foreign import data YesK :: YesNoKind
foreign import data NoK  :: YesNoKind

{-
Read yesK and noK as:
  yesK = (YesNoProxyValue :: YesNoProxy Yes) - a value of type "YesNoProxy Yes"
  noK  = (YesNoProxyValue :: YesNoProxy No)  - a value of type "YesNoProxy No" -}
yesK :: Proxy YesK
yesK = Proxy

noK :: Proxy NoK
noK = Proxy

class IsYesNoKind :: YesNoKind -> Constraint
class IsYesNoKind a where
  reflectYesNo :: Proxy a -> YesNo

instance yesTL_VL :: IsYesNoKind YesK where
-- reflectYesNo (Proxy :: Proxy Yes) = Yes
   reflectYesNo _                    = Yes

instance noTL_VL :: IsYesNoKind NoK where
-- reflectYesNo (Proxy :: Proxy No) = No
   reflectYesNo _                   = No


-- We can also use instance chains here to distinguish
-- one from another

class IsYes :: YesNoKind -> Constraint
class IsYes a where
  isYes :: Proxy a -> YesNo

instance isYes_Yes :: IsYes YesK where
  isYes _ = Yes
else instance isYes_catchall :: IsYes a where
  isYes _ = No

-- Using instance chains here is more convenient if we had
-- a lot more type-level values than just 2. In some cases,
-- it is needed in cases where a type-level type can have an
-- infinite number of values, such as a type-level String

-- Open a REPL, import this module, and then run this code:
--    reflectYesNo yesK
--    reflectYesNo noK
--    isYes yesK
--    isYes noK


-- necessary for not getting errors while trying the functions in the REPL

instance showYNVLT :: Show YesNo where
    show Yes = "Yes"
    show No  = "No"
