-- shows multipe type parameters for the type class
class MultiParameterTypeClass type1 type2 where
  functionName :: type1 -> type2 -> ReturnType

-- Illustrates functional dependency
class TypeClassWithFunctionalDependency type1 type2 | type1 -> type2,  where
  functionName :: type1 -> type2
