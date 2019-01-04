module Performance.Games.RandomNumber.Generators
  ( WinData(..)
  , genWinData

  , LoseData(..)
  , genLoseData
  ) where

import Prelude

import Control.Monad.Gen.Common (genMaybe)
import Data.Array (snoc)
import Data.Either (fromRight)
import Data.Maybe (Maybe(..))
import Data.NonEmpty ((:|))
import Data.Tuple (Tuple(..))
import Games.RandomNumber.Core (Bounds, RemainingGuesses, RandomInt, GameResult(..), mkBounds, mkRemainingGuesses, mkRandomInt, decrement)
import Partial.Unsafe (unsafePartial)
import Test.QuickCheck.Arbitrary (class Arbitrary)
import Test.QuickCheck.Gen (Gen, chooseInt, oneOf, suchThat, vectorOf, randomSample)

import Test.Games.RandomNumber.Generators (
  TestData(..)
, TestDataRecord
, genBounds
, genIntWithinBounds
, genIncorrectGuesses
, mkUserInputs
, mkRemainingGuesses_
, mkRandomInt_
, mkBounds_
)

-- These generators take `genWithData` and separate its win/lose scenarios
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
