# Implementing the Pattern

Here's the solution we came up with:
```javascript
(Tuple x random2) = randomInt(random1);
(Tuple y random3) = randomInt(random2);

(Tuple x originalStack_withoutX)    = pop(originalStack);
(Tuple y originalStack_withoutXorY) = pop(originalStack_withoutX);

// and generalizing it to a pattern, we get
(Tuple value1,  instance2        ) = stateManipulation(instance1);
(Tuple value2,  instance3        ) = stateManipulation(instance2);
(Tuple value3,  instance4        ) = stateManipulation(instance3);
// ...
(Tuple value_N, instance_N_plus_1) = stateManipulation(instanceN);
```
Turning this into Purescript syntax, we get:
```purescript
state_manipulation_function :: forall state value. (state -> Tuple value state)
```

## Syntax Familiarity

Starting with a simple example written using meta-language, we can simulate the state manipulation syntax when it's only run once. Unlike the "add 1 to integer" problem from before, this will return the integer state as a `String`, not an `Int`:
```purescript
type State = Int
type Value = String

initialState :: State
initialState = 0

add1 :: (State -> Tuple String Int)
add1 oldState   =
  let theNextState = oldState + 1
  in Tuple (show theNextState) theNextState

main :: Effect Unit
main =
  case (add1 initialValue) of
    Tuple theValue theNextState -> do
      log $ "Value was: " <> theValue               -- "1"
      log $ "next state was: " <> show theNextState --  1
```

### Why We Need a Monad

What if we want to run `add1` four times?

Knowing that we have more complicated state manipulation ahead of us (e.g. Stacks), we should follow the pattern we identified above:
1. Pass an initial state value into `add1`, which outputs `Tuple nextStateAsString nextState`
2. Extract the `nextState` part of the Tuple
3. Pass `nextState` it into another `add1` call
4. Loop a few times
5. Pass the last state into `add` and return its output: `Tuple stateAsString state`.

In code, this looks like:
```purescript
type State = Int
type Value = String
type Count = Int

add1 :: (State -> Tuple String Int)
add1 oldState   =
  let theNextState = oldState + 1
  in Tuple (show theNextState) theNextState

add1_FourTimes :: State -> Tuple Value State
add1_FourTimes initialState = runNTimes 4 add1 initialState

runNTimes :: Count -> (State -> Tuple Value State) -> State -> Tuple Value State
runNTimes 1 add1_ nextState = add1_ nextState
runNTimes count add1_ nextState =
  runNTimes (count - 1) add1_ (getSecond $ add1_ i)

  where
  getSecond :: Tuple Value State -> Int
  getSecond (Tuple _ state) = state
```

This works but only because it's so simple. Let's say we want to call `add1` on the first state, then call `times2` on the second state, and then return the output of calling `add1` on the third state. How would we update our code to do that?

We could try to specify a stack of functions (using an array or some other stack-like data structure) that are used to recursively evaluate the next state outputted by the previous function. Below is **not** a working example of how one would write that, but merely demonstrates the heart behind it:
```purescript
type Stack a = Array a
type State = Int
type Value = String

-- This code doesn't type check!
-- It exists for teaching purposes only!
runUsingFunctions :: Stack (State -> Tuple Value State) -> State -> Tuple Value State
runUsingFunctions [last] state = last state
runUsingFunctions [second, last] = runUsingFunctions [last] (getSecond $ second state)
runUsingFunctions [first, second, last] state =
  runUsingFunctions [second, last] (getSecond $ first state)

  where
  getSecond :: Tuple Value State -> State
  getSecond (Tuple _ state) = state
```
Conceptually, there are two problems with the above code.
1. If we change the value type for one function so that it's different from all other function in the stack (e.g. `toNumber :: Int -> Tuple Number Int`), the above code will no longer compile.
2. We cannot use a function that receives the next state AND value(s) produced by previous function(s) as its arguments.

