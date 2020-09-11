# MonadState

`MonadState` is used to run state manipulating functions. Since only one type implements the class, we'll combine the class' definition and instance into one block:
```haskell
newtype StateT state monad output =
  StateT (\state -> monad (Tuple output state))

-- Pseudo syntax: combines class and instance into one block:
class (Monad m) <= MonadState s (StateT s m) where
  state :: forall a. (s -> Tuple a s) -> StateT s m a
  state f = StateT (\s -> pure $ f s)
```

## Reading Its Do Notation

```haskell
stateT_do_notation :: StateT State Value
stateT_do_notation = do
    value1 <- state (\initialState -> Tuple value1 state2)
    value2 <- state (\state2       -> Tuple value2 state3)
    value3 <- state (\state3       -> Tuple value3 state4)
    state (\state4 -> Tuple value4 state5)
```

## Derived Functions

As we saw above, whenever we wrote `state function`, `function` always had to wrap our output into a `Tuple` type:
```haskell
(\state -> {- do stuff -} Tuple output nextState)
```
This gets tedious really fast. Fortunately, `MonadState`'s derived functions remove that boilerplate and emphasize the developer's intent:
- `get`: returns the state
- `gets`: applies a function to the state and returns the result (useful for extracting some value out of the state)
- `put`: overwrites the current state with the argument
- `modify`: modify the state and return the updated state
- `modify_`: same as `modify` but return `unit` so we can ignore the `binding <-` syntax

```haskell
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
```haskell
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

runState :: forall s a. StateT s Identity a -> s -> Tuple a s
runState stateT initialState =
  let (Identity tuple) = runStateT stateT initialState
  in tuple

runStateT :: forall s m a. StateT s m a -> s -> m Tuple a s
runStateT (StateT f) initialState = f initialState
```

## Laws, Instances, and Miscellaneous Functions

For the laws, see [MonadState's docs](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.State.Class#t:MonadState)

For its instances, see:
- [Functor](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/State/Trans.purs#L58)
- [Apply](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/State/Trans.purs#L61)
- [Applicative](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/State/Trans.purs#L64)
- [Bind](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/State/Trans.purs#L75)
- [MonadState](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/State/Trans.purs#L123)

To handle/modify the output of a state computation:
- [State](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.State#v:runState)
- [StateT](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.State.Trans#v:runStateT)
