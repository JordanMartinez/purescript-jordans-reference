-- Syntax
data InterfaceLikeType
  = ImplementationConstructorWithNoArgs
  | ImplementationConstructorWithArgs Type1 Type2 Type3
  | ImplementationConstructorWithRecursiveArg InterfaceLikeType

-- two basic types
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
  | ProductConstructorN a b

-- example
-- a type that's either the a (wrapped in Left) or b (wrapped in Right)
data Either a b
  = Left a
  | Right b

type TypeAliasNameForCompileTime = RunTimeType {-
type Age = Int
type ComplexFunction = Int -> (forall a b. a -> (forall c. c -> b) -> b)
-}
