# MonadState

It's time to reveal the real names of the types we've defined:

| Our Name | Real Name |
| - | - |
| `class (Monad m) <= StateLike s m` | `class (Monad m) <= MonadState s m` |
| `stateLike` | `state`
| `StateFunction s m a`<br>`m` is undefind | `StateT s m a`
| `StateFunction s m a`<br>`m` is `Identity` | `State s   a`
| `runStateLike`<br>`m` is undefind | `runStateT`
| `runStateLike`<br>`m` is `Identity` | `runState`

## Reading MonadState's Do Notation

Because the `StateT`/`StateFunction` is a Monad, we can write code via do notation. However, reading through its `do notation` is strange at first. As you read through this next code snippet, **you will probably wonder, "But if `bind`/`>>=` produces an instance of the `value` type and not the `Tuple` type, how can we still use `state` as an argument since we never pass it into the function?"**:
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
You wondered how it's possible to still use `state` as an argument since we never pass it into the function. This only appears confusing at first because you are forgetting that `state` returns a `StateT` instance. Recall that `StateT` is a Monad (i.e. `m a`) who's `a` is the `a` in `Tuple a s`. So, when we call `bind` on it, it returns that `a`.

If you don't care to see how it's possible for the `state2` to reappear in the following line as the next function's argument (warning: the next section is 200 LOC), then [jump to the next section](#derived-functions) where we talk about `MonadState`'s derived functions.

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

-- We now have our final function and are ready to apply its first argument

-- Now call "runState" with "f" and some initial state
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
Great! So, how do we use it now? See this snippet:
```purescript
unwrap :: forall a. Identity a -> a
unwrap (Identity a) = a

runState :: forall s a. StateT s Identity a -> s -> Tuple a s
runState (StateT f) initS = unwrap $ runStateT f initS

-- recalling our previous graph reduction from above...
--   replace "runStateT f initS" with its result
runState :: forall s a. StateT s Identity a -> s -> Tuple a s
runState (StateT f) initS = unwrap $ Identity (Tuple value2 initS)

-- replace "unwrap" LHS with RHS
runState :: forall s a. StateT s Identity a -> s -> Tuple a s
runState (StateT f) initS = Tuple value2 initS

-- Success!
runState :: forall s a. Tuple a s
runState = Tuple value2 initS
```

## Derived Functions

As we saw above, whenever we wrote `state function`, `function` always had to put our output into a `Tuple` type. This gets tedious really fast. Fortunately, that's why `MonadState`'s derived functions exist! They are convenience functions for wrapping our function's output into the `Tuple` return type. It makes the code more readable by reducing noise and emphasizing intent. Read through the derived functions' [source code here](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/State/Class.purs#L28-L28) and then look below to see why they are useful:
```purescript
-- This just gets the state by putting it into
-- the place where the value type would normally appear
-- It can be rewritten as `get`
getState :: Int -> Tuple Int Int
getState i = Tuple i i

-- This outputs the result of calling "show" on the state
-- It can be rewritten as `gets show`
justShow :: Int -> Tuple String Int
justShow i = Tuple (show i) i

-- This overwrites the state instance. Since we don't have
-- anything to put into the value spot, we just return `Unit`
putState :: Int -> Tuple Unit Int
putState i = Tuple unit i

-- This modifies the state using a function "(_ + 1)"
--    and returns the output as the value type
-- It can be rewritten as `modify (_ + 1)`
add1 :: Int -> Identity (Tuple Int Int)
add1 i =
  let value = i + 1
  in pure $ Tuple value value

sideBySideComparison :: State Int String
sideBySideComparison = do
  state1  <- state (\s -> getState)
  state2  <- get

  shownI1 <- state (\s -> justShow s)
  shownI2 <- gets show

  -- We don't need a "b <-" because the value is Unit
  -- Thus, it gets discarded
  state (\s -> putState 5)
  put 5

  added1A <- state (\s -> add1 s)
  added1B <- modify (_ + 1)

  -- Unit gets discared again!
  state (\s -> Tuple unit (s + 1))
  modify_ (_ + 1)

  -- to satisfy the type requirements
  -- in that the function ultimately returns a `String`
  pure "string"
```

Returning to our previous example, we wanted to implement `crazyFunction`:
1. Take some `initialState` value as input
2. Pass that value into `increaseByOne :: Int -> Tuple Int Int`, which returns `Tuple value nextState`
4. Pass `nextState` into `timesTwoToString :: Int -> Tuple String Int`, which returns `Tuple value2 nextState2`
5. Return `timesTwoToString`'s output: `Tuple value2 nextState2`

With our solution, we would now write:
```purescript
crazyFunction :: State Int String
crazyFunction = do
  modify_ (_ + 1)                    -- state is now   1
  value2_int <- modify (\s -> s * 2) -- state is now   3
  value2_string <- gets show         -- state is still 3
  modify (_ + 5)                     -- state is now   8

  pure value2_string

main :: Effect Unit
main =
  case (runState crazyFunction 0) of
    Tuple theString theInt -> do
      log $ "theString was: " <> theString  -- "3"
      log $ "theInt was: " <> show theInt   -- 8
```

## Laws

For the laws, see [MonadState's docs](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.State.Class#t:MonadState)
