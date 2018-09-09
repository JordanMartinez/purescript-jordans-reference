# MonadState

It's time to reveal the real names of the types we've defined:

| Our Name | Real Name |
| - | - |
| `class (Monad m) <= StateLike s m` | `class (Monad m) <= MonadState s m` |
| `stateLike` | `state`
| `StateFunction s m a` | `StateT s m a`
| `StateFunction s Identity a` | `State s   a`
| `runStateLike`<br>(`m` is undefind) | `runStateT`
| `runStateLike`<br>(`m` is `Identity`) | `runState`

The `T` in `StateT` stands for "Transformer": it can transform any monad (e.g. a Stack type) into a State Monad that exposes state manipulating computations.

## Reading MonadState's Do Notation

Because the `StateT`/`StateFunction` is a Monad, we can write code via do notation. However, reading through its `do notation` is strange at first. As you read through this next code snippet, you might wonder two things:
1. How does `StateT` produce a value type instead of a Tuple type?
2. How can we still use the `nextState` as an argument in the `state` function since we never pass it into the function?"
```purescript
                  -- StateT StateType Identity ValueType
state_do_notation :: State  StateType          ValueType
state_do_notation = do

    -- This is what do notation looks like using a StateT monad

    value1 <- state (\initialState -> Tuple value1 state2)
    value2 <- state (\state2       -> Tuple value2 state3)
    value3 <- state (\state3       -> Tuple value3 state4)
    state (\state4 -> Tuple value4 state5)
```
To answer the questions above:
1. Recall that `StateT` is a Monad (i.e. `m a`) whose `a` is the `a` in `Tuple a s`. So, when we call `bind` on it, it returns that `a`, not the `Tuple a s`.
2. `StateT` is a function, not a `Box`-like type. So, its `bind` works very differently than `Box`'s bind. `state2` reappears in the next function's argument because of how `StateT` implements `bind`.

If you don't care to see how the above Answer 2 is possible (warning: the next section is 200 lines), then [jump to the next section](#derived-functions) where we talk about `MonadState`'s derived functions.

Otherwise, this next section will reduce a `StateT`'s do notation into its final result.

## Reducing a StateT's Do Notation

It gets ugly pretty quickly, but we present it in a manner that reduces the information overload:
```purescript
-- Start! (We'll only reduce a single bind and pure)
f = do
  value1 <- state (\initialState -> pure $ Tuple value1 state2)
  state (\state2 -> Tuple value1 state3)

-- Turn everything from "do notation" back to ">>="
f =
  state (\initialState -> Tuple value1 state2) >>= (\value1 ->
    state (\state2 -> Tuple value1 state3)
  )

-- Convert all ">>=" into "bind"
f =
  bind (state (\initialState -> Tuple value1 state2)) (\value1 ->
    state (\state2 -> Tuple value1 state3)
  )

-- Put everything on one line (seriously, this will help)
f = bind (state (\initialState -> Tuple value1 state2)) (\value1 -> state (\state2 -> Tuple value2 state3))

-- Take the function that is passed to the first bind, call it "func",
-- and put it into a 'where' clause:
f = bind (state (\initialState -> Tuple value1 state2)) func
  where
  func = (\value1 -> state (\state2 -> Tuple value2 state3))

-- hide everything but "func"
func = (\value1 -> state (\state2 -> Tuple value2 state3))

-- Recall what StateT's MonadState implementation is...
instance monadState :: Monad m => MonadState s (StateT s m) where
  state f = StateT (\sA -> pure $ f sA)
-- ... and use it to replace `state`'s LHS with its RHS
func = (\value1 -> StateT (\sA -> pure   $  (\state2 -> Tuple value2 state3) sA ))

-- Rename `pure` to `pureID` to show that it's Identity's "pure"
func = (\value1 -> StateT (\sA -> pureID $  (\state2 -> Tuple value2 state3) sA ))

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
instance monadState :: Monad m => MonadState s (StateT s m) where
  state f = StateT (\s -> pure $ f s)
-- ... and use it to replace `state`'s LHS with its RHS
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
instance bind :: (Monad m) => Bind (StateT s m) where
  bind :: forall a b. StateT s m a -> (a -> StateT s m b) -> StateT s m b
  bind (StateT g) f = StateT (\sY -> (g sY) >>= func2)
    where
    func2 = (\(Tuple value1 sX) -> let (StateT h) = f    value1 in h sX)
-- ... and replace its LHS with its RHS
f = StateT (\sY -> (g sY) >>= func2)
    where
    g = (\sZ -> Identity ((\initialState -> Tuple value1 state2) sZ))
    func2 = (\(Tuple value1 sY) -> let (StateT h) = func value1 in h sY)

-- Re-expose "func" argument
f = StateT (\sY -> (g sY) >>= func2)
    where
    g = (\sZ -> Identity ((\initialState -> Tuple value1 state2) sZ))
    func2 = (\(Tuple value1 sY) -> let (StateT h) = func value1 in h sY)
    func = (\value1 -> StateT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)))
```

#### Calling RunStateT

