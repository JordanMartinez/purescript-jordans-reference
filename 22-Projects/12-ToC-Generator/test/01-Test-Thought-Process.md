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
```haskell
type TestRows = ( {- Undefined for now, but these will include other things -}
                )
type TestEnv = Env TestRows
newtype TestM a = TestM (ReaderT TestEnv (State String) a)
```

We'll implement most of the impure code of our program via the reader monad part:
- determining the type of a "path"
- reading a "directory" for its array of children
- verifying that a "link" works

Most of the above capabilities can be defined by looking up their value that's stored in our reader monad. The below code communicates the general idea:
```haskell
-- covers `readDir`, `readPathType`, `verifyLink`
mostFunctions :: FilePath -> m resultType
mostFunctions fullFilePath = do
    fileSystem <- asks \env -> env.fileSystem
    let fileSystemLoc = fromTree fileSystem
    let maybeInfoWeNeed = getInformation fileSystemLoc

    pure $ case maybeInfoWeNeed of
      Just info -> info
      Nothing -> unsafeCrashWith "Problem in our generator. Expectations not met."
  where
    getInformation :: Loc FileSystemInfo -> Maybe InformationWeNeed
    getInformation fileSystemLoc = do
      let pathSegments = split (Pattern separator) fullFilePath
      lastPath <- last pathSegments
      foundLoc <- findFromRoot lastPath fileSystemLoc
      case value foundLoc of
        DirectoryInfo path includedOrNot ->
          -- path was a directory. Do something with it.
        FileInfo path includedOrNot headers verifiedOrNot ->
          -- path was a file. Do something with it.
```

We'll handle the "write output to file" part using the state monad:
```haskell
writeToFile :: String -> m Unit
writeToFile content = do
  put content
```

Third, we'll use very simplistic `readFile` and `parser` functions. `readFile` will return an empty string and `parseFile` will return an empty list.

Fourth, the `render` functions will only render each path name (top-level directories, normal directories, and files) on a single line, making it easy to parse that output later.

Using the above approach, we can now answer the above two questions...

> Are all files and directories that should be included actually included in the final output?
> Do the files/directories always appear in the correct order? (i.e. the ReadMe.md file always appear before all other directories and files)?

... using the below quick check test:
```haskell
quickCheckTest :: ToCTestData -> Boolean
quickCheckTest (ToCTestData generatedData) =
    -- check whether the contents of the two renderings are the same
    outputtedFile == generatedData.expectedOutput
  where
    -- run the program using our TestM monad (ReaderT) / pure interpreters (Run)
    outputtedFile = fst $ runState (runReaderT generatedData.env program) ""
```

### Generating Data for the Main Tests

Most of the data we'll need to generate is the fake file system, which has a tree-like structure. However, the `Tree` we've used for storing headers isn't the best type to use for this situation. When storing headers, the branch and leaf types are the same. In a file system, the branch types are always directories and the leaves are always file types.

Ideally, we'd want a tree type whose definition looks like this:
```haskell
data Tree branch leaf
  = Leaf leaf
  | Branch branch (Tree branch leaf)
```

AFAIK, there isn't a library written in PureScript with this definition that also includes a Zipper (i.e. `Tree`'s `Loc` type). I'm not going to write one for this task because I can workaround `Tree`'s design to make it work for here.

We'll need to store different data depending on whether the path is a directory or file. Since we're using `Tree`, we'll merge both file and directory types into one. While we may not use all of the data, the following should be future-proof:
```haskell
-- whether this path should be included or not
type IncludedOrNot = Boolean

-- whether the url for this path will return an HTTP OK code or not
type VerifiedOrNot = Boolean

data FileSyStemInfo
  = DirectoryInfo FilePath IncludedOrNot
  | FileInfo FilePath IncludedOrNot (List (Tree HeaderInfo)) VerifiedOrNot
```

When generating our file system, there's one requirement we must uphold: a directory that should be included must always have at least one child path that should also be included (whether this is a file or another directory). However, to make it realistic, this directory might sometimes have a path (file or directory) that should not be included.

Lastly, to prevent the generated file system from being too massive, we'll limit the depth of the file system, so that a directory that is one level above that maximum depth stores only files (included or not).

**At this point, you should check out the `Main Logic` folder's contents to see how these tests were implemented.**

At this point, the sorting question (Question 2) is not yet answered. I'm not quite sure how I should test it, partly because it feels like I'm just testing whether the `sort` function works or not (pointless to do) and partly because I'm not sure how this should affect other parts of the test (specifically, how the fake and simple `render` function can still produce the same output) and the fake file system generation.

Moreover, this doesn't yet test how things are handled when a file's corresponding URL couldn't be verified. Perhaps, you, the reader, can build upon what I've written thus far and add a test for it.

## The "Outsourced" Logic Tests

In this phase, we wish to answer these questions:
3. Does the file content parser correctly parse the file for its Markdown headers?
4. Do the renderer functions correctly render the structure?

We've already proposed how we should property-test these:
- `parser (stringify generatedData) == generatedData`
- `render (parsify generatedData) == generatedData`

Property-testing the `parser` function won't be difficult because the `stringify` function should be straightforward.

Property-testing the `render` function will be more challenging because `parsify` will be harder to implement.

### Generating Our Test Data

TODO: This is still a WIP

## The Golden Test

After these tests pass, we can then run a golden test (i.e. unit test) to verify that our program (using impure effects) works correctly on a very small example.

## Generating Our Test Data

TODO: This is still a WIP
