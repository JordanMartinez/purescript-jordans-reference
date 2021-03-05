module Syntax.TypeLevel.Conventions where

-- This file shows the patterns and naming schemes used when writing
-- type-level programming code. Refer to this whenever you're lost.

-- Entities that have the comment "NANS" mean "no apparent naming scheme".
-- In other words, there is not a naming scheme that people seem to follow.
-- So, name it however you want.

-- Entities that do seem to have naming scheme will have their explanation
-- above them in a comment.

type Value_Level_Type = String

data KindName
foreign import data Value :: KindName

data Proxy :: forall k. k -> Type
data Proxy kind = Proxy

-- NANS
inst :: Proxy Value
inst = Proxy

-- The class name is usually "Is[KindName]"
class IsKindName :: KindName -> Constraint
class IsKindName a where
  -- and the reflect function is usually "reflect[KindName]"
  reflectKindName :: Proxy a -> Value_Level_Type

instance reflectValue :: IsKindName Value where
  reflectKindName _ = "value-level value"

-- NANS
class IsKindName a <= ConstrainedToKindName a

-- NANS
instance constraintValue :: ConstrainedToKindName Value

-- Usually reify[KindName]
reifyKindName :: forall r
           . Value_Level_Type
          -> (forall a. IsKindName a => Proxy a -> r)
          -> r
reifyKindName valueLevel function = function inst
