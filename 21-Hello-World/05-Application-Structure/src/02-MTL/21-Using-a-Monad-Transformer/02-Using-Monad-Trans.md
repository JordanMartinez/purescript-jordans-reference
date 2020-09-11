# Using MonadTrans

When we wrote code for our `MonadState` example, we had something that looked like this:
```haskell
type Output = Int
type StateType = Int
computation :: State StateType Output
computation = do
  modify_ (_ + 1)
  modify_ (_ * 10)
  modify_ (_ + 1)

main :: Effect Unit
main = case runState computation 0 of
  Tuple output state -> do
    log $ "Result of computation: " <> show output
    log $ "End state of computation: " <> show state
```
The above code works because we're using `MonadState` behind the scenes via `StateT`'s instance. However, this function's type signature restricts us to only using `StateT` for computations. If we want to define `computation`, so that it can use functions from `MonadWriter`, we'll need to use a different approach. Let's fix this one step at a time.

First, we'll abstract our `State` type into `MonadState` by using a type constraint:
```haskell
type Output = Int
type StateType = Int
computation :: forall m => MonadState StateType m => m Output
computation = do
  modify_ (_ + 1)
  modify_ (_ * 10)
  modify_ (_ + 1)

-- use a helper function to tell the type inferer that
-- `computation`'s `m` type is `StateT`
runProgram :: State StateType Output -> Tuple Output StateType
runProgram s = runState s 0

main :: Effect Unit
main = case runProgram computation of
  Tuple string state -> do
    log $ "Result of computation: " <> string
    log $ "End state of computation: " <> show state
```

Second, we'll add another type class constraint for `MonadAsk` to expose it's `tell` function:
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
```
Great! We now have a single computation that can do both state manipulation and use `tell`. However, how does that affect `runProgram`?
```haskell
runProgram :: StateT_and_WriterT -> StateT_and_WriterT_Output
runProgram s = -- ???
```

When we used a monad (e.g. `WriterT`) to run a computation, we didn't need to specify the monad type being used. So, we used `Identity` as a placeholder monad and used the type alias, `Writer`, to make it easier to write. To use another computational monad (e.g. `StateT`) inside of `Writer`, we now need to specify what that monad is by re-exposing the `T` part of `WriterT` and replacing `Identity` with `StateT`. Putting it differently, `WriterT` is now transforming the monad, `StateT` with additional effects, which is likewise transforming the base monad, `Identity` with additional effects:
```haskell
-- simple writer computation
writer :: Writer NonOutputData Output -> Tuple NonOuputData Output
writer w = runWriter w

-- re-expose the T part of WriterT
writer :: WriterT NonOutputData Identity Output -> Tuple NonOuputData Output
writer w = runWriter w

-- swap `Identity` with a type alias called Computation
type Computation = Identity
writer :: WriterT NonOutputData Computation Output -> Tuple NonOuputData Output
writer w = runWriterT w

-- Since the types will get long soon, break up the type signature
type Computation = Identity
writer :: WriterT NonOutputData Computation Output
       -> Tuple NonOuputData Output
writer w = runWriterT w

-- StateT with its T exposed but set to Identity still
state :: StateT State Identity Output -> Tuple Output State
state s = runState s initialState

-- re-alias Computation to StateT
-- and use `runWriterT` instead of `runWriter`
type Computation = StateT State Identity Output
writer :: WriterT NonOutputData Computation Output
       -> Tuple NonOuputData Output
writer w = runWriterT w

-- getting rid of the type alias and inlining its type
-- and rename the function's name to 'runProgram'
runProgram :: WriterT NonOutputData (StateT State Identity stateOutput) Output
           -> finalOutput
runProgram ws = ???

-- Realizing that `StateT` with all three of its types specified
-- now has kind "Type" and is thus no longer a monad ("Type -> Type"),
-- we remove the `stateOutput` type to increase
-- StateT's kind from "Type" to "Type -> Type", making it a monad again
-- so that it satisfies WriterT's monadic type requirement
runProgram :: WriterT NonOutputData (StateT State Identity) Output
           -> finalOutput
runProgram ws = ???

-- To run StateT, we also need an `initialState` argument. Let's add it
runProgram :: WriterT NonOutputData (StateT State Identity) Output
           -> State
           -> finalOutput
