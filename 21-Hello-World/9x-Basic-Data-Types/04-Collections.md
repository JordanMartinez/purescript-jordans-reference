# Collections

Data types that store one or more instances of a given type.

## Array (Mutable)

https://pursuit.purescript.org/packages/purescript-arrays/5.0.0/docs/Data.Array.ST

## Array (Immutable)

```purescript
[]  -- empty array
[1] -- array with content
```

| Package | Type name | "Plain English" name |
| - | - | - | - | - |
| [purescript-arrays](https://pursuit.purescript.org/packages/purescript-arrays/5.0.0/docs/Data.Array)<br>(Utils library) | `Array a` | Immutable strict size-NOT-known-at-compile-time array

| Usage | Instances & their Usage
| - | -
| Recursive-resistant, great-performant list type | --
| A "type class wrapper type" | Easily implement instances for some type classes by wrapping a type in `Array` |

## Vec

```purescript
newtype Vec s a = -- implementation

empty :: -- TypeLevel Programming

cons :: -- TypeLevel Programming

infixr 5 cons as +>

1 +> 2 +> empty -- [1, 2]
```

| Package | Type name | "Plain English" name |
| - | - | - |
| [purescript-sized-vectors](https://pursuit.purescript.org/packages/purescript-sized-vectors/3.1.0/docs/Data.Vec) | `Vec s a` | Immutable strict size-known-at-compile-time array

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

## List (Known Size)

https://pursuit.purescript.org/packages/purescript-safelist/2.0.0/docs/Data.List.Safe

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

## Map (Ord-based)

```purescript
data Map key value = -- implementation
```

| Package | Type name | "Plain English" name |
| - | - | - | - | - |
| [purescript-ordered-collections](https://pursuit.purescript.org/packages/purescript-ordered-collections/1.0.0/docs/Data.Map.Internal) | `Map k v` | Balanced 2-3 Tree map

https://pursuit.purescript.org/packages/purescript-ordered-collections/1.0.0/docs/Data.Set

## Map (Hash-based)

https://pursuit.purescript.org/packages/purescript-unordered-collections/1.3.0

## Vault (Key-Type-based; outdated)

https://pursuit.purescript.org/packages/purescript-vault/0.1.0

A map-like structure that uses differently-typed keys to get their corresponding value (same type as the key)

## Set (Ord-based)

```purescript
newtype Set a = -- implementation
```

| Package | Type name | "Plain English" name |
| - | - | - | - | - |
| [purescript-ordered-collections](https://pursuit.purescript.org/packages/purescript-ordered-collections/1.0.0/docs/Data.Set) | `Set a` | Balanced 2-3 Tree Set

## Set (Hash-based)

https://pursuit.purescript.org/packages/purescript-unordered-collections/1.3.0/docs/Data.HashSet

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

## Heap (outdated)

https://pursuit.purescript.org/packages/purescript-heap/0.1.0

## Queues

https://pursuit.purescript.org/packages/purescript-catenable-lists/5.0.0

## Priority Queue (outdated)

https://pursuit.purescript.org/packages/purescript-pqueue/1.0.0

## Rose or Multi-Way Tree (outdated)

https://pursuit.purescript.org/packages/purescript-tree/1.3.2/docs/Data.Tree

## Trie (outdated)

https://pursuit.purescript.org/packages/purescript-trie/0.0.2

# Graphs

https://pursuit.purescript.org/packages/purescript-graphs/4.0.0/docs/Data.Graph
