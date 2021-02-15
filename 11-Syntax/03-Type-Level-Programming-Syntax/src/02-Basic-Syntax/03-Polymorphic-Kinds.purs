module Syntax.TypeLevel.PolymorphicKinds where

-- In the previous file, the following would not compile because `String` has
-- a kind that is different than the one expected by `MyData` below:

data MyKind
foreign import data OnlyValueForMyKind :: MyKind

data MyData :: MyKind -> Type
data MyData typeThatHasKind_'myKind' = MyData

-- Fails to Compile:
-- compileStatus_fail :: MyData String
-- compileStatus_fail = MyData

-- What if we wanted `MyData` to work "for all" kinds: `Type`, `MyKind`, or
-- one written by someone else? We would use "forall" syntax. This syntax
-- should look similar to how we would write it for a value-level function:
valueLevelFunction :: forall a. a -> a
valueLevelFunction valueOfType_a = valueOfType_a

-- Note: `kind` is often abbreviated as `k` to indicate kind.
data MyDataPolyKind :: forall kind. kind -> Type
data MyDataPolyKind typeThatHasAGivenKind = MyDataPolyKind

compilesSuccessfully1 :: MyDataPolyKind String -- kind is Type
compilesSuccessfully1 = MyDataPolyKind

compilesSuccessfully2 :: MyDataPolyKind OnlyValueForMyKind -- kind is MyKind
compilesSuccessfully2 = MyDataPolyKind
