# Reading and Running StateFunctionT

This file will cover two things:
- how to read `StateFunctionT`'s do notation
    - A graph reduction of `StateFunctionT`'s do notation
- how to run a `StateFunctionT` with some initial input state

## Reading StateFunctionT Do Notation

Because `StateFunctionT` is a Monad, we can write code via do notation. However, reading through its `do notation` is strange at first. As you read through this next code snippet, you might wonder two things:
1. How does `StateFunctionT` produce a value type instead of a Tuple type?
2. How can we still use the `nextState` as an argument in the `statelike` function since we never pass it into the function?
```purescript
newtype StateLike_ state output = StateFunctionT state Identity output

                       -- StateFunctionT StateFunctionType Identity ValueType
stateFunctionT_do_notation :: StateFunctionT StateFunctionType          ValueType
stateFunctionT_do_notation = do

    -- This is what do notation looks like using a StateFunctionT monad

    value1 <- stateLike (\initialState -> Tuple value1 state2)
    value2 <- stateLike (\state2       -> Tuple value2 state3)
    value3 <- stateLike (\state3       -> Tuple value3 state4)
    stateLike (\state4 -> Tuple value4 state5)
```
To answer the questions above:
1. Recall that `StateFunctionT` is a Monad (i.e. `m a`) whose `a` is the `a` in `Tuple a s`. So, when we call `bind` on it, it returns that `a`, not the `Tuple a s`.
2. `StateFunctionT` is a function, not a `Box`-like type. So, its `bind` works very differently than `Box`'s bind. `state2` reappears in the next function's argument because of how `StateFunctionT` implements `bind`.

## Reducing a StateFunctionT's Do Notation

To help understand why the above two answers are true (and to see how it works in action), we will reduce a simple `StateFunctionT`'s do notation expression into its final result. Here's the simple expression:
```purescript
f = do
  value1 <- state (\initialState -> pure $ Tuple value1 state2)
  state (\state2 -> Tuple value1 state3)
```

It gets ugly pretty quickly, but we present it in a manner that reduces the information overload:
```purescript
-- Start!
f = do
  value1 <- state (\initialState -> pure $ Tuple value1 state2)
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

-- Recall what StateFunctionT's MonadState implementation is...
instance monadState :: Monad m => MonadState s (StateFunctionT s m) where
  state f = StateFunctionT (\sA -> pure $ f sA)
-- ... and use it to replace `state`'s LHS with its RHS
func = (\value1 -> StateFunctionT (\sA -> pure $ f sA))
  where
  f = (\state2 -> Tuple value2 state3)

-- bump `f` into `func`
func = (\value1 -> StateFunctionT (\sA -> pure $ (\state2 -> Tuple value2 state3) sA ))

-- Rename `pure` to `pureID` to show that it's Identity's "pure"
func = (\value1 -> StateFunctionT (\sA -> pureID $ (\state2 -> Tuple value2 state3) sA ))

-- replace "pureID"'s LHS with RHS
func = (\value1 -> StateFunctionT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)))

-- Re-expose main function
f = bind (state (\initialState -> Tuple value1 state2)) func
  where
  func = (\value1 -> StateFunctionT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)))

-- Omit the "where" clause for now,
-- but still keep `func` in the first line so we can come back to it
f = bind (state (\initialState -> Tuple value1 state2)) func

-- Recall what StateFunctionT's MonadState implementation is...
instance monadState :: Monad m => MonadState s (StateFunctionT s m) where
  state f = StateFunctionT (\s -> pure $ g s)
-- ... and use it to replace `state`'s LHS with its RHS
f = bind (StateFunctionT (\s -> pure $ g s)) func
  where
  g = (\initialState -> Tuple value1 state2)

-- Bump `g` into `f`
f = bind (
      StateFunctionT (\sZ -> pure $ (\initialState -> Tuple value1 state2) sZ)
    ) func

-- Rename the "pure" to "pureID" to help us remember that it's Identity's pure
f = bind (
      StateFunctionT (\sZ -> pureID $ (\initialState -> Tuple value1 state2) sZ)
    ) func

-- apply "pureID" to its argument
f = bind (
      StateFunctionT (\sZ -> Identity ((\initialState -> Tuple value1 state2) sZ))
    ) func

-- Recall what StateFunctionT's bind instance is...
instance bind :: (Monad m) => Bind (StateFunctionT s m) where
  bind :: forall a b. StateFunctionT s m a -> (a -> StateFunctionT s m b) -> StateFunctionT s m b
  bind (StateFunctionT g) f = StateFunctionT (\sY -> (g sY) >>= func2)
    where
    func2 = (\(Tuple value1 sX) -> let (StateFunctionT h) = f    value1 in h sX)
-- ... and replace its LHS with its RHS
f =
    StateFunctionT (\sY -> (g sY) >>= func2)
    ) func
    where
    g = (\sZ -> Identity ((\initialState -> Tuple value1 state2) sZ)
    func2 = (\(Tuple value1 sX) -> let (StateFunctionT h) = func value1 in h sX)

-- Re-expose "func" argument
f = StateFunctionT (\sY -> (g sY) >>= func2)
    where
    g = (\sZ -> Identity ((\initialState -> Tuple value1 state2) sZ))
    func2 = (\(Tuple value1 sX) -> let (StateFunctionT h) = func value1 in h sX)
    func = (\value1 -> StateFunctionT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)))

-- Finished!
finalFunction = StateFunctionT (\sY -> (g sY) >>= func2)
    where
    g = (\sZ -> Identity ((\initialState -> Tuple value1 state2) sZ))
    func2 = (\(Tuple value1 sX) -> let (StateFunctionT h) = func value1 in h sX)
    func = (\value1 -> StateFunctionT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)))
```

