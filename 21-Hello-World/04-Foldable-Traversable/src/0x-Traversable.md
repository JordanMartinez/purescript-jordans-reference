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

### Outputting each step's accumulated value at that time for a `foldl`/`foldr` computation

The downside of using `foldl`/`foldr` is that you only know the `foldl`/`foldr` computation's final output. You don't know how that output was reached / what each step's accumulated value was.

```purescript
foldl (+) 0 [1, 2, 3, 4,  5 ] ==
            15 -- <= know the output, but don't know how we reached that conclusion
               --    What was the output of `accumulatedValueAtThatPoint + 2`?
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

### Outputting **both** the output **and** each step's accumulated value at that time for a `foldl`/`foldr` computation

The downside of using `scanl`/`scanr` is that we don't have access to **both** the final output of the fold **and** the path it took to get there.

```purescript
foldl (+) 0 [1, 2, 3, 4,  5 ] ==
            15 -- <= know the output, but don't know the path of how we got there

scanl (+) 0 [1, 2, 3, 4,  5 ] ==
            [1, 3, 6, 10, 15] -- <= know the path, but not the output
```

In such cases, you can use
- [`mapAccumL`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Traversable#v:mapAccumL)
- [`mapAccumR`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Traversable#v:mapAccumR)

```purescript
foldl (+) 0 [1, 2, 3, 4,  5 ] ==
            15 -- <= know the output, but don't know the path of how we got there

scanl (+) 0 [1, 2, 3, 4,  5 ] ==
            [1, 3, 6, 10, 15] -- <= know the path, but not the output

type Accum s a = { accum :: s, value :: a }

mapAccumL (\accumulationSoFar nextValue ->
    let outputAtThisStep = accumulationSoFar + nextValue
    in { accum: outputAtThisStep, value: outputAtThisStep}
  ) 0                [1, 2, 3, 4,  5 ] ==
  {accum: 15, value: [1, 3, 6, 10, 15]} -- <= know both output and path
```

You can see how `mapAccumL`/`mapAccumR` enables you to write even complex computations fairly easily. Still, these two functions are more expressive than just a combining the outputs of `foldl` and `scanl` in one computation, since they allow for more types to be used in the computation.

Below is a nonsensical example demonstrating this:
```purescript
import Prelude
import Data.Traversable (mapAccumL)
import Data.Traversable.Accum (Accum)
import Data.Foldable (sum, length)
import Data.Array (snoc)

-- type Accum s a = { accum :: s, value :: a }

nonsensicalExample :: Accum (Array Int) (Array Int)
nonsensicalExample = mapAccumL reducer [] [1, 2, 3, 4, 5]
  where
  reducer :: Array Int -> Int -> Accum (Array Int) Int
  reducer accumulationSoFar nextValue =
    let
      arrayLength = length accumulationSoFar
      arraySum = sum accumulationSoFar -- foldl (+) 0 accumulationSoFar
    in { accum: accumulationSoFar `snoc` arrayLength `snoc` arraySum
       , value: show $ nextValue + arraySum
       }
```
produces `{ accum: [0,0,2,0,4,2,6,8,8,22], value: ["1", "2", "5", "12", "27"] }`
