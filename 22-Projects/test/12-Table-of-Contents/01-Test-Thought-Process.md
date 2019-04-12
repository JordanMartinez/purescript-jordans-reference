# Test Thought-Process

## Overview of Our Testing Approach

Our program's logic/behavior can be broken up into two parts:
1. The "main" business logic via the `Domain.purs` files
2. The "outsourced" logic that gets passed into the program via the `ProductionEnv` type. Specifically, I mean
    - the function that parses a file for headers
    - the renderer functions

What specifically do we need to test? Here's a few questions we could ask:
1. Are all files and directories that should be included actually included in the final output?
2. Do the files/directories always appear in the correct order? (i.e. the ReadMe.md file always appear before all other directories and files)?
3. Does the file content parser correctly parse the file for its Markdown headers?
4. Do the renderer functions correctly render the structure?

The first two focus on the "main" business logic while the second two focus on the 'outsourced' logic.

If we ignore the file hyperlink checking part (which does not affect the logic too much), this program can be defined as one simple function:
`render (parse rootDirectoryContents)`.

### The Random Number Game Approach Won't Work

Can we use the same approach that we used in the random number game test to test this program?

I don't think so.

The business logic in the random number game greatly adhered to properties. For example, a player that never makes a correct guess will always lose. Situations like that made it easy easy to determine what the expected outcome should be when we know all the player's guesses and the settings of the game.

We described the properties by which the game's logic abides. Then, we used those properties to randomly generate an output and a number of inputs. We simulated the impure code (i.e. user input via a console) in a pure way via an underlying state monad. If the program was given our randomly-generated inputs, the properties guarantee that it will produce the output we previously generated. In code:
```
runTest :: { inputs :: Array String, expectedOutput -> GameState } -> Boolean
runTest generatedData =
  (runState generatedData.inputs gameLogic) == generatedData.expectedOutput
```

