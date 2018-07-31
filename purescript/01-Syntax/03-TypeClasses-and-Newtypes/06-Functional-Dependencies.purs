-- Sometimes in multi-parameter type classes, there is a relationship
-- between the types. In such cases, we call them 'functional dependencies'.

-- Syntax:
-- Read "type1 -> type2" as
--   'There is a function from type1 to type2 (e.g function :: type1 -> type2).'
-- or "'type1' determines what 'type2' will be"
class TypeClassWithFunctionalDependency type1 type2 | type1 -> type2  where
  functionName :: type1 -> type2

-- example (not sure whether this works...)

data Box a = Box a

class Unwrap a b where
  unwrap :: a -> b

-- Here, the type of "a" (Box a) determines what "b" will be:
instance unwrapBox :: Unwrap (Box a) a where
  unwrap (Box a) = a

-- TODO: Document 'type1 type2 -> type3' Functional dependency syntax
-- class TC type1 type2 type3 | type1 type2 -> type3 where
-- Functional dependency can go both ways:
class BiDirectionFD type1 type2 | type1 -> type2, type2 -> type1 where

-- TODO: understand `purescript-generics-rep` library
-- link: https://pursuit.purescript.org/packages/purescript-generics-rep/6.0.0/docs/Data.Generic.Rep
-- repo: https://github.com/purescript/purescript-generics-rep
