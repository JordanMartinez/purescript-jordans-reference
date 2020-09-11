# Implementing the Pattern

Here's the solution we came up with:
```javascript
(Tuple x random2) = randomInt(random1);
(Tuple y random3) = randomInt(random2);

(Tuple x originalStack_withoutX)    = pop(originalStack);
(Tuple y originalStack_withoutXorY) = pop(originalStack_withoutX);

// and generalizing it to a pattern, we get
(Tuple value1,  value2        ) = stateManipulation(value1);
(Tuple value2,  value3        ) = stateManipulation(value2);
(Tuple value3,  value4        ) = stateManipulation(value3);
// ...
(Tuple value_N, value_N_plus_1) = stateManipulation(valueN);
```
Turning this into Purescript syntax, we get:
```haskell
state_manipulation_function :: forall state value. (state -> Tuple value state)
```

## Syntax Familiarity

Starting with a simple example written using meta-language, we can simulate the state manipulation syntax when it's only run once. Unlike the "add 1 to integer" problem from before, this will return the integer state as a `String`, not an `Int`:
```haskell
type State = Int
type Value = String

initialState :: State
initialState = 0

add1 :: (State -> Tuple Value State)
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

## Why We Need a Monad

What if we want to run `add1` four times?

Knowing that we have more complicated state manipulation ahead of us (e.g. Stacks), we should follow the pattern we identified above:
1. Pass an initial state value into `add1`, which outputs `Tuple nextStateAsString nextState`
2. Extract the `nextState` part of the Tuple
3. Pass `nextState` into another `add1` call
4. Loop a few times
5. Pass the last state into `add` and return its output: `Tuple lastStateAsString lastState`.

In code, this looks like:
```haskell
type State = Int
type Value = String
type Count = Int

add1 :: (State -> Tuple Value State)
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

We could try to specify a stack of functions (using an array or some other stack-like data structure) that are used to recursively evaluate the next state outputted by the previous function. **Below is not a working example** of how one would write that, **but merely demonstrates the heart** behind it:
```haskell
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
```haskell
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
```haskell
someFunction :: forall state monad value
              . Monad monad
             => (state -> Tuple value state) -- the state manipulation function
             -> state                        -- the initial state
             -> monad (Tuple value state)    -- the monad that makes `bind` work
someFunction function state = pure $ function state
```
Putting this all together, we get this:
```haskell
someFunction :: forall state monad value
              . Monad monad

             -- the state manipulation function...
             => (state -> Tuple value state)

             -- (the initial/next state)
             -> state

             -- whose output gets lifted into a Monad that makes `bind` work,
             -- so we can compose multiple state manipulating functions
             -- together into one function
             -> monad (Tuple value state))
someFunction function initialOrNextState =
    let tuple = function initialOrNextState

      -- lift it into the Monad to
      -- enable sequential computation via bind
    in pure tuple
  )

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
crazyFunction initial = do                                                   {-
  Tuple value  state  <- pure $ function state
  Tuple value  state  <- (\s -> pure $ function s) state
  Tuple value  state  <- (someFunction function) state                      -}
  Tuple value1 state2 <- (someFunction add1) initial
  (someFunction (\s -> addStringLengthTo value1 s) state2

main :: Effect Unit
main =
  case (unwrapBox $ crazyFunction 0) of
    Tuple theString theInt -> do
      log $ "theString was: " <> theString  -- "2"
      log $ "theInt was: " <> show theInt   --  2
```

There's two problems with the above approach, which the next sections will refine.

## The `Identity` Monad

`Box` is a literal runtime Box. So, using it here as our monad type means we'll be runtime boxing and unboxing the result of our functions, thereby slowing down our code needlessly. We only need `Box` so we can use a Monad for sequential computation, not because we need the type, `Box`, specifically (we could use `Box2` and our code wouldn't change). Why don't we get rid of this needless runtime overhead by using a type that only exists at compile-time? This implies using `newtype` because the type still needs to implement an instance for `Monad`.

Since we have a "placeholder" function called `identity`, let's reuse this name for our compile-time-only type:
```haskell
-- placeholder for a function!
identity :: forall a. a -> a
identity x = x

-- runtime type!
data    Box      a = Box      a

-- placeholder for a monad!
-- compile-time-ONLY type!
newtype Identity a = Identity a
```

## The Syntax Problem

