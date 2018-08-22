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

-- This kind of syntax enables Algebraic Data Types (ADTs)
-- For an explanation on how 'data types' can be 'algebraic,' see this video:
-- https://youtu.be/Up7LcbGZFuo?t=19m8s

-- the sum type
data SumType
  = SumConstructor1
  | SumConstructor2
  | SumConstructorN

-- example
data Fruit
  = Apple
  | Banana
  | Orange

-- the product type
data ProductType a b = ProductConstructor a b

-- example
data IntAndString = IAndS Int String

-- Necessary for this to compile
data Type1
data Type2
data Type3
data Type_
data A
data B