We now have our final function and are ready to apply its first argument
```purescript
finalFunction = StateT (\sY -> (g sY) >>= func2)
    where
    g = (\sZ -> Identity ((\initialState -> Tuple value1 state2) sZ))
    func2 = (\(Tuple value1 sY) -> let (StateT h) = func value1 in h sY)
    func = (\value1 -> StateT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)))

-- Now call "runState" with "finalFunction" and some initial state
-- where 'm' is Identity
runStateT :: forall s m a. StateFunction s m a -> s -> m (Tuple a s)
runStateT (StateT f) initS = f initS

-- which now becomes
runStateT = (\sY -> (g sY) >>= func2) initS
    where
    g = (\sZ -> Identity ((\initialState -> Tuple value1 state2) sZ))
    func2 = (\(Tuple value1 sY) -> let (StateT h) = func value1 in h sY)
    func = (\value1 -> StateT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)))

-- apply initialState to the argument
runStateT = (g initS) >>= func2
    where
    g = (\sZ -> Identity ((\initialState -> Tuple value1 state2) sZ))
    func2 = (\(Tuple value1 sY) -> let (StateT h) = func value1 in h sY)
    func = (\value1 -> StateT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)))

-- bump "g" to the main function
runStateT = ((\sZ -> Identity ((\initialState -> Tuple value1 state2) sZ)) initS) >>= func2
    where
    func2 = (\(Tuple value1 sY) -> let (StateT h) = func value1 in h sY)
    func = (\value1 -> StateT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)))

-- Apply initS to the function
runStateT = (Identity ((\initialState -> Tuple value1 state2) initS)) >>= func2
    where
    func2 = (\(Tuple value1 sY) -> let (StateT h) = func value1 in h sY)
    func = (\value1 -> StateT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)))

-- call Identity's ">>="
runStateT = func2 ((\initialState -> Tuple value1 state2) initS)
    where
    func2 = (\(Tuple value1 sY) -> let (StateT h) = func value1 in h sY)
    func = (\value1 -> StateT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)))

-- apply "initS" to "(\initialState -> body)" function
runStateT = func2 (Tuple value1 initS)
    where
    func2 = (\(Tuple value1 sY) -> let (StateT h) = func value1 in h sY)
    func = (\value1 -> StateT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)))

-- bump "func2" into main function
runStateT =
  (\(Tuple value1 sY) ->
        let (StateT h) = func value1
        in h sY
  ) (Tuple value1 initS)

  where
  func = (\value1 -> StateT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)))

-- apply Tuple argument to the function
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
  let (StateT h) = StateT (\sA -> Identity ((\state2 -> Tuple value2 state3) sA))
  in h initS)

-- Use pattern matching to extract the function bound to "h"
-- and replace the "h" binding with its definition
runStateT = (\sA -> Identity ((\state2 -> Tuple value2 state3) sA)) initS

-- Apply "initS" to function
runStateT = Identity ((\state2 -> Tuple value2 state3) initS))

-- apply "initS" to function (again)
runStateT = Identity (Tuple value2 initS)

-- End result!
runStateT :: forall s m a. m (Tuple a s)
runStateT = Identity (Tuple value2 initS)
```

## Derived Functions

As we saw above, whenever we wrote `state function`, `function` always had to wrap our output into a `Tuple` type:
```purescript
(\state -> {- do stuff -} Tuple output nextState)
```
This gets tedious really fast. Fortunately, `MonadState`'s derived functions remove that boilerplate and emphasize the developer's intent:
- `get`: returns the state
- `gets`: applies a function to the state and returns the result (useful for extracting some value out of the state)
- `put`: overwrites the current state with the argument
- `modify`: modify the state and return the updated state
- `modify_`: same as `modify` but return `unit` so we can ignore the `binding <-` syntax

```purescript
sideBySideComparison :: State Int String
sideBySideComparison = do
  state1  <- state (\s -> Tuple s s)
  state2  <- get

  shownI1 <- state (\s -> Tuple (show s) s)
  shownI2 <- gets show

  state (\s -> Tuple unit 5)
  put 5

  added1A <- state (\s -> let s' = s + 1 in Tuple s' s')
  added1B <- modify (_ + 1)

  -- Unit gets discared again!
  state (\s -> Tuple unit (s + 1))
  modify_ (_ + 1)

  -- to satisfy the type requirements
  -- in that the function ultimately returns a `String`
  pure "string"
```

Returning to our previous example, `crazyFunction` was implemented like so:
1. Take some `initialState` value
2. Pass that value into `add1 :: State -> Tuple Int Int`, which returns `Tuple value1 state2`
3. Pass `value` and `state2` into `addValue1StringLengthTo :: Int -> Int -> Tuple String Int` where
    - `value` will be converted into a `String`, called `valueAsString`
    - the length of `valueAsString` will be added to `state2`, which produces `state3`
    - `state3` is converted into a `String`, called `value2`
    - the function returns `Tuple value2 state3`
4. Return `addStringLengthTo`'s output: `Tuple value2 nextState3`

With `MonadState`, we would now write:
```purescript
crazyFunction :: State Int String
crazyFunction = do
  value1 <- modify (_ + 1)
  modify_ (_ + (length $ show value1))
  gets show

main :: Effect Unit
main =
  case (runState crazyFunction 0) of
    Tuple theString theInt -> do
      log $ "theString was: " <> theString  -- "2"
      log $ "theInt was: " <> show theInt   --  2

unwrap :: forall a. Identity a -> a
unwrap (Identity a) = a

runState :: forall s a. StateT s Identity a -> s -> Tuple a s
runState (StateT f) initialState =
  unwrap $ runStateT f initialState

runStateT :: forall s m a. StateT s m a -> s -> m Tuple a s
runStateT (StateT f) initialState = f initialState
```

## Laws and Miscellaneous Functions

For the laws, see [MonadState's docs](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.State.Class#t:MonadState)

To handle/modify the output of a state computation:
- [State](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.State#v:runState)
- [StateT](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.State.Trans#v:runStateT)
