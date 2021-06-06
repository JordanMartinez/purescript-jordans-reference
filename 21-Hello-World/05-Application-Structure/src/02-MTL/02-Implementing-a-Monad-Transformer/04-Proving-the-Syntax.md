# Proving the Syntax

This file will prove that the syntax works by doing a graph reduction of
- `StateT`'s do notation
- running a `StateT` and insuring it type checks.

## Reading StateT Do Notation

```haskell
newtype StateT state monad output = StateT (state -> monad (Tuple output state))

stateT_do_notation :: StateT StateType MonadType ValueType
stateT_do_notation = do

    -- This is what do notation looks like using a StateT monad

    value1 <- state (\initialState -> Tuple value1 state2)
    value2 <- state (\state2       -> Tuple value2 state3)
    value3 <- state (\state3       -> Tuple value3 state4)
    state (\state4 -> Tuple value4 state5)
```

## Reducing a StateT's Do Notation

It's now time to reduce a simple `StateT`'s do notation expression into its final result. Here's the simple expression:
```haskell
f = do
  value1 <- state (\initialState -> Tuple value1 state2)
  state (\state2 -> Tuple value1 state3)
```

It gets ugly pretty quickly, but we present it in a manner that reduces the information overload:
```haskell
-- Start!
f = do
  value1 <- state (\initialState -> Tuple value1 state2)
  state (\state2 -> Tuple value1 state3)

-- Turn the "do notation" back to ">>="
f =
  state (\initialState -> Tuple value1 state2) >>= (\value1 ->
    state (\state2 -> Tuple value1 state3)
  )

-- Convert ">>=" back into "bind"
f =
  bind (state (\initialState -> Tuple value1 state2)) (\value1 ->
    state (\state2 -> Tuple value1 state3)
  )

-- Take the function that is passed to bind, call it "func",
-- and put it into a 'where' clause:
f = bind (state (\initialState -> Tuple value1 state2)) func
  where
  func = (\value1 -> state (\state2 -> Tuple value2 state3))

-- hide everything but "func"
func = (\value1 -> state (\state2 -> Tuple value2 state3))

-- Recall what StateT's MonadState implementation is...
instance Monad m => MonadState s (StateT s m) where
  state f = StateT (\sA -> pure $ f sA)
-- ... and use it to replace `state`'s LHS with its RHS
func = (\value1 -> StateT (\sA -> pure $ f sA))
  where
  f = (\state2 -> Tuple value2 state3)

-- bump `f` into `func`
func = (\value1 -> StateT (\sA -> pure $ (\state2 -> Tuple value2 state3) sA ))

-- Rename `pure` to `pureID` to show that it's Identity's "pure"
func = (\value1 -> StateT (\sA -> pureID $ (\state2 -> Tuple value2 state3) sA ))

-- replace "pureID"'s LHS with RHS
func = (\value1 -> StateT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)))

-- Re-expose main function
f = bind (state (\initialState -> Tuple value1 state2)) func
  where
  func = (\value1 -> StateT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)))

-- Omit the "where" clause for now,
-- but still keep `func` in the first line so we can come back to it
f = bind (state (\initialState -> Tuple value1 state2)) func

-- Recall what StateT's MonadState implementation is...
instance Monad m => MonadState s (StateT s m) where
  state f = StateT (\s -> pure $ g s)
-- ... and use it to replace `state`'s LHS with its RHS
f = bind (StateT (\s -> pure $ g s)) func
  where
  g = (\initialState -> Tuple value1 state2)

-- Bump `g` into `f`
f = bind (
      StateT (\sZ -> pure $ (\initialState -> Tuple value1 state2) sZ)
    ) func

-- Rename the "pure" to "pureID" to help us remember that it's Identity's pure
f = bind (
      StateT (\sZ -> pureID $ (\initialState -> Tuple value1 state2) sZ)
    ) func

-- apply "pureID" to its argument
f = bind (
      StateT (\sZ -> Identity ((\initialState -> Tuple value1 state2) sZ))
    ) func

-- Recall what StateT's bind instance is...
instance (Monad m) => Bind (StateT s m) where
  bind :: forall a b. StateT s m a -> (a -> StateT s m b) -> StateT s m b
  bind (StateT g) f = StateT (\sY -> (g sY) >>= func2)
    where
    func2 = (\(Tuple value1 sX) -> let (StateT h) = f    value1 in h sX)
-- ... and replace its LHS with its RHS
f =
    StateT (\sY -> (g sY) >>= func2)
    ) func
    where
    g = (\sZ -> Identity ((\initialState -> Tuple value1 state2) sZ)
    func2 = (\(Tuple value1 sX) -> let (StateT h) = func value1 in h sX)

-- Re-expose "func" argument
f = StateT (\sY -> (g sY) >>= func2)
    where
    g = (\sZ -> Identity ((\initialState -> Tuple value1 state2) sZ))
    func2 = (\(Tuple value1 sX) -> let (StateT h) = func value1 in h sX)
    func = (\value1 -> StateT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)))

-- Finished!
finalFunction = StateT (\sY -> (g sY) >>= func2)
    where
    g = (\sZ -> Identity ((\initialState -> Tuple value1 state2) sZ))
    func2 = (\(Tuple value1 sX) -> let (StateT h) = func value1 in h sX)
    func = (\value1 -> StateT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)))
```

