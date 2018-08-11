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
-- an enum-like type that only has 3 different implementations
data Fruit
  = Apple
  | Banana
  | Orange

-- It's called a 'sum' type because if the argument passed to a function
-- is a sum type, the possible arguments passed to that function are the sum
-- of all of its constructors. In the case of Fruit, there are 3 possible
-- arguments to a function that takes a type of Fruit as its argument.

data ProductType a b
  = ProductConstructor1 a
  | ProductConstructor2 b

-- example
-- a type that's either the a (wrapped in Left) or b (wrapped in Right)
data Tuple a b = Both a b

-- Necessary for this to compile
data Type1
data Type2
data Type3
data Type_
data A
data B