As an example for the second point, how could we use these two functions in the same state manipulation workflow:
```purescript
firstFunction :: State1 -> Tuple Value1 State2

fourthFunction :: State4 -> Value1 -> Tuple Value4 State5
```
The following function, `crazyFunction`, demonstrates both of these problems without the intermediary second and third functions:
1. Take some `initialState` value
2. Pass that value into `add1 :: State -> Tuple Int Int`, which returns `Tuple value1 state2`
3. Pass `value` and `state2` into `addValue1StringLengthTo :: Int -> Int -> Tuple String Int` where
    - `value` will be converted into a `String`, called `valueAsString`
    - the length of `valueAsString` will be added to `state2`, which produces `state3`
    - `state3` is converted into a `String`, called `value2`
    - the function returns `Tuple value2 state3`
4. Return `addStringLengthTo`'s output: `Tuple value2 nextState3`

To write `crazyFunction`, we need something more like sequential computation, which implies `bind`/`>>=`. However, `bind` requires a Monad to work. With these clues, we need a function whose type signature looks something like this:
```purescript
someFunction :: forall state monad value
              . Monad monad
             => (state -> Tuple value state) -- the state manipulation function
             -> state                        -- the initial state
             -> monad (Tuple value state)    -- the monad that makes `bind` work
someFunction function = (\state -> pure $ function state)
```
However, if the output of one state manipulation function will be passed into the next, then we don't need an `initialState` value anymore. Rather, it implies that `initialState` should be relocated to another function, `runSomeFunction`, that does a few things:
1. Passes the `initialState` value into the final composition of all the state manipulating functions
2. Unwraps `someFunction`'s returned `Monad (Tuple value state)` box-like type to get the final `(Tuple value state)`

Using `Box` as our Monad type (for now), our code now reads:
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

addStringLengthTo :: Int -> Int -> Tuple String Int
addStringLengthTo value state =
  let valueAsString = show value
      state3 = state + (length valueAsString)
  in Tuple (show state3) state3

-- Uses `someFunction` to compose multiple state functions together into one
crazyFunction :: Int -> Box (Tuple Int Int)
crazyFunction state1 = do                                                   {-
  Tuple value    state        <- pure $ function state
  Tuple value    state        <- (\s -> pure $ function s) state
  Tuple value    state        <- (someFunction function) state

  Tuple typeValue s_typeValue <-                                            -}
  Tuple value1      state2      <- (someFunction increaseByOne) state1
  (someFunction (\s -> addStringLengthTo value1 s) state2

main :: Effect Unit
main =
  case (unwrapBox $ crazyFunction 0) of
    Tuple theString theInt -> do
      log $ "theString was: " <> theString  -- "2"
      log $ "theInt was: " <> show theInt   -- 7
```

## The `Identity` Monad

However, we have a problem.... `Box` is a literal runtime Box. So, using it here means we'll be boxing and unboxing the result of our functions. We only need `Box` so we can use a Monad for sequential computation, not because we need the type, `Box`, specifically (we could use `Box2` and our code wouldn't change). This implies unneeded runtime overhead. Why don't we fix this by using a type that only exists at compile-time? This implies using `newtype`.

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
This should work for every monad type, so let's add a Monad constraint, `m`, to `???`:
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
             .  (s ->    Tuple a s )
             -> (s -> m (Tuple a s))

instance name :: StateLike s Identity where
  stateLike f = (\s -> pure $ f s)
```
Great! Everything works now! Here's a working example:
```purescript
class (Monad m) <= StateLike s m | m -> s where
  stateLike :: forall a
             .  (s ->    Tuple a s )
             -> (s -> m (Tuple a s))

instance name :: StateLike s Identity where
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

addStringLengthTo :: Int -> Int -> Tuple String Int
addStringLengthTo value state =
  let valueAsString = show value
      state3 = state + (length valueAsString)
  in Tuple (show state3) state3

crazyFunction :: Int -> Box (Tuple Int Int)
crazyFunction state1 = do
  Tuple string state2 <- (someFunction increaseByOne) state1
  (someFunction (s -> addStringLengthTo string s)) state2

main :: Effect Unit
main =
  case (runSomeeFunction crazyFunction unwrapBox 0) of
    Tuple theString theInt -> do
      log $ "theString was: " <> theString  -- "3"
      log $ "theInt was: " <> show theInt   -- 8
```
