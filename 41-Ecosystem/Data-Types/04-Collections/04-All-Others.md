# All Others

## Finger Tree

```haskell
data FingerTree measurement a = -- implementation
-- measurement can be many things, such as length or size
```

| Package | Type name | "Plain English" name |
| - | - | - |
| [purescript-sequences](https://pursuit.purescript.org/packages/purescript-sequences/1.0.3/docs/Data.FingerTree) | `FingerTree v a` | General-purpose FP collections data structure<br>(can be used to implement all other collections data structures)

### Bitmapped Vector Trie

(Start at 26:35): [Extreme Cleverness: Functional Data Structures in Scala](https://www.youtube.com/watch?v=pNhBQJN44YQ)

In the above video, the guy argues that FingerTrees are in principle really efficient but, depending on the runtime, can be less efficient than regular Arrays. I think Javascript might fit this situation due to the [PureScript's FingerTree implementation's own admission](https://pursuit.purescript.org/packages/purescript-sequences/1.0.3).

## Seq

- [Seq](https://pursuit.purescript.org/packages/purescript-sequences/1.0.3/docs/Data.Sequence)
- [NonEmptySeq](https://pursuit.purescript.org/packages/purescript-sequences/1.0.3/docs/Data.Sequence.NonEmpty)
- [OrderedSeq](https://pursuit.purescript.org/packages/purescript-sequences/1.0.3/docs/Data.Sequence.Ordered)

## Graphs

https://pursuit.purescript.org/packages/purescript-graphs/4.0.0/docs/Data.Graph

## Queues

https://pursuit.purescript.org/packages/purescript-catenable-lists/5.0.0

## Outdated

### Heap (outdated)

https://pursuit.purescript.org/packages/purescript-heap/0.1.0

### Priority Queue (outdated)

https://pursuit.purescript.org/packages/purescript-pqueue/1.0.0

### Rose or Multi-Way Tree (outdated)

https://pursuit.purescript.org/packages/purescript-tree/1.3.2/docs/Data.Tree

### Trie (outdated)

https://pursuit.purescript.org/packages/purescript-trie/0.0.2
