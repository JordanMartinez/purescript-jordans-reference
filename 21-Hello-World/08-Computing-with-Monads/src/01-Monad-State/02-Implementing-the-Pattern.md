# Implementing the Pattern

Here's the solution we came up with:
```javascript
(Tuple x random2) = random1.nextInt
(Tuple y random3) = random2.nextInt

(Tuple x originalStack_withoutX)    = originalStack.pop
(Tuple y originalStack_withoutXorY) = originalStack_withoutX.pop

// and generalizing it to a pattern, we get
(Tuple value1,  instance2        ) = instance1.stateManipulation
(Tuple value2,  instance3        ) = instance2.stateManipulation
(Tuple value3,  instance4        ) = instance3.stateManipulation
// ...
(Tuple value_N, instance_N_plus_1) = instanceN.stateManipulation
```
Turning this into Purescript syntax, we get:
```purescript
not_yet_named_function :: forall state value. (state -> Tuple value state)
```

## First Attempts

Starting with a simple example written using meta-language, we can simulate the state manipulation syntax when it's only run once.
```purescript
initialValue :: Int
initialValue = 0

               -- state -> Tuple value    state
increaseByOne :: (Int   -> Tuple Int      Int)
increaseByOne oldState   = Tuple theValue theNextState
  where
  theValue = oldState + 1

  theNextState = oldState + 1

main :: Effect Unit
main =
  case (increaseByOne initialValue) of
    Tuple theValue theNextState -> do
      log $ "Value was: " <> show theValue           -- 1
      log $ "next state was: " <> show theNextState  -- 1
```
What if we want to run `increaseByOne` four times?

Ideally, we should follow the pattern we identified above:
1. Pass an initial state value into `increaseByOne`
2. Take the state-part of the first output and pass it into another `increaseByOne` call
3. Return the second call's output.

If we were to try to put this into code, we'd get this:
```purescript
increaseFourTimes :: Int -> Int
increaseFourTimes initialState = runNTimes 4 increaseByOne initialState

runNTimes :: forall monad. Int -> Int -> (Int -> Tuple Int Int)
runNTimes 0 i _ = i
runNTimes count i increaseByOne =
  runNTimes (count - 1) (next increaseByOne i) increaseByOne

  where
  next :: (Int -> Tuple Int Int) -> Int -> Int -- state, not value type
  next f i = getSecond $ f i

  getSecond :: Tuple Int Int -> Int
  getSecond (Tuple _ state) = state
```

### Why We Need a Monad

This works... until we need to do something more complex. If we want additional functions that all have the same type signature, we could pass in an array of such functions and do something similar to above. However, if those functions' have different value types, this no longer works. The following function, `crazyFunction`, demonstrates this problem:
1. Take some `initialState` value as input
2. Pass that value into `increaseByOne :: Int -> Tuple Int Int`, which returns `Tuple value nextState`
4. Pass `nextState` into `timesTwoToString :: Int -> Tuple String Int`, which returns `Tuple value2 nextState2`
5. Return `timesTwoToString`'s output: `Tuple value2 nextState2`

To write `crazyFunction`, we need something more like sequential computation via `bind`/`>>=`. However, `bind` requires a Monad to work. With those two clues, we need a function whose type signature looks almost like this:
```purescript
someFunction :: forall state monad value
              . Monad monad
             => (state -> Tuple value state) -- the state manipulation function
             -> state                        -- the initial state
             -> monad (Tuple value state)    -- the monad that makes `bind` work
someFunction function = (\state -> pure $ function state)
```
We could write a function described above using a Monad like `Box`.

However, if the output of one state manipulation function will be passed into the next, then we don't need an `initialState` value anymore. Rather, it should become a part of the return type.
This implies that another function, `runSomeFunction` should exist that does a few things:
1. Passes the `initialState` value into the final composition of all the state manipulating functions
2. Unwrap the `someFunction`'s returned `Monad (Tuple value state)` to get the final `(Tuple value state)`