runProgram ws initialState = ???
```
A few questions arise as we do this:
1. What should `finalOutput`'s type be if we combine the two monad transformers together?
2. How should `program`'s body be implemented?

The types give us a few clues for a top-down explanation. First (answering question 2), we realize that `State`'s monad type is still `Identity` since no other monad type is inside of `StateT`. Thus, we know that we'll need to use `runState` to unpack its results. Using this line of reasoning, we'll also need to use `runWriterT` instead of `runWriter` because the `WriterT` type is using a non-`Identity` monad.

That leaves us with two possible options:
- `runWriterT (runState ws initialState)`
- `runState (runWriterT ws) initialState`

Second (answering question 1), we know that running a `StateT` returns `Tuple stateOutput state` and running a `WriterT` returns `Tuple writerOutput nonOutputData`. That means we'll likely get something close to one of these options:
1. Both outputs are returned using a Tuple that groups them together:
    - `Tuple (Tuple stateOutput state) (Tuple writerOutput nonOutputData)` (or vice versa in its order)
2. The output of one monad is the `stateOutput` (a) or `writerOutput` (b) of the other:
    - a: `Tuple (Tuple writerOutput nonOutputData) state`
    - b: `Tuple (Tuple stateOutput  state        ) nonOutputData`

Since we're running one monad inside of another, the second option seems more likely.

The question is, which one is correct?

Let's continue by examining `runStateT`/`runState` and `runWriterT`/`runWriter`. We know that `runMonad` is just a wrapper around `runMonadT` when the monad is `Identity`:
```haskell
newtype StateT s m a =
  StateT (s -> m (Tuple a s))

runState :: StateT state Identity output -> state -> Tuple output state
runState s initialState = unwrapIdentity $ runStateT s initialState

runStateT :: StateT state monad output -> state -> monad Tuple output state
runStateT (StateT function) initialState = function initialState

newtype WriterT w m a =
  WriterT (m (Tuple a w))

runWriter :: WriterT nonOutputData Identity output -> Tuple output nonOutputData
runWriter w = unwrapIdentity $ runWriterT w

runWriterT :: WriterT nonOutputData monad output -> monad Tuple output nonOutputData
runWriterT w = w
```
They key takeaway here is that `run[Monad]T` returns the same monad that is specified in `[Monad]T`. Looking at our function again...
```haskell
runProgram :: WriterT NonOutputData (StateT State Identity) Output
           -> State
           -> finalOutput
runProgram ws initialState = ???
```
... running the `WriterT NonOuputData monad output` via `runWriterT` will return its `monad` type. Since that monad type is `StateT State Identity Output`, we will take the output of running `WriterT` (which outputs a `StateT`) and run the output via `runState` since `StateT`'s monad type is `Identity`:
```haskell
runProgram :: WriterT NonOutputData (StateT State Identity) Output
           -> finalOutput
runProgram ws = runState (runWriterT ws) initialState
```
That answers the second question (how to implement `runProgram`), but it still leaves us wondering what `finalOutput` is. This is easier to determine if we just look at `runState` and `runWriterT` again:
```haskell
runWriterT :: WriterT nonOutputData monad output -> monad Tuple output nonOutputData

-- reducing `monad Tuple output nonOutputData` to something easier, `m a`
type A = Tuple output nonOutputData
runWriterT :: WriterT nonOutputData monad output -> monad A

-- specializing `monad` to `StateT State identity`
type A = Tuple output nonOutputData
runWriterT :: WriterT nonOutputData (StateT state Identity) output
           -> (StateT state Identity A)

-- re-exposing the `a` in `StateT`
runWriterT :: WriterT nonOutputData (StateT state Identity) output
           -> (StateT state Identity (Tuple output nonOutputData))

-- Looking at what `runState` returns, we see
runState :: StateT state Identity output -> state -> Tuple output state

-- Replacing StateT's `output` type with `Tuple output NonOuputData`
-- we get this:
runState :: StateT state Identity (Tuple writerOutput nonOutputData)
         -> state
         -> Tuple (Tuple writerOutput nonOutputData) state

-- Thus, runProgram's type signature is:
runProgram :: WriterT NonOutputData (StateT State Identity Output) Output
           -> State
           -> Tuple (Tuple output NonOuputData) State
runProgram ws initialState =
  runState (runWriterT ws) initialState

-- hidng `StateT`'s monad type, `Identity`, gets us this:
runProgram :: WriterT NonOutputData (State state) Output
           -> state
           -> Tuple (Tuple Output NonOuputData) state
runProgram ws initialState =
  runState (runWriterT ws) initialState
```

## Reordering the Monad Stack

What happens, however, if we flip the order of the stack? We'll see that the arguments get flipped and the output gets flipped.
```haskell
runProgram :: StateT state (Writer NonOutputData) Output
           -> state
           -> Tuple (Tuple Output state) NonOuputData
runProgram computation initialState =
  runWriter (runStateT computation initialState)
```

While the computation's definition did not change, how the code gets run does change.

This creates one problem with "monad stacks:" the order of how the monad transformers are run can change how the computation is evaluated. We'll cover this in more detail later.
