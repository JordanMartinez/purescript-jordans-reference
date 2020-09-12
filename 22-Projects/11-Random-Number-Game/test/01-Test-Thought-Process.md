# Test Thought-Process

## Overview of Our Testing Approach

Now that we've written the code to make our game work, how do we test it? Due to how we structured the code, all of our domain logic exists as a pure function. The function only becomes impure because
- the `ReaderT` monad transforms an impure monad (i.e. `Effect`/`Aff`)
- the `Free`/`Run` monad gets interpreted into an impure monad (i.e. `Effect`/`Aff`)

If we were to (ReaderT) transform or (Free/Run) be interpreted into a pure monad, such as `Identity`, our function never becomes 'impure'. Thus, we can use QuickCheck to do property testing to insure the logic adheres to our expectations/standards. (I'm not sure whether this will always work because it is easy to define standards for our example game. I don't know how well this would work in more complicated systems.)

Thus, we can test our entire game using a single pure function: "If the game logic is given X inputs, it will produce Y outputs." For this example, the X inputs are
- the instances of the newtyped `ReaderT` monad
- the final interpretation of our `Free`/`Run` monad

In the `Design Thought-Process.md` file, we saw that there were 3 capabilities we needed to implement:
- send message to user (i.e. `String -> m Unit`/`NotifyUser String a`)
- generate a random integer (i.e. `Bounds -> m Int`/`CreateRandomInt Bounds (Int -> a)`)
- get the user's input (i.e. `String -> m String`/`GetUserInput String (String -> a)`)

Since the "notify user" capability is purely informative, we do not need to implement it in our test code. Rather, we can use `pure unit` for all our approaches.

However, we will need to implement the other two. We can easily support the "generate random int" capability by providing our own `Int` value via `pure randomIntValue`.
To support the "get user's input," we need to provide a new `String` value that represents the next input value. This is where the difficulty starts to arise. Since the `nextInput` value will change each time we get the user's input, we need some form of state manipulation. Thus, here's the approach we'll take for both approaches:
- (ReaderT) we will transform a `StateT` monad, that then transforms the base monad, `Identity`.
- (Run) we will use `purescript-run`'s `Run.State` module to follow the same idea where we will `extract` the purely computated result at the end.

## Reviewing Our Game's Properties

Before we talk about using QuickCheck to generate our random data, let's review the properties we wish to uphold:
- Given that...
    - the player has defined a bounds of `B` where `B.lower < B.upper`, which implies that there are always at least two possible guesses (the lower bound and the upper bound)
    - the random number is `R` where `B.lower == R || (B.lower < R && R < B.upper) || R == B.upper`
    - the player wins on the `C`th correct guess and loses on the `I`th incorrect guess
    - the player has defined a total guess limit of `TG` where `TG <= C || TG == I`
    - the player can make the same incorrect guess multiple times.
        - This occurs when the only possible guesses are 1a) the random number, which is equal to one of the bounds' edges, and 1b) an incorrect guess, which is equal to the corresponding bounds' edge (i.e. `B.upper - B.lower == 1`), and 2) the total guesses are greater than the total possible guesses one can make `TG > (B.upper - B.lower + 1)`
- then...
  - A player should win with `(TG - C)` remaining guesses after submitting these inputs:
      - define a `B`
      - define a `TG`
      - make `(C - 1)` incorrect guesses
      - make the correct guess
  - A player should lose with the `R` random number after submitting these inputs:
      - define a `B`
      - define a `TG`
      - make `I` guesses

## Generating Our Test Data

Let's start with a top-down approach. What do we need to generate ultimately to write a QuickCheck test? We need three values (2 inputs, 1 output):
- an `Int` to represent the random number we'll use to interpret `CreateRandomInt`
- a list-like type that stores `String`s to represent all the user's inputs, which we'll use to interpret `GetUserInput`
- a `GameResult` that represents whether the player should win or lose

So, how do we generate this? It should be obvious that we cannot generate the `GameResult` until we know what the other two values are. So, we'll start with them.

### Random Number

