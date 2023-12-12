module Syntax.TypeLevel.Reflection where

-- ignore this
import Prelude (class Show)

-- In PureScript 0.15.13, Visible Type Applications were fully supported.
-- Before that release, we had to use `Proxy` arguments.
-- Now, we can use VTAs in some contexts. This file will show both for clarity.

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

-- PureScript <0.15.13 Approach: use Proxy arguments

data Proxy :: forall k. k -> Type
data Proxy kind = Proxy

-- "type-level value to value-level value"
class TLI_to_VLI :: CustomKind -> Constraint
class TLI_to_VLI customKind where
  reflectCustomKind :: Proxy customKind -> Value_Level_Type

instance TLI_to_VLI CustomKindValue where {-
  reflectCustomKind Proxy = "value-level value" -}
  reflectCustomKind _     = "value-level value"

-- PureScript >=0.15.13 Approach: use Visible Type Applications

-- "type-level value to value-level value"
class TLI_to_VLI_Vta :: CustomKind -> Constraint
class TLI_to_VLI_Vta customKind where
  reflectCustomKindVta :: Value_Level_Type

instance TLI_to_VLI_Vta CustomKindValue where
  reflectCustomKindVta = "value-level value"

----------------------------

-- An example using the Boolean-like data type YesNo:
data YesNo = Yes | No

data YesNoKind
foreign import data YesK :: YesNoKind
foreign import data NoK  :: YesNoKind

-- PureScript <0.15.13 Approach: use Proxy arguments
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

instance IsYesNoKind YesK where
-- reflectYesNo (Proxy :: Proxy Yes) = Yes
   reflectYesNo _                    = Yes

instance IsYesNoKind NoK where
-- reflectYesNo (Proxy :: Proxy No) = No
   reflectYesNo _                   = No


-- We can also use instance chains here to distinguish
-- one from another

class IsYes :: YesNoKind -> Constraint
class IsYes a where
  isYes :: Proxy a -> YesNo

instance IsYes YesK where
  isYes _ = Yes
else instance IsYes a where
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

-- PureScript >=0.15.13 Approach: use Visible Type Applications

class IsYesNoKindVta :: YesNoKind -> Constraint
class IsYesNoKindVta a where
  reflectYesNoVta :: YesNo

instance IsYesNoKindVta YesK where
   reflectYesNoVta = Yes

instance IsYesNoKindVta NoK where
   reflectYesNoVta = No


-- We can also use instance chains here to distinguish
-- one from another

class IsYesVta :: YesNoKind -> Constraint
class IsYesVta a where
  isYesVta :: YesNo

instance IsYesVta YesK where
  isYesVta = Yes
else instance IsYesVta a where
  isYesVta = No

-- Using instance chains here is more convenient if we had
-- a lot more type-level values than just 2. In some cases,
-- it is needed in cases where a type-level type can have an
-- infinite number of values, such as a type-level String

-- Open a REPL, import this module, and then run this code:
--    reflectYesNoVta @YesK
--    reflectYesNoVta @NoK
--    isYesVta @YesKyesK
--    isYesVta @NoK


-- necessary for not getting errors while trying the functions in the REPL

instance Show YesNo where
    show Yes = "Yes"
    show No  = "No"
