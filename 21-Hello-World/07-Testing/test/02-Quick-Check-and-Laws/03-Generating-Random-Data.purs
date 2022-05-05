-- | The focus of this file is on how to use combinators.
-- | to produce random data.
module Test.RandomDataGeneration.Combinators where

import Prelude
import Data.Maybe (fromJust)
import Effect (Effect)
import Effect.Console (log)
import Data.Array.NonEmpty as NEA

-- new imports
-- these are all explained below
import Test.QuickCheck.Gen (
    uniform
  , choose, chooseInt, elements, shuffle
  , oneOf, frequency, suchThat
  , arrayOf, arrayOf1, listOf, vectorOf

-- all imports below this line are needed to compile
  , Gen, randomSample
  )
import Data.Int (even)
import Data.Traversable (for)
import Data.Tuple (Tuple(..))
import Partial.Unsafe (unsafePartial)

-- Prints the results of the combinators in Test.QuickCheck.Gen
main :: Effect Unit
main = do                                                                 {-
  printData "explanation" $
    combinator arg1 arg2 -- if args are required                          -}

  log "*** Basic combinators ***"

  -- see "Standard Uniform Distribution" section in
  -- https://www.wikiwand.com/en/Uniform_distribution_(continuous)
  printData "uniform - standard uniform distribution" $
    uniform

  printData "chooseInt - choose a random Int between" $
    chooseInt 1   10

  printData "choose - choose a random Number between" $
    choose    1.0 10.0

   -- oneToThree = NonEmptyArray [1, 2, 3]
  let oneToThree = unsafePartial fromJust $ NEA.fromArray [1, 2, 3]
  printData ("elements - Choose an random element from the array where \
             \each element has the same probability of being chosen") $
    elements oneToThree

  let array = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  printData ("shuffle - randomize the order of an array's elements \
             \(e.g. " <> show array <> ")") $
    shuffle array



  log "*** Composable combinators ***"

  printData ("oneOf - Randomly choose a generator (where each generator has \
             \the same probability of being chosen) and use it to generate \
             \a random instance of the data type") $
    oneOf $ unsafePartial fromJust $ NEA.fromArray
      [ chooseInt   0   9
      , chooseInt  10  99
      , chooseInt 100 999
      ]

  let array_1 = NEA.singleton 1 -- (NonEmptyArray Int)
      array_2 = NEA.singleton 2
      array_4 = NEA.singleton 4
      lessOften = 1.0
      sometimes = 2.0
      moreOften = 4.0
  printData ("frequency - Generate an instance from an array of generators \
                  \where each generator is used unequally") $
    frequency $ unsafePartial fromJust $ NEA.fromArray
      [ Tuple lessOften (elements $ array_1)
      , Tuple sometimes (elements $ array_2)
      , Tuple moreOften (elements $ array_4)
      ]

  printData "suchThat - Create a generator (e.g. even numbers) by filtering \
            \out invalid instances that are generated from another generator \
            \by using the given function" $
    suchThat (chooseInt 1 100) even

  log "*** Multiplier combinators ***"

  printData "arrayOf - Using a generator that creates one `a`, create \
            \an empty array of type `a` or \
            \an array of randomly-generated `a` instances" $
    arrayOf $ chooseInt 0 9

  printData "arrayOf1 - Using a generator that creates one `a`, create \
            \an non-empty array of randomly-generated `a` instances" $
    arrayOf1 $ chooseInt 0 9

  printData "vectorOf - Using a generator that creates one `a`, create \
            \a non-empty array of a specified number of randomly-generated \
            \`a` instances" $
    vectorOf 10 $ chooseInt 0 9

  printData "listOf - Using a generator that creates one `a`, create \
            \a non-empty list of a specified number of randomly-generated \
            \`a` instances" $
    listOf 10 $ chooseInt 0 9

-- Helper functions

printData :: forall a. Show a => String -> Gen a -> Effect Unit
printData explanation generator = do
  log $ "=== " <> explanation
  result <- randomSample generator
  void $ for result (\item -> log $ show item)
  log "=== Finished\n"
