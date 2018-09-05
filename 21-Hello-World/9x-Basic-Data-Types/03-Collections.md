# Collections

Data types that store one or more instances of a given type.

## Array

```purescript
[]  -- empty array
[1] -- array with content
```

| Package | Type name | "Plain English" name |
| - | - | - | - | - |
| [purescript-arrays](https://pursuit.purescript.org/packages/purescript-arrays/5.0.0/docs/Data.Array) | `Array a` | Immutable strict array

| Usage | Instances & their Usage
| - | -
| Recursive-resistant, great-performant list type | --
| A "type class wrapper type" | Easily implement instances for some type classes by wrapping a type in `Array` |

## List (Strict)

```purescript
-- Data.List.Types

data List a
  = Nil
  | Cons a (List a)

infixr 6 Cons as :

-- example
1 : 2 : Nil -- Cons 1 (Cons 2 Nil) -- [1, 2]
```

| Package | Type name | "Plain English" name |
| - | - | - | - | - |
| [purescript-list](https://pursuit.purescript.org/packages/purescript-lists/5.0.0) | `List a` | Immutable strict singly-linked list

| Usage | Instances & their Usage
| - | -
| Recursive-friendly, not-best-performant list type | <ul><li>`Nil` - Indicates the end of a List in pattern matching</li><li>`Cons a (List a)` - stores one value of the list (head) and the tail, either the rest of the list (another `Cons`) or the end of the list (`Nil`).</li></ul>
| A "type class wrapper type" | Easily implement instances for some type classes by wrapping a type in `List` |

## List (Lazy)

```purescript
-- Data.List.Lazy.Types

newtype List a = -- implementation

nil :: forall a. List a
-- implementation

cons :: forall a. a -> List a -> List a
-- implementation

infixr 6 cons as :

-- example
1 : 2 : Nil -- cons 1 (cons 2 nil) -- [1, 2]
```

| Package | Type name | "Plain English" name |
| - | - | - | - | - |
| [purescript-list](https://pursuit.purescript.org/packages/purescript-lists/5.3.0/docs/Data.List.Lazy.Types#t:List) | `List a` | Immutable lazy singly-linked list

| Usage | Instances & their Usage
| - | -
| Recursive-friendly, not-best-performant list type | <ul><li>`Nil` - Indicates the end of a List in pattern matching</li><li>`Cons a (List a)` - stores one value of the list (head) and the tail, either the rest of the list (another `Cons`) or the end of the list (`Nil`).</li></ul>
| A "type class wrapper type" | Easily implement instances for some type classes by wrapping a type in `List` |

## NonEmpty

To guarantee that a box-like type cannot be empty, we wrap it with a type.

```purescript
data NonEmpty box a = NonEmpty a (box a)
infixr 5 NonEmpty as :|

-- example
"first" :| ["second", "third"]        -- NonEmpty Array String
"first" :| ("second" : "third" : Nil) -- NonEmpty List  String
```

| Package | Type name | "Plain English" name |
| - | - | - | - | - |
| [purescript-nonempty](https://pursuit.purescript.org/packages/purescript-nonempty/5.0.0/docs/Data.NonEmpty) | `NonEmpty box a` | Wrapper type that guarantees that at least one instance of `a` exists

## Map

```purescript
data Map key value = -- implementation
```

| Package | Type name | "Plain English" name |
| - | - | - | - | - |
| [purescript-ordered-collections](https://pursuit.purescript.org/packages/purescript-ordered-collections/1.0.0/docs/Data.Map.Internal) | `Map k v` | Balanced 2-3 Tree map

https://pursuit.purescript.org/packages/purescript-ordered-collections/1.0.0/docs/Data.Set

## Set

```purescript
newtype Set a = -- implementation
```

| Package | Type name | "Plain English" name |
| - | - | - | - | - |
| [purescript-ordered-collections](https://pursuit.purescript.org/packages/purescript-ordered-collections/1.0.0/docs/Data.Set) | `Set a` | Balanced 2-3 Tree Set

## Finger Tree

```purescript
data FingerTree measurement a = -- implementation
-- measurement can be many things, such as length or size
```

| Package | Type name | "Plain English" name |
| - | - | - | - | - |
| [purescript-sequences](https://pursuit.purescript.org/packages/purescript-sequences/1.0.3/docs/Data.FingerTree) | `FingerTree v a` | General-purpose FP collections data structure<br>(can be used to implement all other collections data structures)

## Seq

- [Seq](https://pursuit.purescript.org/packages/purescript-sequences/1.0.3/docs/Data.Sequence)
- [NonEmptySeq](https://pursuit.purescript.org/packages/purescript-sequences/1.0.3/docs/Data.Sequence.NonEmpty)
- [OrderedSeq](https://pursuit.purescript.org/packages/purescript-sequences/1.0.3/docs/Data.Sequence.Ordered)
