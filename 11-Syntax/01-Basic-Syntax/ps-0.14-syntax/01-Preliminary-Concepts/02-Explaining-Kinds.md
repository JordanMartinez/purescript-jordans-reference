# Explaining Kinds

This code...
```haskell
function :: Int -> String
function x = "an integer value!"
```
... translates to, "I cannot give you a concrete value (i.e. `String`) until you give me an `Int` value."

Similarly, this code...
```haskell
data Box a = Box a
```
... translates to, "I cannot give you a concrete type (e.g. `Box Int`, a box that stores an `Int` value (rather than a `String` value or some other value)) until you tell me what `a` is."

Let's rewrite the above `Box` type. Things on the left of the `=` indicate type information. Things on the right of the `=` indicate value information.
```haskell
{-
| Type information | Value information |                                     -}
data BoxType a     = BoxValue a
```

The above code now says, "I cannot give you a concrete type (e.g. `BoxType Int`) until you tell me what `a` is." Let's assume that `a` is `Int`. We would say that `BoxValue 4` is a value whose type is `BoxType Int`.

## What are Kinds and Kind Signatures?

> Kinds = "How many more types do I need defined before I have a 'concrete' type?"^^

^^ This is a "working definition." There's more to it than that when one considers type-level programming, but for now, this will suffice."

We saw earlier that we annotate functions with type signatures via `->`:
```haskell
--              ||
--              \/
function :: Int -> String
function x = "an integer value!"
```

The `->` indicates that the thing to the right (i.e. `String`) cannot be produced until it is given the thing to the left of it (i.e. `Int`).

Type signatures annotate value-level entities like values (i.e. `4` or `BoxValue`) and functions.
Kind signatures annotate type-level entities like `BoxType`. They are basically type signatures for types, not values.

| # of types that still need to be defined | Special Name | Their "kind signature" (Purescript)^^ | Their "kind signature" (Haskell)^^
| - | - | -: | -: |
| 0 | Concrete Type             | `                Type` | `          *`
| 1 | Higher-Kinded Type (by 1) | `        Type -> Type` | `     * -> *`
| 2 | Higher-Kinded Type (by 2) | `Type -> Type -> Type` | `* -> * -> *`
| n | Higher-Kinded Type (by n) | `... Type ... -> Type` | `... * ... -> *`

^^ These columns are right-aligned to show that the right-most `Type`/`*` is the "concrete" type. Also, the `... Type ... -> Type` (and its Haskell equivalent) syntax is not real syntax but merely conveys the recursive idea in an n-kinded type. The other three (0 - 2) are real syntax.

## Concrete Types

Concrete types can usually be written with literal values:
```haskell
integerValue :: Int
integerValue = 1

(1 :: Int) -- this is notation for saying that `1` is a value of type, `Int`.

stringValue :: String
stringValue = "a literal string"

("a literal string" :: String)

data BoxType a = BoxValue a

boxWithOneIntValue :: BoxType Int
boxWithOneIntValue = BoxValue 4

((BoxValue 4) :: BoxType Int)

arrayOfIntsValue :: Array Int
arrayOfIntsValue = [1, 2, 3]

([1, 2, 3] :: Array Int)
```

## Higher-Kinded Types

Higher-kinded types are those that still need one or more types to be defined.
```haskell
-- Kind Signature: Type -> Type
-- Reason: the `a` type needs to be defined
data Box a = Box a

-- This is the same definition as above.
-- However, the kind signature of the above `Box` definition is implicit.
-- The below definition has an explicit kind signature.
data BoxType :: Type -> Type
data BoxType a = BoxValue a

-- As we can see, there can be many different concrete 'Box' types
-- depending on what 'a' is:
boxedInt :: Box Int
boxedInt = Box 4

boxedString :: Box String
boxedString = Box "string"

boxedBoxedInt :: Box (Box Int)
boxedBoxedInt = Box boxedInt
```
We can make the type's kind higher by adding more types that need to be specified. For example:
```haskell
-- A box that holds two values of same or different types!
-- Kind Signature: `Type -> Type -> Type`
data BoxOfTwo a b = BoxOfTwo a b

data BoxOfTwo_ExplicitKindSignature :: Type -> Type -> Type
data BoxOfTwo_ExplicitKindSignature a b = BoxOfTwoValue a b

-- The below syntax is not valid because it is missing `forall a b.`,
--   but it gets the idea across. The "forall" syntax will be covered later.
higherKindedBy2 :: a -> b -> BoxOfTwo a b
higherKindedBy2 a b = BoxOfTwo a b

-- We can lower the kind by specifying one of the data types:
higherKindedBy1L :: b -> BoxOfTwo Int b
higherKindedBy1L b = BoxOfTwo 3 b

higherKindedBy1R :: a -> BoxOfTwo a String
higherKindedBy1R a = BoxOfTwo a "a string value"

concreteType :: BoxOfTwo Int String
concreteType = BoxOfTwo 3 "a string value"
```
Generic types can also be split across the values of a type:
```haskell
-- It's either an A or it's a B, but not both!
-- Kind signature is implicit: `Type -> Type -> Type`
data Either a b
  = Left a
  | Right b

data Either_ExplicitKindSignature :: Type -> Type -> Type
data Either_ExplicitKindSignature a b
  = Left a
  | Right b

higherKindedBy2L :: a -> b -> Either a b
higherKindedBy2L a b = Left a

higherKindedBy2R :: a -> b -> Either a b
higherKindedBy2R a b = Right b

higherKindedBy1L_ignoreB :: b -> Either Int b
higherKindedBy1L_ignoreB b = Left 3

higherKindedBy1L_useB :: b -> Either Int b
higherKindedBy1L_useB b = Right b

higherKindedBy1L_ignoreBoth :: a -> b -> Either Int b
higherKindedBy1L_ignoreBoth a b = Left 3
```

`Either` (where the `a` and `b` are not yet specified) has kind `Type -> Type -> Type` because it cannot become a concrete type until both `a` and `b` types are defined, even if only constructing one of its values whose generic type is known.

In other words
```haskell
allSpecified :: Either Int String
allSpecified = Right "foo"

{-
(value)                                                                       -}
(Right "foo")                                                                 {-

(value       :: Type             )                                            -}
(Right "foo" :: Either Int String)                                            {-

((value       :: Type             ) :: Kind)                                  -}
((Right "foo" :: Either Int String) :: Type)                                  {-

((value       :: Type           ) :: Kind        )                            -}
((Right "foo" :: Either a String) :: Type -> Type)
```

## Table of Inferred Types

|  | Inferred kind |
|-|-:|
|`Unit`|`Type`|
|`Array Boolean`|`Type`|
|`Array`|`Type -> Type`|
|`Either Int String` | `Type`|
|`Either Int b` | `Type -> Type`|
|`Either a String` | `Type -> Type`|
|`Either` | `Type -> Type -> Type`|
|...|...|
