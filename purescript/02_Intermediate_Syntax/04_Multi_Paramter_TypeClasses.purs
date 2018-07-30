-- shows multipe type parameters for the type class
class MultiParameterTypeClass type1 type2 where
  functionName :: type1 -> type2 -> ReturnType

-- example

class ConvertFromAToB a b where
  convert :: a -> b

instance convertBoolToString :: ConvertFromAToB Boolean String where
  convert true = "true"
  convert false = "false"

-- Illustrates functional dependency
-- read "type1 -> type2" as "'type1' determines what type 'type2' will be"
class TypeClassWithFunctionalDependency type1 type2 | type1 -> type2  where
  functionName :: type1 -> type2

-- Functional dependency can go both ways:
class BiDirectionFD type1 type2 | type1 -> type2, type2 -> type1 where

-- TODO: understand `purescript-generics-rep` library
-- link: https://pursuit.purescript.org/packages/purescript-generics-rep/6.0.0/docs/Data.Generic.Rep
-- repo: https://github.com/purescript/purescript-generics-rep