First, let's start with the random number. How could we generate it? We could generate it by creating a random integer and then defining a lower and upper value that corresponds to that. We can also define the bounds first and then generate a random int within that bounds. Both can work, but we've opted for the second approach. Thus, we get this type:
```haskell
type MockedBounds = Tuple Int Int

genTestData :: Gen TestData
genTestData = do
  bounds <- genBounds -- we'll define this later
  random <- genRandom bounds -- we'll define this later
```

### User Inputs

Second, how do we generate the user inputs? We know that it will need to be list-like data structure that stores `String`s, so it will either be a `List String` or an `Array String`. What content should be inside of this?
The way the program works, it will request items in this order:
1. Define lower bound
2. Define upper bound
3. Define remaining guesses
4. Recursively make guess until game ends

Due to the above, we have already generated the bounds value, so let's not focus on that. However, we have not generated a value for remaining guesses. To define the remaining guesses, we just generate a positive integer
```haskell
type MockedBounds = Tuple Int Int

genTestData :: Gen TestData
genTestData = do
  bounds <- genBounds
  random <- genRandom bounds
  totalGuesses <- genPositiveInt
```

Now, we need to define the guesses. The total number should depend on two things:
1. How many guesses does the player have until the game ends? This determins the number of guesses we will generate.
1. Does the player ultimately win or lose? This determines whether we generate `totalGuesses - 1` incorrect guesses followed by the random number as a guess or whether we just generate `totalGuesses` incorrect guesses.

Thus, we need to determine whether the player wins/loses in our test data generation. This can easily be done by generating a `Maybe TotalGuesses` and then using `case _ of` to determine how to proceed from there:
- `Just takesXGuessesToWin` represents a winning state and the total guesses needed before one wins
- `Nothing` represents a losing state.

```haskell
type MockedBounds = Tuple Int Int

genTestData :: Gen TestData
genTestData = do
  bounds <- genBounds
  random <- genRandom bounds
  totalGuesses <- genPositiveInt
  gameResult <- genGameResult totalGuesses
  case gameResult of
    Just takesXGuessesToWin ->

    Nothing ->

```

At this point, we need to generate a specified number of incorrect guesses. The `Just` path should generate one less than the `takesXGuessesToWin` whereas the `Nothing` path should use `totalGuesses` to create it:
```haskell
type MockedBounds = Tuple Int Int

genTestData :: Gen TestData
genTestData = do
  bounds <- genBounds
  random <- genRandom bounds
  totalGuesses <- genPositiveInt
  gameResult <- genGameResult totalGuesses
  case gameResult of
    Just takesXGuessesToWin -> do
      incorrectGuesses <- genIncorrectGuesses (takesXGuessesToWin - 1)
    Nothing -> do
      incorrectGuesses <- genIncorrectGuesses totalGuesses
```
In the `Just` path, we should append the random number to get all of our guesses. In the `Nothing` path, we're already done.
```haskell
type MockedBounds = Tuple Int Int

genTestData :: Gen TestData
genTestData = do
  bounds <- genBounds
  random <- genRandom bounds
  totalGuesses <- genPositiveInt
  gameResult <- genGameResult totalGuesses
  case gameResult of
    Just takesXGuessesToWin -> do
      incorrectGuesses <- genIncorrectGuesses (takesXGuessesToWin - 1)
      let guesses = incorrectGuesses <> random
    Nothing -> do
      incorrectGuesses <- genIncorrectGuesses totalGuesses
```
To finish creating the user's inputs, we need to combine our `bounds.lower`, `bounds.upper`, `totalGuesses`, and `gueses` values into a `ListLike String` type. Then, we will have generated all of our user's inputs.

Now, we need to convert our `guesses` values into `ListLike String` type. We could use `List String` or `Array String`:
```haskell
type MockedBounds = Tuple Int Int
type GuessLimit = Int
type ListLike a = -- define it later
type Guesses = ListLike Int

mkUserInputs :: MockedBounds -> GuessLimit -> Guesses -> ListLike String
mkUserInputs (Tuple lower upper) total guesses =
 [show lower, show upper, show total] <> (show <$> guesses) -- array version
 (show lower : show upper : show total : Nil) <> (show <$> guesses) -- list version
```

