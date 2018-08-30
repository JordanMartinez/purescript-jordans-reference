# Explaining Kinds

This code...
```purescript
function :: Int -> String
function x = "an integer value!"
```
... translates to, "I cannot give you a concrete value (String) until you give me an Int value"

Similarly, this code...
```purescript
data Box a = Box a
```
... translates to, "I cannot give you a concrete type (e.g. `Box Int`, a box that stores an `Int` value (rather than a `String` value or some other value)) until you tell me what `a` is."

## What are Kinds?

> Kinds = "How many more types do I need defined before I have a 'concrete' type?"^^

^^ This is a "working definition." There's more to it than that when one considers type-level programming, but for now, this will suffice."

| # of types that still need to be defined | Special Name | Their "Kind" signature (Purescript)^^ | Their "Kind" signature (Haskell)^^
| - | - | -: | -: |
| 0 | Concrete Type             | `                Type` | `          *`
| 1 | Higher-Kinded Type (by 1) | `        Type -> Type` | `     * -> *`
| 2 | Higher-Kinded Type (by 2) | `Type -> Type -> Type` | `* -> * -> *`
| n | Higher-Kinded Type (by n) | `... Type ... -> Type` | `... * ... -> *`

^^ These columns are right-aligned to show that the last `Type`/`*` is the "concrete" type. Also, the `... Type ... -> Type` (and its Haskell equivalent) syntax is not real syntax but merely conveys the recursive idea in an n-kinded type. The other three (0 - 2) are real syntax.

## Concrete Types

Concrete types can usually be written with literal values:
```purescript
(1 :: Int)
("a literal string" :: String)

([1, 2, 3] :: Array Int)
-- Although Array is box-like, we know the values it stores
-- Thus, is still has a concrete type
```

## Higher-Kinded Types

Higher-kinded types are those that still need one or more types to be defined.
```purescript
-- Kind: Type -> Type
-- Reason: the `a` type needs to be defined
data Box a = Box a

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
```purescript
-- A box that holds two values of same or different types!
data BoxOfTwo a b = BoxOfTwo a b

-- The below syntax is not valid because it is missing `forall a b.`,
--   but it gets the idea across. "Forall" syntax will be covered later.
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
Generic types can also be split across the instances:
```purescript
-- It's either an A or it's a B, but not both!
data Either a b
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
`Either` (where the `a` and `b` are not yet specified) has kind `Type -> Type -> Type` because it cannot become a concrete type until both `a` and `b` types are defined, even if only constructing one of its instances whose generic type is known.
