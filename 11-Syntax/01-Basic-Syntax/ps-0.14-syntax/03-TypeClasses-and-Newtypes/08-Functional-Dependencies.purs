module Syntax.Basic.Typeclass.MultiParameters.FunctionalDependencies where

{-
Sometimes in multi-parameter type classes, there is a relationship
between the types. In such cases, we call them 'functional dependencies' (FDs).

The next block summarizes these links:
- https://stackoverflow.com/questions/20040224/functional-dependencies-in-haskell/20040427#20040427
- https://stackoverflow.com/questions/20040224/functional-dependencies-in-haskell/20040343#20040343
- Section 2.1.2 shows an example where it needs FDs to work correctly
    https://jgbm.github.io/pubs/morris-icfp2010-instances.pdf

Syntax:
  Read
    class SomeClass type1 type2 | type1 -> type2
  as
    "Once you tell the type inferencer what the types on the left-hand side
    of the arrow are (e.g. `type1`), then the type inferencer will stop
    trying to infer what the types on the right-hand side of the arrow are
    (e.g. `type2`).

    Rather, the compiler will look for an instance where
    the left-hand side types are defined and use that instance
    to determine what the right-hand side types are. If the compiler finds
    multiple instances where the left-hand side types are the same types
    between instances but the right-hand side types are different,
    it will throw a compiler error.
-}
class TypeClassWithFunctionalDependency type1 type2 | type1 -> type2  where
  functionName1 :: type1 -> type2

-- Example

data Box a = Box a

class Unwrap a b where
  unwrap :: a -> b

-- Here, the type of "a" (i.e. Box String) determines what "b" will be:
instance unwrapBox :: Unwrap (Box String) String where
  unwrap (Box s) = s

{-
If we defined another instance of `Unwrap` where
"a" is the same type (e.g. `Box String`) but `b` is different,
the compiler will throw an error:

instance unwrapBox2 :: Unwrap (Box String) Int where
  unwrap (Box s) = length s                                                 -}

------------------------

-- If multiple types determine what another type is, use this syntax:
class ManyTypesDetermineAnotherType a b c | a b {- n -} -> c  where
  functionName2 :: a -> b -> c

class OneTypeDeterminesManyTypes a b c | a -> b c where
  functionName3 :: a -> b -> c

-- We can also add an explicit kind signature here:
class OneInfersMany_ExplicitKindSignature :: Type -> Type -> Type -> Constraint
class OneInfersMany_ExplicitKindSignature a b c | a -> b c where
  functionName4 :: a -> b -> c

------------------------

{-
In some situations, there might be multiple ways to determine
a type. In such cases, we can use multiple FDs to tell the compiler
how to infer a given type in the type class.

The following two FDs can be read as,
  "Make the type checker try to find an instance of ManyFDRelationships where
  the `a` type and `b` type are known and then use
  the instance to infer what the `c` type is.

  However, if the type checker can't ultimately find such an instance,
  then try to find an instance where the `c` type is known and
  use that instance to infer what the `a` type and `b` type are."
-}
class ManyFDRelationships a b c | a b -> c, c -> a b where
  functionName5 :: a -> b -> c

-- Same thing but with a kind signature.
class ManyFDRelationships_KindSignature :: Type -> Type -> Type -> Constraint
class ManyFDRelationships_KindSignature a b c | a b -> c, c -> a b where
  functionName6 :: a -> b -> c

{-
In short, the type checker will use the FDs to determine how it should "unify"
the types together. If one FD fails, it'll go to the next one. If all of them
fail, it'll assume that there is no such type class instance.
-}

{-
In Haskell literature, functional dependencies can also be written as
"Type Families." To see how one can write the same concept in both
styles, see the below link:
https://wiki.haskell.org/GHC/Type_families#The_class_declaration_2

For advantages/disadvantages of both approaches, see these links:
https://wiki.haskell.org/Functional_dependencies_vs._type_families
https://ghc.haskell.org/trac/ghc/wiki/TFvsFD
-}
