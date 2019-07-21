module Benchmarking.Syntax.Benchotron where

import Prelude
import Effect (Effect)
import Test.QuickCheck.Arbitrary (arbitrary)
import Test.QuickCheck.Gen (vectorOf)

-- needed to run the benchmark
import Data.Foldable (foldMap, foldr)
import Data.Monoid.Additive (Additive(..))
import Data.Newtype (ala)

-- new imports
import Benchotron.Core (Benchmark, benchFn, mkBenchmark)

-- This module includes other `benchmarkToX` functions (e.g. benchmarkToFile)
-- However, there's no reason to directly use them. `runSuite`
-- uses them and provides the best interface to run
-- multiple benchmarks in one command
import Benchotron.UI.Console (runSuite)

main :: Effect Unit
main = runSuite [syntax]

syntax :: Benchmark
syntax = mkBenchmark
  { slug: "file-name-for-output"
  , title: "Title of the benchmark"
  -- Each `Int` in this `Array` will be the `n` argument in the `gen` field
  , sizes: [1000, 2000, 3000, 4000, 5000]
  , sizeInterpretation: "Human-readable explanation of 'sizes': \
                        \the number of elements in an array"
  -- how many times to run a benchmark for each 'size' above
  -- totalBenchmarksRun = (length sizes) * inputsPerSize
  -- If this was 2, we'd run each of the 5 benchmarks above twice
  , inputsPerSize: 1
 -- gen :: forall a. Int -> Gen a
  , gen: \n -> vectorOf n arbitrary
  , functions:            -- forall a r. (a -> r)
      [ benchFn "function name: foldr"   (foldr (+) 0)
      , benchFn "function name: foldmap" (ala Additive foldMap)
      ]
  }
