module Keyword.Data where

import Prelude

-- Syntax
data InterfaceLikeType {- generic types -} aType bType {- and so on... -}
  = ImplementationConstructor_NoArgs
  | ImplementationConstructor_Args Type1 Type2 Type3
  | ImplementationConstructor_FunctionArg (Type1 -> Type2)
  | ImplementationConstructor_RecursiveArg (InterfaceLikeType aType bType)
  | ImplementationConstructor_GenericArgs aType bType
  | ImplementationConstructor_MixOfArgs Type_ (A -> B) bType (InterfaceLikeType aType bType)

-- two basic types (though more 'advanced' ones also exist)
data SumType
  = SumConstructor1
  | SumConstructor2
  | SumConstructorN

-- example
-- an enum-like type that only has 3 different implementations
data Fruit
  = Apple
  | Banana
  | Orange

data ProductType a b
  = ProductConstructor1 a
  | ProductConstructor2 b

-- example
-- a type that's either the a (wrapped in Left) or b (wrapped in Right)
data Either a b
  = Left a
  | Right b


-- Necessary for this to compile
data Type1
data Type2
data Type3
data Type_
data A
data B
