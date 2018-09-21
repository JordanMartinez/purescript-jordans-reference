# Defining Modular Monads

We can now return to the original question we raised at the start of the `Free` folder: if we wanted to run a sequential computation (i.e. use a monad) that used multiple effects (e.g. different monads whose `bind` do different things), could we stop fighting against "`bind` returns the same monad type" fact and simply use just one monad? Yes. Similar to our previous examples, we can use `Coproduct`s/`VariantF`s of two or more `Free` monads.

## Getting Around The Non-Free-Monad Limitation

Unfortunately, this `Coproduct` + `Free` approach only works on `Free` monads; it does not work for other non-`Free` monads. So, how do we get around that limitation?

As the paper says, the List and State monads are not free monads. To get around that problem, we can define a language (similar to our `Add`, `Multiply`, `Value` language) that provides the operations we would expect from such a monad. The paper's example shows how one could create a State monad using this approach. Since it will follow much of what we have already covered before, we'll just show the Purescript version of their code.
```purescript
data Add      theRestOfTheComputation = Add Int theRestOfTheComputation
data GetValue theRestOfTheComputation = GetValue (Int -> theRestOfTheComputation)

-- Why the `a` type is `Pure` will become clear
-- in the next section where we define the
-- `Exec` type class instances
add :: forall f. Int -> Free f Unit
add i = liftF $ Add i (Pure unit)

getValue :: forall f. Free f Int
getValue = liftF $ GetValue Pure

-- The `Free` monad's equivalent of `State StateType OutputType`
-- simulates "y = get(x); set(x, x + 1); return y;"
stateComputation :: Free (Coproduct Add1 GetValue) Int
stateComputation = do
  y <- getValue
  add 1
  pure y

foldFree :: Functor f => (a -> b) -> (f b -> b) -> Free f a -> b
foldFree pure _ (Pure x) = pure x
foldFree pure impure (Impure t) = impure (fmap (foldFree pure impure) t)

newtype Memory = Memory Int

class Functor f =>  Run f where
  runAlgebra :: f (Memory -> Tuple a Memory) -> (Memory -> Tuple a Memory)

instance i :: Run Add where
  runAlgebra (Add amount restOfComputation) (Memory i) =
    restOfComputation (Memory (i + amount))
instance r :: Run GetValue where
  runAlgebra (GetValue intToRestOfComputation) (Memory i) =
    (intToRestOfComputation i) (Memory i)

instance e :: (Run f, Run g) => Run (Either f g) where
  runAlgebra (Left r) = runAlgebra r
  runAlgebra (Right r) = runAlgebra r

instance c :: (Run f, Run g) => Run (Coproduct f g) where
  runAlgebra (Coproduct either) = runAlgebra either

run :: Run f => Free f a -> Memory -> Tuple a Memory
run =
--          Pure               Impure     computation  initialState
  foldFree (\a b -> Tuple a b) runAlgebra

{- In the REPL
> run stateComputation (Memory 4)
(4, Memory 5)
-}
```
Why is this useful? Because it guarantees that a computation as modeled by the `Free` monad, based on the types (e.g. the operations) in its `Coproduct`, will only do specific computations (e.g. read data) and not others (e.g. overwrite data).

## Interpreting Free Monads

When we look at how to define an instance for a data type, it follows this pattern (written in meta-language):
```purescript
data OperationName theRestOfTheComputation
  = Function_No_Arg theRestOfTheComputation

  -- Arg is known by Function
  | Function_1_Arg Arg theRestOfTheComputation
  | Function_2_Args Arg Arg theRestOfTheComputation

  -- `Value` is provided by the initial `run` or a previous computation
  | Get_1_Value (Value -> theRestOfTheComputation)
  | Get_2_Values (Value1 -> Value2 -> theRestOfTheComputation)

  -- Use both
  | Function_With_Getter Arg (Value -> theRestOfTheComputation)
```
So far, we've only defined a data type with one instance and composed those data types together. However, what if we treated a data type as a "family" of operations where each instance in that data type was an operation? Then our data types might look like this:
```purescript
data FileSystem a
  = ReadFromFile FilePath (String -> a)
  | WriteToFile FilePath String a

data ConsoleIO a
  = ReadFromConsole (String -> a)
  | WriteToConsole String a
  -- This isn't needed, but it will show below how code is usually written
  -- via do notation when either one of these argument types is used
  | WriteThenRead String (String -> a)
```
Using these data structure, we can "interpret" these non-runnable pure programs into an equivalent runnable impure program (e.g. `Effect`). Assuming these functions exist...
```purescript
consoleRead :: Effect String

consoleWrite :: String -> Effect Unit

readFromFile :: FilePath -> Effect String

writeToFile :: FilePath -> String -> Effect Unit
```
... we could take our "description" of computations (e.g. `Free ConsoleIO a`) and "interpret" it into an `Effect` monad:
```purescript
class Functor f => Exec f where                                      {-
  execAlgebra :: f (Effect a) -> Effect a                            -}
  execAlgebra :: f  Effect    ~> Effect

instance Exec ConsoleIO where
  execAlgebra (ReadFromConsole reply) = do
    -- use the `bind` output from `consoleRead` and pass it into `reply`
    -- which will lift the result back into a `Free (Coproduct ...) a`
    -- which will be lifted into the Monadic type via `pure`.
    -- At a later time in the `fold` process,
    -- the `Free (Coproduct ...) a` will be evaluated again
    -- using `fold execAlgebra expression`,
    -- which will start this loop all over again
    -- until the final output is reached
    result <- consoleRead
    pure (reply result)
  execAlgebra (WriteToConsole msg remainingComputation) = do
    consoleWrite msg
    pure remainingComputation
  execAlgebra (WriteThenRead msg reply) = do
    consoleWrite msg
    input <- consoleRead
    pure (reply input)

{- our "run" function but using the `execAlgebra`
exec :: Exec f => Free f a -> Effect a                          -}
exec :: Exec f => Free f   ~> Effect
exec = foldFree pure execAlgebra

-- assuming we have smart constructors for each of our data types
writeToConsole :: forall f. String -> Free f Unit
writeToConsole msg = liftF $ WriteToConsole msg

-- we exclude FileSystem from this computation
consoleComputation :: Free ConsoleIO a
consoleComputation = do
  writeToConsole "What is your name?"
  name <- readFromConsole
  writeToConsole $ "You wrote" <> name
  writeToConsole "Now exiting."

{-
If this could be run in the REPL, it might look like this:
> exec consoleComputation
What is your name?
[User inputs 'mike']
You wrote mike
Now exiting.
-}
```

## From `Free` to `Run`

If you recall in `ADT8.purs`, `xgromxx` mentions [`purescript-run`](https://pursuit.purescript.org/packages/purescript-run/2.0.0). (The ReadMe of this library provides an overview of the ideas we've explained here.)

The library provides the same functionality as `Free` in `purescript-free` with one advantage. Whereas `Free` is vulnerable to stack overflows, `purescript-run` can lessen the possibility of stack overflows or completely guarantee stack-safety. Thus, it should be used instead of `Free`. **See the "Stack-Safety" section at the bottom of the project's ReadMe.**
