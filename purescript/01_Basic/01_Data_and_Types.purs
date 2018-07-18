data SingleDataType_NoArgs = Constructor
data SingleDataType_WithArgs = Constructor Argument

data SumType
  = SumConstructor1
  | SumConstructor2
  | SumConstructorN

data ProductType a b
  = ProductConstructor1 a
  | ProductConstructor2 b
  | ProductConstructorN a b

-- Generic Algebraic Data Type
data GADT a b c {- non-monadic types -} f g h m {- monadic types -}
  = Constructor1 a b f  -- use a mixture of the generic types
  | Constructor2 f g    -- only of one kind
  | ConstructorN h      -- only one
  | ConstructorZ        -- or none at all

type TypeAliasNameForCompileTime = RunTimeType {-
type Age = Int
type ComplexFunction = Int -> (forall a b. a -> (forall c. c -> b) -> b)
-}
