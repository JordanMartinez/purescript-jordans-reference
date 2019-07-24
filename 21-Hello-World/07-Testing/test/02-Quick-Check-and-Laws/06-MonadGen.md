# MonadGen

In [`purescript-gen`](https://pursuit.purescript.org/packages/purescript-gen/), [MonadGen](https://pursuit.purescript.org/packages/purescript-gen/docs/Control.Monad.Gen.Class) is the type class that is implemented by [Gen](https://pursuit.purescript.org/packages/purescript-quickcheck/docs/Test.QuickCheck.Gen#t:Gen)

```purescript
-- This Int will always be between 1 and 2147483647,
-- which is (2^31 - 1), a Mersenne prime.
-- It is used in a linear congruential generator.
newtype Seed = Seed Int -- This will always be a positive integer
type Size = Int
type GenState = { newSeed :: Seed, size :: Size }

newtype Gen a = State GenState a
```

`QuickCheck.Gen` exports most of the package's functions, not but all of them.
- See additional ones [here](https://pursuit.purescript.org/packages/purescript-gen/docs/Control.Monad.Gen).
- See [generators for common FP container types](https://pursuit.purescript.org/packages/purescript-gen/docs/Control.Monad.Gen.Common), such as `Maybe`, `Either`, `Tuple`, etc.
