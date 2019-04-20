module Test.RandomNumber.Generators
  ( TestData(..), TestDataRecord
  , genTestData
  , genBounds
  , genIntWithinBounds
  , genIncorrectGuesses
  , mkUserInputs
  , mkBounds_
  , mkRemainingGuesses_
  , mkRandomInt_
  ) where

import Prelude

import Control.Monad.Gen.Common (genMaybe)
import Data.Array (snoc)
import Data.Either (fromRight)
import Data.Maybe (Maybe(..))
import Data.NonEmpty ((:|))
import Data.Tuple (Tuple(..))
import RandomNumber.Core (Bounds, RemainingGuesses, RandomInt, GameResult(..), mkBounds, mkRemainingGuesses, mkRandomInt, decrement)
import Partial.Unsafe (unsafePartial)
import Test.QuickCheck.Arbitrary (class Arbitrary)
import Test.QuickCheck.Gen (Gen, chooseInt, oneOf, suchThat, vectorOf)

type MockedBounds = Tuple Int Int

type TestDataRecord =
  -- these two are the required "inputs" for interpreting
  -- the API language
  { random :: Int               -- the random number for our game
  , userInputs :: Array String  -- all the user's console inputs
                                -- (i.e. bounds, total guesses, guesses)

  -- this value is the expected "output" for our program's "inputs"
  , result :: GameResult        -- the expected game result
  }

newtype TestData = TestData TestDataRecord
instance arb :: Arbitrary TestData where
  arbitrary = genTestData

-- Main Generator

genTestData :: Gen TestData
genTestData = do
  bounds <- genBounds
  random <- genIntWithinBounds bounds
  totalGuesses <- genPositiveInt 100
  winOrLoss <- genGameResult totalGuesses

  case winOrLoss of
    Just takesXGuesses -> do
      incorrectGuesses <- genIncorrectGuesses (takesXGuesses - 1) bounds random
      let guesses = snoc incorrectGuesses random
      let userInputs = mkUserInputs bounds totalGuesses guesses
      let _Remaining = mkRemainingGuesses_ (totalGuesses - takesXGuesses)
      pure $ TestData
        { random: random, userInputs: userInputs, result: PlayerWins _Remaining }
    Nothing -> do
      guesses <- genIncorrectGuesses totalGuesses bounds random
      let userInputs = mkUserInputs bounds totalGuesses guesses
      let _Random = mkRandomInt_ (mkBounds_ bounds) random
      pure $ TestData
        { random: random, userInputs: userInputs, result: PlayerLoses _Random }

-- Generators' definitions

genInt :: Gen Int
genInt = chooseInt bottom top -- from Bounded Int

genBounds :: Gen MockedBounds
genBounds = do
  a <- genInt
  b <- genInt `suchThat` (\b -> b /= a)
  let x = if a < b then Tuple a b else Tuple b a
  pure x

genIntWithinBounds :: MockedBounds -> Gen Int
genIntWithinBounds (Tuple lower upper) = chooseInt lower upper

-- If we make this `chooseInt 1 top`, it may generate a very large
-- number of guesses. Thus, we'll limit it to the max bound
genPositiveInt :: Int -> Gen Int
genPositiveInt maxBound = chooseInt 1 maxBound

-- | Just (guess correct answer)
-- | Nothing (never guesses correct answer)
genGameResult :: Int -> Gen (Maybe Int)
genGameResult totalGueses = genMaybe $ chooseInt 1 totalGueses

genIncorrectGuesses :: Int -> MockedBounds -> Int -> Gen (Array Int)
genIncorrectGuesses size (Tuple lower upper) random =
  vectorOf size (genIncorrectGuess random)

  where
  beforeRandom = max lower (random - 1)
  afterRandom = min upper (random + 1)
  genIncorrectGuess r | r == lower = chooseInt afterRandom upper
                      | r == upper = chooseInt lower beforeRandom
                      | otherwise =
                          oneOf (
                            chooseInt lower beforeRandom :|
                            [chooseInt afterRandom upper]
                          )

-- Other Helper Functions

-- | Converts all our inputs into an Array of String, since that's
-- | what is used by API's `GetUserInputF`'s `reply` value
mkUserInputs :: MockedBounds -> Int -> Array Int -> Array String
mkUserInputs (Tuple lower upper) totalGueses guesses = do
  [show lower, show upper, show totalGueses] <> (show <$> guesses)

------------------

-- Creates these objects using partial functions because their arguments
-- will be valid

mkBounds_ :: MockedBounds -> Bounds
mkBounds_ (Tuple lower upper) =
  unsafePartial $ fromRight $ mkBounds lower upper

-- Since we can't create a RemainingGuesses with a 0 Int value,
-- we'll create it with one and then decrement it.
mkRemainingGuesses_ :: Int -> RemainingGuesses
mkRemainingGuesses_ 0 = decrement $ mkRemainingGuesses_ 1
mkRemainingGuesses_ i = unsafePartial $ fromRight $ mkRemainingGuesses i

mkRandomInt_ :: Bounds -> Int -> RandomInt
mkRandomInt_ b i = unsafePartial $ fromRight $ mkRandomInt b i