If we look through the [7 patterns of property-based testing](https://fsharpforfunandprofit.com/posts/property-based-testing-2/), we'll see that our program as a whole does not abide by such properties:
- "different paths, same destination:" **No**
    - `render (parse rootDirectoryContents) /= parse (render rootDirectoryContents)`
- "there and back again:" **No**
    - `render (parse rootDirectoryContents) /= rootDirectoryContents`
- "some things never change:" **No**
    - The type of `rootDirectoryContents` is not the same as the type of the output of `render (parser rootDirectoryContents)`
- "the more things change, the more they stay the same:" **No**
    - We're not running the same function twice, so this can't apply.
- "solve a smaller problem first:" **No**
    - This approach seems to assume that each step in the recursion is the same. While our program is recursive in nature, each step in the recursio is not the same when rendering a file, a normal directory, and a top-level directory.
- "hard to prove, easy to verify:" **No**
    - Our situation is not easy to verify
- "the test oracle:" **yes, but not quite practical**
    - the program currently uses a one-pass approach (the root-to-files traversal will parse file contents while the files-to-root traversal will render that content) to produce the output.
    - I could test this against a two-pass approach (the first pass will parse the files and file system into a data structure; the second pass will render that data structure)
    - Unfortunately, I believe the one-pass approach is more understandable and easier to write than the two-pass approach.

### Decomposing Our Tests

If we cannot test the entire proram using a property-based test, how should we test this program? Which testing paradigm should we use?

Let's recall the questions we asked earlier:
1. ("main" logic) Are all files and directories that should be included actually included in the final output?
2. ("main" logic) Do the files/directories always appear in the correct order? (i.e. the ReadMe.md file always appear before all other directories and files)?
3. ("outsourced" logic) Does the file content parser correctly parse the file for its Markdown headers?
4. ("outsourced" logic) Do the renderer functions correctly render the structure?

I propose that we still use property-based testing, but change which parts of the program we test via property-testing. Thus, I propose using a 3-prong approach to fully testing our program:
1. (questions 1 & 2) test the main business logic using a state monad to simulate 'impure' code / capability type classes (e.g. `FileParser`, `Renderer`, etc.).
2. (questions 3 & 4) test the real `parser` and `renderer` functions using a variant of the "there and back again" approach.
    - `parser (stringify generatedData) == generatedData`
    - `render (parsify generatedData) == generatedData`
3. (sanity check) test the real program via a golden test on a small example

## The Main Logic Tests

We have two questions we want to answer here.
1. Are all files and directories that should be included actually included in the final output?
2. Do the files/directories always appear in the correct order? (i.e. the ReadMe.md file always appear before all other directories and files)?

How should this work?

First, all path names we'll use in our test program will be unique. By upholding this assumption, it will make it easier to test.

Second, our test monad, `TestM`, will be a state monad (to store the final output of the program) that is further augmented by the `ReaderT` monad transformer (since our program requires the `MonadAsk` type class). Whereas the production program augmented the `Env` type with `ProductionRows`, our test program will augment the `Env` type with `TestRows`.

Since the parser and renderer functions will not change between test runs, we'll implement them directly in `TestM`'s instance for their corresponding type classes rather than providing them via the `TestEnv` type and `ask`.

In code:
```purescript
type IncludedOrNot = Boolean

data FileSyStemInfo
  = DirectoryInfo FilePath IncludedOrNot
  | FileInfo FilePath IncludedOrNot (List (Tree HeaderInfo))

type TestRows = ( fileSystem :: Tree FileSystemInfo
                )
type TestEnv = Env TestRows
newtype TestM a = TestM (ReaderT TestEnv (State String) a)
```

We'll implement most of the impure code of our program via the reader monad part:
- determining the type of a "path"
- reading a "directory" for its array of children
- verifying that a "link" works

Most of the above capabilities can be defined by looking up their value that's stored in our reader monad. The below code communicates the general idea:
```purescript
-- covers `readDir`, `readPathType`, `verifyLink`
mostFunctions :: FilePath -> m resultType
mostFunctions fullFilePath = do
  fileSystem <- asks \e -> e.fileSystem
  let fileSystemLoc = fromTree fileSystem

  maybeInformation <- runMaybeT do
    let pathSegments = split (Pattern separator) fullFilePath
    lastPath <- last pathSegments
    foundLoc <- findFromRoot lastPath fileSystemLoc
    case value foundLoc of
      DirectoryInfo path includedOrNot ->
        -- path was a directory. Do something with it.
      FileInfo path includedOrNot headers ->
        -- path was a file. Do something with it.
  pure $ fromMaybe defaultValue maybeInformation
  -- or use the unsafe partial version to crash our test if it was
  -- implemented incorrectly
  -- pure $ unsafePartial $ fromJust maybeInformation
```

We'll handle the "write output to file" part using the state monad:
```purescript
writeToFile :: String -> m Unit
writeToFile content = do
  put content
```

Third, we'll use very simplistic `readFile` and `parser` functions. `readFile` will return an empty string and `parseFile` will return an empty list.

Fourth, the `render` functions will only render each path name (top-level directories, normal directories, and files) on a single line, making it easy to parse that output later.

Lastly, we'll test whether the program works correctly (answers question 1 & 2) by wrapping the 'program' logic in another monadic computation sequence. Since our program's logic (`program`) is itself a pure function when our base monad is a pure monad (i.e. `Identity` or `Trampoline`), we can compose it with other pure functions to make a final pure monadic function. In code:
```purescript
theTest :: forall m.
           Monad m =>
           -- capabilities that `program` requires,
           -- which are implemented via the ReaderT part
           MonadAsk Env m =>
           Logger m =>
           ReadPath m =>
           VerifyLink m =>

           -- Monad state that simulates impure code
           MonadState String m =>
           WriteToFile m =>

           -- Since the `m` here is a pure monad
           -- (i.e. either `Identity` or `Trampoline`),
           -- this is the same as returning 'Boolean',
           -- which indicates whether this test passed or not
           m String
theTest = do
  -- run the program, which will "write" its output into the state monad
  program
  -- get the final output
  gets (\state -> state.content)
```

Using the above approach, we can now answer the above two questions:

> Are all files and directories that should be included actually included in the final output?
> Do the files/directories always appear in the correct order? (i.e. the ReadMe.md file always appear before all other directories and files)?

Yes if
- the render function puts each path name on its own line
- we parse the output file to get those path names and convert them into a list of paths
- we verify that each element in that list is inside of the original list of path names and their items appear in the same order

In code:
```purescript
quickCheckTest :: ?ToBeDetermined -> Boolean
quickCheckTest generatedData =
    -- check whether the contents of the two lists are the same
    -- (same size, same items, same order).
    outputtedList == generatedData.expectedPathList
  where
    -- run the program using our TestM monad
    programRun = runState "" (runReaderT generatedData.env theTest)

    -- get the output file's content
    outputFile =
      -- pattern match to expose the content value
      let (Tuple state content) = programRun
      -- return that content value
      in content

    -- "parse" that output file into a list of path names
    outputtedList = split (Pattern "\n") outputFile
```

### Generating Data for the Main Tests

TODO: need to figure out best way to do this...

Thus, the state type we'd use for our `TestM` monad might look like this:
```purescript
data ContentType
  = File String
  | Dir (Array String)

type TestData = { pathMap :: Map String ContentType
                , output :: String
                , linkMap :: Map WebUrl Boolean
                }

newtype TestM = ReaderT Env (State TestData)
```

To generate our data for the above, we'd need to generate a fake file system:
```purescript
genTestData :: Gen TestData
genTestData = do
  topLevelNames <- genUniquePathNames
  topLevelDirsOrFiles <- for topLevelNames \name -> do
    pathType <- leftOrRight
    case pathType of
      Left -> File name
    (choose 0 1) <#> (\oneOrZero ->
      case oneOrZero of
        0 -> File name
        1 -> Dir name
    )


  pure { fileMap: fileMap
       , dirMap: dirMap
       , content: ""
       , linkMap: linkMap
       }

```

## The "Outsourced" Logic Tests

In this phase, we wish to answer these questions:
3. Does the file content parser correctly parse the file for its Markdown headers?
4. Do the renderer functions correctly render the structure?

We've already proposed how we should property-test these:
- `parser (stringify generatedData) == generatedData`
- `render (parsify generatedData) == generatedData`

Property-testing the `parser` function won't be difficult because the `stringify` function should be straightforward.

Property-testing the `render` function will be more challenging because `parsirfy` will be harder to implement.

### Generating Our Test Data

## The Golden Test

After these tests pass, we can then run a golden test (i.e. unit test) to verify that our program (using impure effects) works correctly on a very small example.

## Generating Our Test Data

Let's start with a top-down approach. What do we need to generate ultimately to write a QuickCheck test? We need three values (2 inputs, 1 output):
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