Our updated code now reads:
```purescript
someFunction :: forall state monad value
              . Monad monad

             -- the state manipulation function
             => (state -> Tuple value state)

             -- lifted into a Monad that makes `bind` work,
             -- so we can compose multiple state manipulating functions
             -- together into one function
             -> (state -> monad (Tuple value state))
someFunction function = (\state ->
    let tuple = function state

      -- lift it into the Monad to
      -- enable sequential computation via bind
    in pure tuple
  )

runSomeFunction :: forall state monad value
                 . (state -> monad (Tuple value state))
                -> (monad (Tuple value state) -> Tuple value state)
                -> state
                -> Tuple value state
runSomeFunction stateFunctionsComposedIntoOne unwrap initialState =
  unwrap (stateFunctionsComposedIntoOne initialState)

-- our Monad type
data Box a = Box a

unwrapBox :: forall a. Box a -> a
unwrapBox (Box a) = a

-- Uses `someFunction` to compose multiple state functions together into one
crazyFunction :: Int -> Box (Tuple Int Int)
crazyFunction s_int0 = do                                                   {-
  Tuple values    state       <- (\state -> pure $ function state) state0
  Tuple typeValue s_typeValue <-                                            -}
  Tuple int2      s_int2      <- (someFunction increaseByOne) s_int0
  (someFunction timesTwoToString) s_int2

main :: Effect Unit
main =
  case (unwrapBox $ crazyFunction 0) of
    Tuple theString theInt -> do
      log $ "theString was: " <> theString  -- "2"
      log $ "theInt was: " <> show theInt   -- 7
```

## The `Identity` Monad

However, we have a problem.... `Box` is a literal runtime Box. So, using it here means we'll be boxing and unboxing the result of our functions. We only need `Box` so we can use a Monad for sequential computation, not because we need the type, `Box`, specifically. We could use `Box2` and our code wouldn't change. This implies unneeded runtime overhead. Why don't we fix this by using a type that only exists at compile-time? This implies using `newtype`.

Since we have a "placeholder" function called `identity`, let's reuse this name for our compile-time-only type:
```purescript
identity :: forall a. a -> a
identity x = x

data    Box      a = Box      a -- runtime type!
newtype Identity a = Identity a -- compile-time-ONLY type!
```

### Abstracting the Concept into a Type Class

This solves one problem, but we still have another problem. We cannot use `someFunction` globally. For now, it must be defined in a file to use it in that file. This implies that we need to convert it into a type class so we can expose its function using a type class constraint. Let's attempt to define it and call the type class `StateLike`. It's function, `stateLike`, should be the same as `someFunction`'s type signature:
```purescript
someFunction :: forall state monad value
              . Monad monad
             => (state ->        Tuple value state)
             -> (state -> monad (Tuple value state))
someFunction function = (\state -> pure $ function state)

class StateLike ??? where
  stateLike :: forall s m a
             .  (s     ->        Tuple a s )
             -> (s     -> m     (Tuple a s))
```
This should work for every monad type, so let's push the `m` to `???`:
```purescript
class (Monad m) <= StateLike m where
  stateLike :: forall s a
             .  (s     ->        Tuple a s )
             -> (s     -> m     (Tuple a s))
```
We need to make sure the `s` type does not change, so we'll also define a functional dependency from `m` to `s`
```purescript
class (Monad m) <= StateLike s m | m -> s where
  stateLike :: forall a
             .  (s     ->        Tuple a s )
             -> (s     -> m     (Tuple a s))
```
Now let's implement it for `Identity`:
```purescript
class (Monad m) <= StateLike s m | m -> s where
  stateLike :: forall a
             .  (s ->   Tuple a s )
             -> (s -> m (Tuple a s))

instance name :: StateLike s (Identity (Tuple a s)) where
  stateLike f = (\s -> pure $ f s)
```
Great! Everything works now! Here's a working example:
```purescript
class (Monad m) <= StateLike s m | m -> s where
  stateLike :: forall a
             .  (s ->   Tuple a s )
             -> (s -> m (Tuple a s))

instance name :: StateLike s (Identity (Tuple a s)) where
  stateLike f = (\s -> pure $ f s)

instance aplctv :: Applicative Identity where
  pure :: forall a. a -> Identity a
  pure a = Identity a

newtype Identity a = Identity a

unwrapBox :: forall a. Identity a -> a
unwrapBox (Identity a) = a

runSomeFunction :: forall s m a
                 . StateLike m
                => (s -> m (Tuple a s))
                -> (m (Tuple a s) -> Tuple a s)
                -> s
                -> Tuple a s
runSomeFunction stateFunctionsComposedIntoOne unwrap initialState =
  unwrap (stateFunctionsComposedIntoOne initialState)

crazyFunction :: Int -> Box (Tuple Int Int)
crazyFunction s_int0 = do                                                   {-
  Tuple values    state       <- (\state -> pure $ function state) state0
  Tuple typeValue s_typeValue <-                                            -}
  Tuple int2      s_int2      <- (someFunction increaseByOne) s_int0
  (someFunction timesTwoToString) s_int2

main :: Effect Unit
main =
  case (runSomeeFunction crazyFunction unwrapBox 0) of
    Tuple theString theInt -> do
      log $ "theString was: " <> theString  -- "3"
      log $ "theInt was: " <> show theInt   -- 8
```
