module Syntax.TypeLevel.Conventions where

-- This file shows the patterns and naming schemes used when writing
-- type-level programming code. Refer to this whenever you're lost.

-- Entities that have the comment "NANS" mean "no apparent naming scheme".
-- In other words, there is not a naming scheme that people seem to follow.
-- So, name it however you want.

-- Entities that do seem to have naming scheme will have their explanation
-- above them in a comment.

type Value_Level_Type = String

foreign import kind KindName
foreign import data Instance :: KindName

-- The Proxy type usually has the first letter of the value-level type
-- ("K" for "KindName") followed by "Proxy". The instance name
-- is the same as its type.
data KProxy (a :: KindName) = KProxy

-- NANS
inst :: KProxy Instance
inst = KProxy

-- The class name is usually "Is[KindName]"
class IsKindName (a :: KindName) where
  -- and the reflect function is usually "reflect[KindName]"
  reflectKind :: KProxy a -> Value_Level_Type

-- NANS
instance reflectInstance :: IsKindName Instance where
  reflectKind _ = "value-level instance"

-- NANS
class IsKindName a <= ConstrainedToKindName a

-- NANS
instance constraintInstance :: ConstrainedToKindName Instance

-- Usually reify[KindName]
reifyKindName :: forall r
           . Value_Level_Type
          -> (forall a. ConstrainedToKindName a => KProxy a -> r)
          -> r
reifyKindName valueLevel function = function inst
