# Defining Modular Monads

**This file has two sections. The first only makes more sense after reading the second. So, be sure to read this file twice.**

We can now return to the original question we raised at the start of the `Free` folder: if we wanted to run a sequential computation (i.e. use a monad) that used multiple effects, could we stop fighting against the "`bind` returns the same monad type it receives" restriction and simply use just one monad? Yes. Similar to our previous examples, we can use `Coproduct`s of two or more `Free` monads.

## Getting Around The Non-Free-Monad Limitation

Unfortunately, this `Coproduct` + `Free` approach only works on `Free` monads; it does not work for other non-`Free` monads. As the paper says, the `ListT` and `StateT` monads are not free monads. Why? Let's consider the `StateT` monad. The issue at hand are its laws. If I call `set 4` and then later call `get`, `get` should return `4`. By using `Free` as we have so far, we cannot uphold that law.

So, how do we get around that limitation? We can define a type that has an instance for `Functor` and whose values represent terms in a language (similar to our `Add`, `Multiply`, `Value` language) that provides the operations we would expect from such a monad. The paper's example shows how one could create a `State` monad using this approach. Since it will follow much of what we have already covered before, we'll just show the Purescript version of their code.
```haskell
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
-- simulates "function(x) => {
--    var y = get(x);
--    set(x, x + 1);
--    return y;
-- }"
stateComputation :: Free (Coproduct Add1 GetValue) Int
stateComputation = do
  y <- getValue
  add 1
  pure y

-- Computes the pure description of machine instructions
-- that are stored via `Free f a` down into `b`
-- using the provided functions
foldFree :: Functor f => (a -> b) -> (f b -> b) -> Free f a -> b
foldFree pure _ (Pure x) = pure x
foldFree pure impure (Impure t) = impure (fmap (foldFree pure impure) t)

newtype Memory = Memory Int

class Functor f => Free f where
  runAlgebra :: f (Memory -> Tuple a Memory) -> (Memory -> Tuple a Memory)

instance Free Add where
  runAlgebra (Add amount restOfComputation) (Memory i) =
    restOfComputation (Memory (i + amount))
instance Free GetValue where
  runAlgebra (GetValue intToRestOfComputation) (Memory i) =
    (intToRestOfComputation i) (Memory i)

instance (Functor f, Functor g) => Free (Either f g) where
  runAlgebra (Left r) = runAlgebra r
  runAlgebra (Right r) = runAlgebra r

instance (Functor f, Functor g) => Free (Coproduct f g) where
  runAlgebra (Coproduct either) = runAlgebra either

run :: Functor f => Free f a -> Memory -> Tuple a Memory
run =
--          Pure               Impure     computation  initialState
  foldFree (\a b -> Tuple a b) runAlgebra

{- In the REPL
> run stateComputation (Memory 4)
(4, Memory 5)
-}
```

## Modular Effects via Languages

When we learned about the `ReaderT` design pattern, we saw that it simply "links" the capabilities we need to run a pure computation with its impure implementations (the type class' instances). As we will show later, this makes it much easier to test our "business logic."

Similarly, the `Free` monad is the thing which "links" some capability needed in a pure computation with its impure implementation. Whereas `ReaderT` used "capability type classes," `Free` using "languages" like the state manipulation language, `Add`/`GetValue`, demonstrated in the previous section. Thus, we can easily add new "effects" to our `Free` monad by adding more "languages."

Whereas the `ReaderT` design pattern would use type class instances to implement these capabilities, a `Free` monad will use an interpreter. An interpreter can be a few different hings:
- the actual machine code layer that runs the computation in `Effect`/`Aff`
- a pure computation (used for testing) that runs in `Identity`
- something that pretty prints the instructions the computer would execute

## Defining and Interpreting Languages for the Free Monad

When we look at how to define a language data type for the `Free` monad, it follows this pattern (written in meta-language):
```haskell
data Language theRestOfTheComputation
  -- Statement that tells interpreter to do something but
  -- doesn't pass down any arguments into the interpreter
  -- or receive any values from the interpreter
  = Function_No_Arg theRestOfTheComputation

  -- Arg is known by Function and passed down to the interpreter
  | Function_1_Arg Arg_Passed_to_Interpreter theRestOfTheComputation
  | Function_2_Args Arg1 Arg2 theRestOfTheComputation

  -- `Value` is provided by the interpreter
  -- when it finishes interpreting the language
  | Get_1_Value (Value_Provided_By_Interpreter -> theRestOfTheComputation)
  | Get_2_Values (Value1 -> Value2 -> theRestOfTheComputation)

  -- Use both
  | Function_With_Getter Arg_Passed_to_Interpreter (Value_Provided_By_Interpreter -> theRestOfTheComputation)
```
So far, we've only defined a data type with one value and composed those data types together. However, what if we treated a data type as a "family" of operations where each value in that data type was an operation? Then our data types might look like this:
```haskell
-- A "language" that supports the capabilities of reading from
-- a file and writing to a file
data FileSystem a
  = ReadFromFile FilePath (ContentsOfFile -> a)
  | WriteToFile FilePath NewContents a

-- A "language" that supports the capabilities of reading from
-- the console and writing to the console
data ConsoleIO a
  = ReadFromConsole (String -> a)
  | WriteToConsole String a
  -- This shouldn't be here, but it will show below how code is usually written
  -- via do notation when either one of these argument types is used
  | WriteThenRead String (String -> a)
```
Using these data structure, we can "interpret" these non-runnable pure programs into an equivalent runnable impure program (e.g. `Effect`). Assuming these functions exist...
```haskell
consoleRead :: Effect String

consoleWrite :: String -> Effect Unit

readFromFile :: FilePath -> Effect String

writeToFile :: FilePath -> String -> Effect Unit
```
... we could take our pure "description" of computations (e.g. `Free ConsoleIO a`) and "interpret" it into an impure `Effect` monad:
```haskell
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

## Example

Thus, say we had a program that needed a number of capabilities:
- read/write to the console
- random number generation
- gets current date/time

That program might look something like this:
```haskell
type Message = String
type Prompt = String
type UserInput = String

-- first language family
data ConsoleIO a
  = WriteToConsole Message a
  | ReadFromConsole Prompt (UserInput -> a)

-- second language family
data RandomNumber a
  = GenerateRandomNumber (Int -> a)

-- Third language family
data DateTime a
  = GetCurrentDateTime (DateTime -> a)

-- We could compose these languages/capabilities together via Coproduct
type Language = Coproduct3 ConsoleIO RandomNumber DateTime
type Program = Free Language

-- We can then define a pure computation using our Free monad
        -- Free (Coproduct3 ConsoleIO RandomNumber DateTime) output
program :: Program output
program = do
  -- imagine we defined smart constructors for each language and term above
  dateTime <- getCurrentDateTime
  writeToConsole $ show dateTime <> ": Input your name:"
  name <- readFromConsole "My name: "
  random <- generateRandomNumber
  let encryptedName = encryptNameWith name random
  dateTime' <- getCurrentDateTime
  writeToConsole $ show dateTime' <> ": Your encrypted name is: " <> encryptedName
  pure encryptedName

-- which does not become "impure" until it's actually interpreted
runProgram :: Effect Unit
runProgram = foldFree go program

  -- pseudo-code below!
  where
  go :: Language ~> Effect
  go =
    coproduct3
      (\WriteToConsole msg next) -> do
        Console.log msg
        pure next
      (\ReadFromConsole prompt reply) -> do
        response <- Console.read prompt
        pure (reply response)
      -- etc.
```
