# Drawbacks of MTL

The following lists some of the issues one will face when using MTL.

Note:
- Some of the below flaws may be specific only to Haskell and not Purescript.
- In the below sources, any mention of Haskell's `IORef` is equivalent to Purescript's `Ref`: a global mutable variable.

## `MonadState` Allows Only One State Manipulation Type

First, due to the functional dependency from `m` to `s` in `MonadState`'s definition, it's impossible to do two different state manipulations within the same function. For example...
```haskell
f :: forall m ouput.
  => MonadState Int m
  => MonadState String m
  -> m output
f = do
  whichValue <- get
```

The compiler will complain because it doesn't know which value it should 'get'. See the answer to [Haskell -- Chaining two states using StateT monad transformer](https://stackoverflow.com/a/49782427)

One solution to this is to store all states in one larger state type and then use a `Lens` to access/change it:
```haskell
type IntAndString = { i :: Int, s :: String }
f :: forall m output.
  => MonadState IntAndString m
  -> m output
```

The second solution is to use type-level programming to specify which `MonadState` we are referring to via an `id` Symbol. This would force us to change `MonadState`'s definition to:
```haskell
class (Monad m) <= MonadState (id :: Symbol) state m | m -> state
  state :: forall a. Proxy id -> (s -> m (Tuple a s)) -> m a

_i :: Proxy "i"
_i = Proxy

_s :: Proxy "s"
_s = Proxy

f :: forall m ouput.
  => MonadState "i" Int m
  => MonadState "s" String m
  -> m output
f = do
  theInt <- get _i
  theString <- get _s
```

However, I'm not sure what are the pros/cons of this approach, but this is similar to how `Run` (explained in the `Free` folder) enables two different state manipulations.

## `MonadState` & `MonadWriter` lose their state on a runtime error

If a runtime error occurs in a computation that uses `MonadState` or `MonadWriter`, then the states in both `MonadState` and `MonadWriter` are lost (because the computation halts).

## `WriterT` & `RWST` has a "space leak" problem

This is largely due to `WriterT`'s usage of `Monoid`. The 'fix' is to drop some of its features and use a `StateT` instead. See [Writer Monads and Space Leaks - Infinite Negative Utility](https://blog.infinitenegativeutility.com/2016/7/writer-monads-and-space-leaks)

Since `RWST` also encodes things via `WriterT`, it also suffers from this problem.

## N-squared-ish Monad Transformer Instances

Whenever one wants to define a new monad transformer (e.g. `MonadAuthenticate`) to encode some effect, one must define ~`n^2` instances:
- 1 `MonadAuthenticate` instance for each `[Word]T` type via `MonadTrans` to lift the monadic newtyped `AuthenticateT` function.

```haskell
-- Given this stack of monad transformers
runCode :: AuthenticateT Credentials (StateT state (ReaderT value Identity Unit))

-- Each monadic function type (e.g. StateT, ReaderT, etc.) must
-- have an instance for MonadAuthenticate so it can lift the
-- AuthenticateT computation into the next monad.
```

- n instances for the monadic newtyped `AuthenticateT` function, so that it can lift its computation into all the other monad transformer type classes (e.g. `AuthenticateT` -> `MonadState`, `MonadWriter`, etc.)

```haskell
-- Given this stack of monad transformers
runCode :: ReaderT Value (StateT state (AuthenticateT Credentials Identity Unit))

-- AuthenticateT must lift ReaderT and StateT into an AuthenticateT
-- monadic type.
```

In short, we define that many instances so that the order of the monad stack does not matter **as much**. If our stack has an `ExceptT` somewhere in there, where that type occurs will change the final output.

Note: I say roughly **~**`n^2` because apparently there are some cases where "lifting" a function would break a law (or something).

## Monad transformer stacks' type signatures get complicated quickly

Related to the previous point, but the type signatures start getting crazy very quickly. For new beginners who are just learning about monad transformers, this can be quite offsetting:
```haskell
-- as an example using pseudo-syntax...
f :: StateT State (ReaderT reader (WriterT writer (ExceptT error Effect output) output))
```

## The Order of the Monad Transformer Stack Matters

We mentioned this previously when covering how to use a monad transformer:
```haskell
type Output = Int
type StateType = Int
type NonOutputData = String
computation :: forall m
          . MonadState StateType m
         => MonadAsk NonOuputData m
         => m Output
computation = do
  modify_ (_ + 1)
  tell "Modified state by adding 1"
  currentState <- modify (_ * 10)
  tell $ "Modified state by multiplying by 10. It is now "
    <> show currentState
  modify_ (_ + 1)

-- Both `program1` and `program2` support the necessary
-- capabilities to run `computation`.
runProgram1 :: WriterT NonOutputData (State state) Output
            -> state
            -> Tuple (Tuple Output NonOuputData) state
runProgram1 initialState =
  runState (runWriterT computation) initialState

runProgram2 :: StateT state (Writer NonOutputData) Output
            -> state
            -> Tuple (Tuple Output state) NonOuputData
runProgram2 initialState =
  runWriter (runStateT computation initialState)
```

Imagine if one of these was `ExceptT`. That monad transformer's location in the stack can affect how the computation works and whether it works as expected.