`crazyFunction` showed an issue with our current approach: we have to pass the previous `state` result back into the next function. If the developer passes in the wrong state value, the code will no longer work as expected:
```haskell
crazyFunction :: Int -> Identity (Tuple Int Int)
crazyFunction initial = do
  -- Computation 1: here we calculate what state2 is
  Tuple value1 state2 <- (someFunction add1) initial

  -- Computation 2: here we calculate what state3 is
  Tuple value2 state3 <- (someFunction add1) state2

  -- Computation 3: here we pass in `state2` when we should pass in `state3`
  (someFunction (\s -> addStringLengthTo value2 s) state2
```

In short, we need to hide the `state` value entirely from the function so that developers cannot pass in the wrong value. Thus, we must also get rid of the `Tuple value state` notion in our function. Putting those two concepts together, we imagine syntax that looks like this:
`nextValue <- someFunction (\nextState -> stateManipulatingFunction nextState)`

This syntax...
`nextValue <- someFunction (\initialState -> stateManipulatingFunction initialState)`
... looks very similar to OO's syntax:
`var nextValue = initialState.stateManipulatingFunction();`

Another benefit: it gets rid of the boilerplate-y noise-y `Tuple`s

What would we need to change to get this syntax? This gets tricky.

First, `initialState` should now be located outside `crazyFunction` and appear in another function, `runSomeFunction`. `runSomeFunction` should pass the `initialState` value into the final composition of all the state manipulating functions:
```haskell
runSomeFunction :: forall state value.
                   (state -> Identity (Tuple value state)) ->
                   state ->
                   Tuple value state
runSomeFunction stateFunctionsComposedIntoOne initialState =
  let (Identity tuple) = stateFunctionsComposedIntoOne initialState
  in tuple

addStringLengthTo :: Int -> Int -> Tuple String Int
addStringLengthTo value state =
  let valueAsString = show value
      state3 = state + (length valueAsString)
  in Tuple (show state3) state3

-- Using our new syntax...
crazyFunction :: (state -> Identity (Tuple Int state))
crazyFunction = do
  -- Computation 1
  value1 <- someFunction (\initialState -> add1 initialState)

  -- Computation 2
  -- `bind` will produce `Tuple value2 state3`
  someFunction (\state2 -> addStringLengthTo value1 state2)
```

Second (and as the above example shows), `someFunction` must somehow return just `value` and not `Tuple value state`.

From these clues, we get this new type signature:
```haskell
someFunction :: forall state monad value.
                Monad monad =>
                (state -> Tuple value state) -> monad value
someFunction function = -- ???

runSomeFunction :: forall state value.
                   (state -> Identity (Tuple value state)) ->
                   state ->
                   Tuple value state
runSomeFunction stateFunctionsComposedIntoOne initialState =
  let (Identity tuple) = stateFunctionsComposedIntoOne initialState
  in tuple
```

It would seem that this idea is not possible. We'll reveal how in the next file. For now, we'll abstract this concept into a type class

### Abstracting the Concept into a Type Class

We want to use `someFunction` for numerous state manipulating functions on numerous data structures (e.g. `add1`, `popStack`, `replaceElemAtIndex`). This implies that we need to convert `someFunction` into a type class, so we can use `someFunction` in other situations via a type class constraint. Let's attempt to define it and call the type class `MonadState`. Its function, `state`, should be the same as `someFunction`'s type signature:
```haskell
someFunction :: forall state monad value
              . Monad monad
             => (state -> Tuple value state)
             -> monad value
someFunction function = -- ???

class MonadState ??? where
  state :: forall s m a
             .  (s -> Tuple a s )
             -> m a
```
Because we know we need `bind`, let's add a Monad constraint, `m`, to `???`:
```haskell
class (Monad m) <= MonadState m where
  state :: forall s a
             .  (s -> Tuple a s )
             -> m a
```
We need to make sure the `state` type does not change, so we'll also define a functional dependency from `m` to `s`
```haskell
class (Monad m) <= MonadState s m | m -> s where
  state :: forall a
             .  (s -> Tuple a s )
             -> m a
```

Combining this definition with its corresponding `runSomeFunction`, we get this (where `runSomeFunction` is now called `runStateFunction`)

```haskell
class (Monad m) <= MonadState s m | m -> s where
  state :: forall a. (s -> Tuple a s) -> m a

runStateFunction :: forall s a. (s -> Identity (Tuple a s)) -> s -> Tuple a s
runStateFunction stateManipulation initialState =
  let (Identity tuple) = stateManipulation initialState
  in tuple
```

Ok. Now let's see how this seemingly impossible syntax is actually possible.
