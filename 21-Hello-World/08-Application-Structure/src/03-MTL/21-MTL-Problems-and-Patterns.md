# MTL Problems and Patterns

## Problems

Now that we have a better understanding of how the MTL approach works, it's time to talk about some of its flaws. Note: some of these flaws may be specific only to Haskell and not Purescript. I need to ask people who know about this more than I do.

Note: in the below sources, any mention of Haskell's `IORef` is equivalent to Purescript's `Ref`: a global mutable variable.

### `MonadState` Allows Only One State Manipulation Type

First, due to the functional dependency from `m` to `s` in `MonadState`'s definition, it's impossible to do two different state manipulations within the same function. For example...
```purescript
f :: forall m ouput.
  => MonadState Int m
  => MonadState String m
  -> m output
f = do
  whichValue <- get
```

The compiler will complain because it doesn't know which value it should 'get'. See the answer to [Haskell -- Chaining two states using StateT monad transformer](https://stackoverflow.com/a/49782427)

One solution to this is to store all states in one larger state type and then use a Lens to access/change it:
```purescript
type IntAndString = { i :: Int, s :: String }
f :: forall m output.
  => MonadState IntAndString m
  -> m output
```

The second solution is to use type-level programming to specify which `MonadState` we are referring to via an `id` Symbol. This would force us to change `MonadState`'s definition to:
```purescript
class (Monad m) <= MonadState (id :: Symbol) state m | m -> state
  state :: forall a. SProxy id -> (s -> m (Tuple a s)) -> m a

_i :: SProxy "i"
_i = SProxy

_s :: SProxy "s"
_s = SProxy

f :: forall m ouput.
  => MonadState "i" Int m
  => MonadState "s" String m
  -> m output
f = do
  theInt <- get _i
  theString <- get _s
```

However, I'm not sure what are the pros/cons of this approach.

### `MonadState` & `MonadWriter` lose their state on a runtime error

If a runtime error occurs in a computation that uses `MonadState` or `MonadWriter`, then the states in both `MonadState` and `MonadWriter` are lost (because the computation halts).

### `WriterT` & `RWST` has a "space leak" problem

This is largely due to `WriterT`'s usage of `Monoid`. The 'fix' is to drop some of its features and use a `StateT` instead. See [Writer Monads and Space Leaks - Infinite Negative Utility](https://blog.infinitenegativeutility.com/2016/7/writer-monads-and-space-leaks)

Since `RWST` also encodes things via `WriterT`, it also suffers from this problem.

### N-squared-ish Monad Transformer Instances

Whenever one wants to define a new monad transformer (e.g. `MonadAuthenticate`) to encode some effect, one must define ~`n^2` instances:
- 1 `MonadAuthenticate` instance for each `[Word]T` type via `MonadTrans` to lift the monadic newtyped `AuthenticateT` function.
- n instances for the monadic newtyped `AuthenticateT` function, so that it can lift its computation into all the other monad transformer type classes (e.g. `AuthenticateT` -> `MonadState`, `MonadWriter`, etc.)

Why? So that the order of the monad stack does not matter:
```purescript
-- this function's type signature defines
-- the order of the `runX` functions
-- Thus, the MonadState must be lifted into MonadReader
doX :: StateT Int (ReaderT String Identity a)
doX = runReader initialString (runStateT initialState function)
```
If the order was swapped, then the `MonadReader` must be lifted into `MonadState`. This swappability requires both `StateT` and `ReaderT` to have instances for `MonadState` and `MonadReader`. Otherwise, one faces compiler errors.

Note: I say roughly **~**`n^2` because apparently there are some cases where "lifting" a function would break a law (or something).

### Monad transformer stacks' type signatures get complicated quickly

Related to the previous point, but the type signatures start getting crazy very quickly. For new beginners who are just learning about monad transformers, this can be quite offsetting:
```purescript
-- as an example using pseudo-syntax...
f :: StateT State (ReaderT reader (WriterT writer (ExceptT error Effect output) output))
```

## The `ReaderT` and `Capability` Design Patterns

The above points (though not all of them) are what led to [the `ReaderT` Design Pattern](https://www.fpcomplete.com/blog/2017/06/readert-design-pattern) from which I originally got many of the above problems.

This design pattern was interpreted by others in a different way, so that it led to [the Capability Design Pattern](https://www.tweag.io/posts/2018-10-04-capability.html) post.

The main point of the `Capability Design Pattern` is that the `Monad[Word]` type classes state what effects will be used in some function, not necessarily how that will be accomplished. This key insight is what enables us to write code that looks like the Onion Architecture.
