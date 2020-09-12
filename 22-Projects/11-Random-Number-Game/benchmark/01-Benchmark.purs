module Performance.RandomNumber.Benchmark where

import Prelude
import Effect (Effect)

import Benchotron.Core (Benchmark, benchFn, mkBenchmark)
import Benchotron.UI.Console (runSuite)

import Test.RandomNumber.Generators (TestData(..))
import Test.RandomNumber.ReaderT.Standard.DifferentMonad as DifferentMonad
import Test.RandomNumber.ReaderT.Standard.SameMonad as SameMonad
-- import Test.RandomNumber.Run.Standard as StandardRun
-- import Test.RandomNumber.Run.Layered as LayeredRun

import Performance.RandomNumber.Generators (WinData(..), LoseData(..), genWinData, genLoseData)

main :: Effect Unit
main = runSuite [winBench, loseBench]

stackOverflow_error_warning :: String
stackOverflow_error_warning = """
On my computer, the below 'sizes' value will produce
a stack overflow error after 2000 guesses.

Talking to Nate on the Slack channel, here are our options:
1. benchmark using a smaller number, so that I don't need to use
    a special type (Trampoline) to guarantee that the pure computation
    is stack-safe
2. benchmark using a large number, but incur the overhead of Trampoline
    because otherwise I'll get a stackoverflow error

With this choice, I opted for the first option and not using Trampoline.
"""

numberOfGuesses :: Array Int
numberOfGuesses = [ 500, 750, 1000, 1250, 1500, 1750, 2000 ]

winBench :: Benchmark
winBench = mkBenchmark
  { slug: "random-number-game--win"
  , title: "Random Number Game (Win) - Various FP Approaches"
  -- Each `Int` in this `Array` will be the `n` argument in the `gen` field
  , sizes: numberOfGuesses
  , sizeInterpretation: "The number of guesses to make before winning"
  -- how many times to run a benchmark for each 'size' above
  -- totalBenchmarksRun = (length sizes) * inputsPerSize
  , inputsPerSize: 3
 -- gen :: forall a. Int -> Gen a
  , gen: \n -> genWinData n
  , functions:            -- forall a r. (a -> r)
      [ benchFn "Standard ReaderT (Different Monad)"
          (\(WinData (TestData rec)) -> DifferentMonad.produceGameResult rec.random rec.userInputs)
      , benchFn "Standard ReaderT (Same Monad)"
          (\(WinData (TestData rec)) -> SameMonad.produceGameResult rec.random rec.userInputs)

      -- NOTE: The following benchmark is no longer being run due to these Examples
      -- being placed in the 'deadcode' folder
      -- , benchFn "Standard Run"
      --     (\(WinData (TestData rec)) -> StandardRun.produceGameResult rec.random rec.userInputs)
      -- , benchFn "Layered Run"
      --     (\(WinData (TestData rec)) -> LayeredRun.produceGameResult rec.random rec.userInputs)
      ]
  }

loseBench :: Benchmark
loseBench = mkBenchmark
  { slug: "random-number-game--lose"
  , title: "Random Number Game (Lose) - Various FP Approaches"
  -- Each `Int` in this `Array` will be the `n` argument in the `gen` field
  , sizes: numberOfGuesses
  , sizeInterpretation: "The number of guesses to make before losing"
  -- how many times to run a benchmark for each 'size' above
  -- totalBenchmarksRun = (length sizes) * inputsPerSize
  , inputsPerSize: 3
 -- gen :: forall a. Int -> Gen a
  , gen: \n -> genLoseData n
  , functions:            -- forall a r. (a -> r)
      [ benchFn "Standard ReaderT (Different Monad)"
          (\(LoseData (TestData rec)) -> DifferentMonad.produceGameResult rec.random rec.userInputs)
      , benchFn "Standard ReaderT (Same Monad)"
          (\(LoseData (TestData rec)) -> SameMonad.produceGameResult rec.random rec.userInputs)
      -- NOTE: The following benchmark is no longer being run due to these Examples
      -- being placed in the 'deadcode' folder
      -- , benchFn "Standard Run"
      --     (\(LoseData (TestData rec)) -> StandardRun.produceGameResult rec.random rec.userInputs)
      -- , benchFn "Layered Run"
      --     (\(LoseData (TestData rec)) -> LayeredRun.produceGameResult rec.random rec.userInputs)
      ]
  }
