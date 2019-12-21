# Traversable

## Usage

[The answer is always traverse](https://twitter.com/blouerat/status/867278331779198976)

While `Foldable` allowed us to use things like `for_`, `traverse_`, and `sequence_`, these three functions restricted computations to only outputting `Unit`. `Traversable` removes that restriction. Moreover, it enables a few other nice things.

Plain English names:
- ForEach (traverse)
- BoxSwap (sequence)

## Definition

```purescript
class (Functor t, Foldable t) <= Traversable t where
  traverse :: forall a b m. Applicative m => (a -> m b) -> t a -> m (t b)
  sequence :: forall a m. Applicative m => t (m a) -> m (t a)
```

See its docs: [Traversable](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Traversable)

## Laws

TODO

## Derived Functions

### Default implementations for the members of the `Traversable` type class

`traverse` can be implemented using `sequence` and `sequence` can be implemented using `traverse`. Similar to `Foldable`, once one has implemented one of these when writing a `Traversable` instance for a data type, they can use a default implementation to implement the other:
- if `traverse` is implemented, you can implement `sequence` by using [`sequenceDefault`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Traversable#v:sequenceDefault)
- if `sequence` is implemented, you can implement `traverse` by using [`traverseDefault`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Traversable#v:traverseDefault)

### `for` is `traverse` with its arguments flipped

- [`for`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Traversable#v:for)

### Step-by-step debugger for a `foldl`/`foldr` output

The downside of using `foldl`/`foldr` is that you only know the computation's final output, not how that output is reached. In some situations, you may want to know what was the output of each iteration. Or, perhaps you want to know what the second-to-last value of the output was.

```purescript
foldl (+) 0 [1, 2, 3, 4,  5 ] ==
            15 -- <= know the output, but don't know how we reached that conclusion
```

In such cases, you use
- [`scanl`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Traversable#v:scanl)
- [`scanr`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Traversable#v:scanr)

```purescript
foldl (+) 0 [1, 2, 3, 4,  5 ] ==
            15 -- <= know the output, but don't know how we reached that conclusion

scanl (+) 0 [1, 2, 3, 4,  5 ] ==
            [1, 3, 6, 10, 15] -- <= now we can see how that conclusion was reached
                              --    if traversing from the left

scanr (+) 0 [1,  2,  3,  4, 5] ==
            [15, 14, 12, 9, 5] -- <= now we can see how that conclusion was reached
                               --    if traversing from the right
```

In other words, the value at index `n` in the outtputted array is the output of passing the value at index `n` in the input array and the accumulated value at that point in time into the folding function (i.e. `+`). Using the `scanr` example, the input array's index 2 value (i.e. `3`) and the accumulated value at that time (the output array's index 3 value, `9`) were both passed into the folding function, `+`, to produce the output array's index 2 value (i.e. `12`).