We can now generate our test's inputs.
```haskell
type MockedBounds = Tuple Int Int

genTestData :: Gen TestData
genTestData = do
  bounds <- genBounds
  random <- genRandom bounds
  totalGuesses <- genPositiveInt
  gameResult <- genGameResult totalGuesses
  case gameResult of
    Just takesXGuessesToWin -> do
      incorrectGuesses <- genIncorrectGuesses (takesXGuessesToWin - 1)
      let guesses = incorrectGuesses <> random
      let userInputs = mkUserInputs bounds totalGuesses guesses
    Nothing -> do
      incorrectGuesses <- genIncorrectGuesses totalGuesses
      let userInputs = mkUserInputs bounds totalGuesses incorrectGuesses
```

### Game Result

Now, we just need to generate our test's output, the `GameResult`. It has two members:
- `PlayerWins RemainingGuesses`
- `PlayerLoses RandomInt`

The only way to create the types that are wrapped by `GameResult`'s members require us to use their smart constructors, which require `Either ErrorType TheTypeWeWant`. To get around that, we'll use partial functions since we can guarantee that these functions are only being passed correct values. They will follow this idea: `unsafePartial $ fromRight $ smartConstructor`. Since that is a lot of character to type, which will clutter our code and make it harder to read, we'll defined our own code for that by adding a `_` suffix to the smart constructor names:
```haskell
type MockedBounds = Tuple Int Int

genTestData :: Gen TestData
genTestData = do
  bounds <- genBounds
  random <- genRandom bounds
  totalGuesses <- genPositiveInt
  gameResult <- genGameResult totalGuesses
  case gameResult of
    Just takesXGuessesToWin -> do
      incorrectGuesses <- genIncorrectGuesses (takesXGuessesToWin - 1)
      let guesses = incorrectGuesses <> random
      let userInputs = mkUserInputs bounds totalGuesses guesses
      let gameResult = PlayerWins $ mkRemainingGuesses_ (totalGuesses - takesXGuessesToWin)
    Nothing -> do
      incorrectGuesses <- genIncorrectGuesses totalGuesses
      let userInputs = mkUserInputs bounds totalGuesses incorrectGuesses
      let gameResult = PlayerLoses $ mkRandomInt_ (mkBounds_ bounds) random

mkType_ :: NeededArgs -> TheType
mkType_ args = unsafePartial $ fromRight $ mkType args
```

### Defining its Arbitrary instance

Now, we just need to lift all the three values into a `Gen` via `pure`. Since `pure` only takes one value, we'll wrap them up using a Record:
```haskell
type TestDataRecord = { random :: Int
                      , userInputs :: ListLike String
                      , result :: GameResult
                      }
newtype TestData = TestData TestDataRecord

genTestData :: Gen TestData
genTestData = do
  bounds <- genBounds
  random <- genRandom bounds
  totalGuesses <- genPositiveInt
  gameResult <- genGameResult totalGuesses
  case gameResult of
    Just takesXGuessesToWin -> do
      incorrectGuesses <- genIncorrectGuesses (takesXGuessesToWin - 1)
      let guesses = incorrectGuesses <> random
      let userInputs = mkUserInputs bounds totalGuesses guesses
      let gameResult = PlayerWins $ mkRemainingGuesses_ (totalGuesses - takesXGuessesToWin)
      pure { random: random, userInputs: userInputs, gameResult: gameResult }
    Nothing -> do
      incorrectGuesses <- genIncorrectGuesses totalGuesses
      let userInputs = mkUserInputs bounds totalGuesses incorrectGuesses
      let gameResult = PlayerLoses $ mkRandomInt_ (mkBounds_ bounds) random
      pure { random: random, userInputs: userInputs, gameResult: gameResult }
```

Finally, to make it usable in QuickCheck, we need to define an `Arbitrary` instance for it. This is why we defined `TestData` as a newtype:
```haskell
instance tda :: Arbitrary TestData where
  arbitrary = genTestData
```
