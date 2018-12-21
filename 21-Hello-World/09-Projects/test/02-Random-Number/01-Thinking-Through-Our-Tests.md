# Random Number Test

Now that we've written the code to make our game work, how do we test it? The language of the game itself (Core) can be translated/interpreted into a lower-level but still pure language (API). It is the translation from API to Infrastructure where we introduce impurity into our code via `Effect`/`Aff`. Because everything from the API level and up is technically a pure function, we can test it using QuickCheck to do conformance testing. However, the impure Infrastructure-level of our code can only be tested using unit tests.

As such, we need to translate the API langauge into a pure computation that can be evaluated. Once we do that, we can randomly generate a record that represents this idea: "If the program is given X inputs, it will produce Y outputs." For this example, the X inputs are what is needed to "translate"/"interpret" the API langauge into a pure computation and the Y output is the game result those inputs should produce.

The API language has 3 terms that need to be interprted:
- Log String a
- CreateRandomInt Bounds (Int -> a)
- GetUserInput String (String -> a)

We can ignore the `Log` term because it will not change the result of our computation. We will need to interpret the other two. For the `CreateRandomInt` term, we need to provide a read-only `Int` value as our random number. This idea adheres to the Reader monad transformer, of which `purescript-run` provides a version via its `Run.Reader` module. For the `GetUserInput` term, we need to provide a new `String` value that represents the next input value. Since the `nextInput` value will change each time we evaluate `GetUserInput`, we need state manipulation. Again `purescript-run` provides a version of the State monad transformer via its `Run.State` module.

As such, we'll need to do three things:
1. Translate the API language into a `Run` object that has both `READER` and `STATE` rows
2. Run the `READER` and `STATE` rows with our specified random number and the "user's inputs". This computation will produce a `Run` with an empty row (e.g. `Run () output`)
3. Extract the final output using `extract`, similar to what we did when we first introduced `purescript-run`

We'll use QuickCheck's generators to generate the 2 input values and 1 expected output value. Here is where we can define the "standards" to which we expect our code to adhere:
- Given that...
    - the player has defined a bounds of `B` where `B.lower < B.upper`, which implies that there are always at least two possible guesses (the lower bound and the upper bound)
    - the random number is `R` where `B.lower == R || (B.lower < R && R < B.upper) || R == B.upper`
    - the player wins on the `G`th guess and loses on the `I`th incorrect guess
    - the player has defined a total guess limit of `C` where `C <= G || C == I`
    - the player can make the same incorrect guess multiple times.
        - This occurs when the only possible guesses are 1a) the random number, which is equal to one of the bounds' edges, and 1b) an incorrect guess, which is equal to the corresponding bounds' edge (i.e. `B.upper - B.lower == 1`), and 2) the total guesses are greater than the total possible guesses one can make `C > (B.upper - B.lower + 1)`
- then...
  - A player should win with `(C - G)` remaining guesses after submitting these inputs:
      - define a `B`
      - define a `C`
      - make `(G - 1)` incorrect guesses
      - make the correct guess
  - A player should lose with the `R` random number after submitting these inputs:
      - define a `B`
      - define a `C`
      - make `I` guesses

## Generating Our Test Data

Let's start with a top-down approach. What do we need to generate ultimately to write a QuickCheck test? We need three values:
- an `Int` to represent the random number we'll use to interpret `CreateRandomInt`
- a list-like type that stores `String`s to represent all the user's inputs, which we'll use to interpret `GetUserInput`
- a `GameResult` that represents whether the player should win or lose

So, how do we generate this? It should be obvious that we cannot generate the `GameResult` until we know what the other two values are. So, we'll start with them.

### Random Number

First, let's start with the random number. How could we generate it? We could generate it by creating a random integer and then defining a lower and upper value that corresponds to that. We can also define the bounds first and then generate a random int within that bounds. Both can work, but we've opted for the second approach. Thus, we get this type:
```purescript
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
```purescript
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

```purescript
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
```purescript
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
```purescript
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
```purescript
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
```purescript
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
```purescript
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
```purescript
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
```purescript
instance tda :: Arbitrary TestData where
  arbitrary = genTestData
```
