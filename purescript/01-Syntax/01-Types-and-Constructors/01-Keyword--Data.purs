-- Syntax
data InterfaceLikeType {- generic types -} aType bType {- and so on... -}
  = ImplementationConstructor_NoArgs
  | ImplementationConstructor_Args Type1 Type2 Type3
  | ImplementationConstructor_FunctionArg (Type1 -> Type2)
  | ImplementationConstructor_RecursiveArg InterfaceLikeType
  | ImplementationConstructor_GenericArgs aType bType
  | ImplementationConstructor_MixOfArgs Type_ (A -> B) bType InterfaceLikeType

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