#### Running a StateFunctionT with an Initial Value

To run a `StateFunctionT`, we'll need to use a variant of `runSomeFunction`. It's `StateFunction` variant just unwraps the `Identity` monad:
```purescript
runStateFunctionT :: forall s m a. StateFunctionT s m a -> s -> m (Tuple a s)
runStateFunctionT (StateFunctionT f) initS = f initS

runStateFunction :: forall s a. StateFunction s a -> s -> Tuple a s
runStateFunction (StateFunctionT f) initS =
  unwrapIdentity $ runStateFunctionT f initS
```

### Reducing a RunStateFunctionT Call

We'll run the de-sugared do-notation function from above on some initial state, `initS`. This won't produce anything important, but shows why/how it still type checks:
```purescript
-- From above
f = StateFunctionT (\sY -> (g sY) >>= func2)
    where
    g = (\sZ -> Identity ((\initialState -> Tuple value1 state2) sZ))
    func2 = (\(Tuple value1 sX) -> let (StateFunctionT h) = func value1 in h sX)
    func = (\value1 -> StateFunctionT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)))

-- Now call "runState" with "f" and some initial state
-- where 'm' is Identity
runStateFunctionT :: forall s m a. StateFunction s m a -> s -> m (Tuple a s)
runStateFunctionT (StateFunctionT f) initS = f initS

-- which now becomes
runStateFunctionT = (\sY -> (g sY) >>= func2) initS
    where
    g = (\sZ -> Identity ((\initialState -> Tuple value1 state2) sZ))
    func2 = (\(Tuple value1 sX) -> let (StateFunctionT h) = func value1 in h sX)
    func = (\value1 -> StateFunctionT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)))

-- hide `func2` and `func`
runStateFunctionT = (\sY -> (g sY) >>= func2) initS
    where
    g = (\sZ -> Identity ((\initialState -> Tuple value1 state2) sZ))

-- apply initialState to the argument
runStateFunctionT = (g initS) >>= func2
    where
    g = (\sZ -> Identity ((\initialState -> Tuple value1 state2) sZ))

-- bump "g" to the main function
runStateFunctionT = ((\sZ -> Identity ((\initialState -> Tuple value1 state2) sZ)) initS) >>= func2

-- Apply `initS` to the `(\sZ -> body)` function
runStateFunctionT = (Identity ((\initialState -> Tuple value1 state2) initS)) >>= func2

-- Apply `initS` to the `(\initialState -> body)` function
runStateFunctionT = (Identity (Tuple value1 state2)) >>= func2

-- call Identity's ">>="
runStateFunctionT = func2 (Tuple value1 state2)

-- Re-expose `func2`
runStateFunctionT = func2 (Tuple value1 state2)
    where
    func2 = (\(Tuple value1 sX) -> let (StateFunctionT h) = func value1 in h sX)

-- bump "func2" into main function
runStateFunctionT =
  (\(Tuple value1 sX) ->
        let (StateFunctionT h) = func value1
        in h sX
  ) (Tuple value1 initS)

-- apply Tuple argument to the function
runStateFunctionT =
  let (StateFunctionT h) = func value1
  in h initS

-- Re-expose `func`
runStateFunctionT =
  let (StateFunctionT h) = func value1
  in h initS

  where
  func = (\value1 -> StateFunctionT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)))

-- bump "func" into main function
runStateFunctionT =
  let (StateFunctionT h) =
      (\value1 ->
        StateFunctionT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA))
      ) value1
  in h initS

-- apply "value1" to its function
runStateFunctionT =
  let (StateFunctionT h) =
        StateFunctionT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA))
  in h initS)

-- Use pattern matching to extract the function bound to "h"
runStateFunctionT =
  let h = (\sA -> Identity ((\state2 -> Tuple value2 state3) sA))
  in h initS)

-- and replace the "h" binding with its definition
runStateFunctionT =
          (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)) initS

-- Apply "initS" to `(\sA -> body)` function
runStateFunctionT =
                  Identity ((\state2 -> Tuple value2 state3) initS))

-- apply "initS" to `(\state2 -> body)` function
runStateFunctionT = Identity (Tuple value2 initS)

-- End result!
runStateFunctionT :: forall s m a. m (Tuple a s)
runStateFunctionT = Identity (Tuple value2 initS)
```
