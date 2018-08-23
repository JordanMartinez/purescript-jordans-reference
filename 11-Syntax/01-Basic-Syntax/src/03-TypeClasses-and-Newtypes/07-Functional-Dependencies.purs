module Syntax.Typeclass.MultiParameters.FunctionalDependencies where

{-
This paper (section 2.1.2) quickly explains why we need functional dependencies:
http://homepages.inf.ed.ac.uk/jmorri14/pubs/morris-icfp2010-instances.pdf
In short, it prevents nonsensical code that is otherwise type-safe.

Sometimes in multi-parameter type classes, there is a relationship
between the types. In such cases, we call them 'functional dependencies'.

Syntax:
  Read
    "type1 -> type2"
  as either
    "There is a function from type1 to type2 (e.g function :: type1 -> type2)."
  or
    "'type1' determines what 'type2' will be"
-}
class TypeClassWithFunctionalDependency type1 type2 | type1 -> type2  where
  functionName1 :: type1 -> type2

-- example (not sure whether this works...)

data Box a = Box a

class Unwrap a b where
  unwrap :: a -> b

-- Here, the type of "a" (Box a) determines what "b" will be:
instance unwrapBox :: Unwrap (Box a) a where
  unwrap (Box a) = a

------------------------

-- If multiple types determine what another type is, use this syntax:
class ManyTypesDetermineAnotherType a b c | a b {- n -} -> c  where
  functionName2 :: a b -> c

-- If multiple FDs exist, use this syntax:
class ManyFDRelationships a b c | a {-n -} -> b, b -> c where
  functionName3 :: a -> b -> c