## Running a StateT with an Initial Value

To run a `StateT`, we just need to unwarp the `StateT` newtype wrapper.:
```haskell
runStateT :: forall s m a. StateT s m a -> s -> m (Tuple a s)
runStateT (StateT f) initS = f initS
```

### Reducing a `runStateT` Call

We'll run the de-sugared do-notation function from above on some initial state, `initS`. This won't produce anything important, but shows why/how it still type checks:
```haskell
-- From above
f = StateT (\sY -> (g sY) >>= func2)
    where
    g = (\sZ -> Identity ((\initialState -> Tuple value1 state2) sZ))
    func2 = (\(Tuple value1 sX) -> let (StateT h) = func value1 in h sX)
    func = (\value1 -> StateT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)))

-- Now call "runState" with "f" and some initial state
-- where 'm' is Identity
runStateT :: forall s m a. StateFunction s m a -> s -> m (Tuple a s)
runStateT (StateT f) initS = f initS

-- which now becomes
runStateT = (\sY -> (g sY) >>= func2) initS
    where
    g = (\sZ -> Identity ((\initialState -> Tuple value1 state2) sZ))
    func2 = (\(Tuple value1 sX) -> let (StateT h) = func value1 in h sX)
    func = (\value1 -> StateT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)))

-- hide `func2` and `func`
runStateT = (\sY -> (g sY) >>= func2) initS
    where
    g = (\sZ -> Identity ((\initialState -> Tuple value1 state2) sZ))

-- apply initialState to the argument
runStateT = (g initS) >>= func2
    where
    g = (\sZ -> Identity ((\initialState -> Tuple value1 state2) sZ))

-- bump "g" to the main function
runStateT = ((\sZ -> Identity ((\initialState -> Tuple value1 state2) sZ)) initS) >>= func2

-- Apply `initS` to the `(\sZ -> body)` function
runStateT = (Identity ((\initialState -> Tuple value1 state2) initS)) >>= func2

-- Apply `initS` to the `(\initialState -> body)` function
runStateT = (Identity (Tuple value1 state2)) >>= func2

-- call Identity's ">>="
runStateT = func2 (Tuple value1 state2)

-- Re-expose `func2`
runStateT = func2 (Tuple value1 state2)
    where
    func2 = (\(Tuple value1 sX) -> let (StateT h) = func value1 in h sX)

-- bump "func2" into main function
runStateT =
  (\(Tuple value1 sX) ->
        let (StateT h) = func value1
        in h sX
  ) (Tuple value1 initS)

-- apply Tuple argument to the function
runStateT =
  let (StateT h) = func value1
  in h initS

-- Re-expose `func`
runStateT =
  let (StateT h) = func value1
  in h initS

  where
  func = (\value1 -> StateT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)))

-- bump "func" into main function
runStateT =
  let (StateT h) =
      (\value1 ->
        StateT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA))
      ) value1
  in h initS

-- apply "value1" to its function
runStateT =
  let (StateT h) =
        StateT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA))
  in h initS)

-- Use pattern matching to extract the function bound to "h"
runStateT =
  let h = (\sA -> Identity ((\state2 -> Tuple value2 state3) sA))
  in h initS)

-- and replace the "h" binding with its definition
runStateT =
          (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)) initS

-- Apply "initS" to `(\sA -> body)` function
runStateT =
                  Identity ((\state2 -> Tuple value2 state3) initS))

-- apply "initS" to `(\state2 -> body)` function
runStateT = Identity (Tuple value2 initS)

-- End result!
runStateT :: forall s m a. m (Tuple a s)
runStateT = Identity (Tuple value2 initS)
```
