module Performance.RandomNumber.Generators
  ( WinData(..)
  , genWinData

  , LoseData(..)
  , genLoseData
  ) where

import Prelude

import Data.Array (snoc)
import RandomNumber.Core (GameResult(..))
import Test.QuickCheck.Gen (Gen)

import Test.RandomNumber.Generators (
  TestData(..)
, genBounds
, genIntWithinBounds
, genIncorrectGuesses
, mkUserInputs
, mkRemainingGuesses_
, mkRandomInt_
, mkBounds_
)

-- These generators take `genTestData` and separate its win/lose scenarios
-- into their own generators.

newtype WinData = WinData TestData
newtype LoseData = LoseData TestData

genWinData :: Int -> Gen WinData
genWinData totalGuesses = do
  bounds <- genBounds
  random <- genIntWithinBounds bounds
  incorrectGuesses <- genIncorrectGuesses (totalGuesses - 1) bounds random
  let guesses = snoc incorrectGuesses random
  let userInputs = mkUserInputs bounds totalGuesses guesses
  let _Remaining = mkRemainingGuesses_ 0
  pure $ WinData $ TestData
    { random: random, userInputs: userInputs, result: PlayerWins _Remaining }

genLoseData :: Int -> Gen LoseData
genLoseData totalGuesses = do
  bounds <- genBounds
  random <- genIntWithinBounds bounds
  guesses <- genIncorrectGuesses totalGuesses bounds random
  let userInputs = mkUserInputs bounds totalGuesses guesses
  let _Random = mkRandomInt_ (mkBounds_ bounds) random
  pure $ LoseData $ TestData
    { random: random, userInputs: userInputs, result: PlayerLoses _Random }
