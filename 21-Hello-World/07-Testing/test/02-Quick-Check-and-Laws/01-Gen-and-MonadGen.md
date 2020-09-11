# `Gen` and `MonadGen`

## How QuickCheck Generates Random Data

So, how does QuickCheck generate random data? Essentially, it uses a linear congruential generator to produce random numbers. Values can be created based on that number. Let's give some examples.

Let's say the randomly generated number is `x` where `x` is a `Number`:
- Primitives:
    - Boolean: if `0 < x` and `x < 0.5`, we might produce a `true` value and `false` otherwise.
    - Int: we can convert `x` to an `Int` via `ceil`
    - Char: we can map `x` to an `Int` and then produce a corresponding Unicode value via `toCharCode`.
    - String: by generating numerous `Char` values, we can combine them together into a `String` value.
- Containers:
    - Maybe: given a `Gen a`, we can generate `Nothing` if `0 < x && x < 0.5` and `Just a` otherwise.
    - Either: given a `Gen a` and a `Gen b`, we can generate `Left a` if `0 < x && x < 0.5` and `Right b` otherwise.
    - List: given a `Gen a` and an `Int` indicating the number of values to generate, we can use the first generator to produce an `a` value and cons that onto `Nil` or the rest of the list.
    - Array: we can generate a `List a` and then use `fromUnfoldable`

## The `Gen` Monad and its `MonadGen` Type Class

In [`purescript-gen`](https://pursuit.purescript.org/packages/purescript-gen/), [MonadGen](https://pursuit.purescript.org/packages/purescript-gen/docs/Control.Monad.Gen.Class) is the type class that has a default implementation via [Gen](https://pursuit.purescript.org/packages/purescript-quickcheck/docs/Test.QuickCheck.Gen#t:Gen). To see all of the definitions of the types used in `Gen`, look below:
```haskell
-- This Int will always be between 1 and 2147483647,
-- which is (2^31 - 1), a Mersenne prime.
-- It is used in a linear congruential generator.
newtype Seed = Seed Int -- This will always be a positive integer
type Size = Int
type GenState = { newSeed :: Seed, size :: Size }

newtype Gen a = State GenState a
```

QuickCheck uses the `Gen` monad (i.e. generator monad) to generate random data. `QuickCheck.Gen` exports most of the package's functions (i.e. the "combinators" as they are called), not but all of them.
- [Generators for `Int`, `Boolean`, and `Number`](https://pursuit.purescript.org/packages/purescript-gen/docs/Control.Monad.Gen).
- [Generators for common FP container types](https://pursuit.purescript.org/packages/purescript-gen/docs/Control.Monad.Gen.Common), such as `Maybe`, `Either`, `Tuple`, etc.

Furthermore, some data types combinators exist in other libraries. For example:
- [Generators for `Char`](https://pursuit.purescript.org/packages/purescript-strings/docs/Data.Char.Gen)
- [Generators for `String`](https://pursuit.purescript.org/packages/purescript-strings/docs/Data.String.Gen)

## The Importance of the `Seed` Value

The `Seed` value is used to produce the random data. If you run a propety test and it fails, the failure message will also include the seed used to produce that data. Once you update your code to fix the bug, how would you know whether it fixed that particular instance? You would run the test and specify that it should use that specific seed.

As an example, this repository includes some example programs in the `Projects` folder. One of my property tests failed, so I saved the seeds here: https://github.com/JordanMartinez/purescript-jordans-reference/issues/351.

I can use those seeds to help troubleshoot why these problems occurred and ensure that the bug has indeed been fixed.
