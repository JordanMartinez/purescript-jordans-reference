module Performance.Games.RandomNumber.Benchmark where

import Prelude
import Effect (Effect)

import Benchotron.Core (Benchmark, benchFn, mkBenchmark)
import Benchotron.UI.Console (runSuite)

import Test.Games.RandomNumber.Generators (TestData(..), genTestData')
import Test.Games.RandomNumber.ReaderT.Standard.DifferentMonad as DifferentMonad
import Test.Games.RandomNumber.ReaderT.Standard.SameMonad as SameMonad
import Test.Games.RandomNumber.Run.Standard.Infrastructure as StandardRun
import Test.Games.RandomNumber.Run.Layered.Infrastructure as LayeredRun

main :: Effect Unit
main = runSuite [bench]

bench :: Benchmark
bench = mkBenchmark
  { slug: "random-number-game"
  , title: "Random Number Game - Various FP Approaches"
  -- Each `Int` in this `Array` will be the `n` argument in the `gen` field
  , sizes: [ 500, 750, 1000, 1250, 1500, 1750, 2000 ]
  , sizeInterpretation: "The number of guesses to make before winning/losing"
  -- how many times to run a benchmark for each 'size' above
  -- totalBenchmarksRun = (length sizes) * inputsPerSize
  , inputsPerSize: 3
 -- gen :: forall a. Int -> Gen a
  , gen: \n -> genTestData' (pure n)
  , functions:            -- forall a r. (a -> r)
      [ benchFn "Standard ReaderT (Different Monad)"
          (\(TestData rec) -> DifferentMonad.produceGameResult rec.random rec.userInputs)
      , benchFn "Standard ReaderT (Same Monad)"
          (\(TestData rec) -> SameMonad.produceGameResult rec.random rec.userInputs)
      , benchFn "Standard Run"
          (\(TestData rec) -> StandardRun.produceGameResult rec.random rec.userInputs)
      , benchFn "Layered Run"
          (\(TestData rec) -> LayeredRun.produceGameResult rec.random rec.userInputs)
      ]
  }
