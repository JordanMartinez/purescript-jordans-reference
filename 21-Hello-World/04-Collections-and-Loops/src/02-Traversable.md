# Traversable

Note: as of `0.15.6`, a type class instance for `Traversable` can be derived by the compiler.

## Usage

[The answer is always traverse](https://twitter.com/blouerat/status/867278331779198976)

While `Foldable` allowed us to use things like `for_`, `traverse_`, and `sequence_`, these three functions restricted computations to only outputting `Unit`. `Traversable` removes that restriction and stores each computation's output in the same `Traversable` type. Moreover, its derived functions enable a few other nice things.

Plain English names:
- BoxSwap (sequence)
- ForEach (traverse)

### Sequence

#### Use Case 1: Swap the box types

I have `Array (Maybe a)`. I need `Maybe (Array a)`. The box-like types, `Array` and `Maybe` need to swap places.

```haskell
sequence [Just 1, Just 2, Nothing] == Nothing -- because the array had at least 1 `Nothing`.
sequence [Just 1, Just 2, Just 8] == Just [1, 2, 8] -- because the array only had `Just`s.
```

#### Use Case 2: run all computations in a `Traversable` type and store their outputs in the same `Traversable` type

This box-swapping property is quite useful as the below example illustrates.

We'll start with sequence first. I could write:
```haskell
main :: Effect Unit
main = do
  let produceInt = randomInt 1 10

  output1 <- produceInt
  output2 <- produceInt
  output3 <- produceInt
  output4 <- produceInt
  -- ...
  log $ "Generated Ints were: " <> show [output1, output2, output3, output4]
```
The above code works. However, if I want to add a fifth one, I need to add another `outputN <- produceInt` line and add the `outputN` to the array.

Instead, I could write
```haskell
main :: Effect Unit
main = do
  outputArray <- sequence
    [ produceInt
    , produceInt
    , produceInt
    , produceInt
    -- ...
    ]
  log $ "Generated Ints were: " <> show outputArray
```

### Traverse: convert each `a` value in the `Traversable` type into a computation, run all computations, and store their outputs in the same `Traversable` type

I could write:
```haskell
main :: Effect Unit
main = do
  let produceInt = \maxBound -> randomInt 1 maxBound

  output1 <- produceInt 8
  output2 <- produceInt 20
  output3 <- produceInt 40
  output4 <- produceInt 90
  -- ...
  log $ "Generated Ints were: " <> show [output1, output2, output3, output4]
```
The same problems as before arise. Instead, I could write
```haskell
main :: Effect Unit
main = do
  let produceInt = \maxBound -> randomInt 1 maxBound
  outputArray <- traverse produceInt [8, 20, 40, 90]
  log $ "Generated Ints were: " <> show outputArray
```

## Definition

```haskell
class (Functor t, Foldable t) <= Traversable t where
  traverse :: forall a b m. Applicative m => (a -> m b) -> t a -> m (t b)
  sequence :: forall a m. Applicative m => t (m a) -> m (t a)
```

See its docs: [Traversable](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Traversable)

## Laws

None, but the members should be compatible in the following ways:
```
traverse f xs = sequence (f <$> xs)
sequence = traverse identity
```

## Derived Functions

### Default implementations for the members of the `Traversable` type class

`traverse` can be implemented using `sequence` and `sequence` can be implemented using `traverse`. Similar to `Foldable`, once one has implemented one of these when writing a `Traversable` instance for a data type, they can use a default implementation to implement the other:
- if `traverse` is implemented, you can implement `sequence` by using [`sequenceDefault`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Traversable#v:sequenceDefault)
- if `sequence` is implemented, you can implement `traverse` by using [`traverseDefault`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Traversable#v:traverseDefault)

### `for` is `traverse` with its arguments flipped

- [`for`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Traversable#v:for)

Using the same `traverse` example as above:
```haskell
main :: Effect Unit
main = do
  outputArray <- for [8, 20, 40, 90] \maxBound -> randomInt 1 maxBound
  log $ "Generated Ints were: " <> show outputArray
```

### Outputting each step's accumulated value at that time for a `foldl`/`foldr` computation

The downside of using `foldl`/`foldr` is that you only know the `foldl`/`foldr` computation's final output. You don't know how that output was reached / what each step's accumulated value was.

```haskell
foldl (+) 0 [1, 2, 3, 4,  5 ] ==
            15 -- <= know the output, but don't know how we reached that conclusion
               --    What was the output of `accumulatedValueAtThatPoint + 2`?
```

In such cases, you use
- [`scanl`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Traversable#v:scanl)
- [`scanr`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Traversable#v:scanr)

```haskell
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

```haskell
foldl (+) 0 [1, 2, 3, 4,  5 ] ==
            15 -- <= know the output, but don't know the path of how we got there

scanl (+) 0 [1, 2, 3, 4,  5 ] ==
            [1, 3, 6, 10, 15] -- <= know the path, but not the output
```

In such cases, you can use
- [`mapAccumL`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Traversable#v:mapAccumL)
- [`mapAccumR`](https://pursuit.purescript.org/packages/purescript-foldable-traversable/docs/Data.Traversable#v:mapAccumR)

```haskell
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
```haskell
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
