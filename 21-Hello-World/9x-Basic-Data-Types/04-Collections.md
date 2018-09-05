# Collections

Data types that store one or more instances of a given type.

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
