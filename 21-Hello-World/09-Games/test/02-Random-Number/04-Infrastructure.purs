module Test.Games.RandomNumber.Free.Infrastructure where

import Prelude
import Data.Tuple (Tuple(..), fst, snd)
import Data.Maybe (Maybe(..), fromJust)
import Data.Array (snoc, uncons)
import Data.NonEmpty ((:|))
import Data.Identity (Identity(..))
import Control.Monad.Gen.Common (genMaybe)
import Test.QuickCheck.Gen (Gen, chooseInt, oneOf, suchThat, vectorOf, randomSample)
import Control.Monad.Free (Free, runFree, foldFree)
import Data.Either (fromRight)
import Partial.Unsafe (unsafePartial)
import Effect.Ref (Ref)
import Effect.Ref as Ref
import Effect.Class (liftEffect)
import Effect (Effect)
import Effect.Console (log)
import Test.QuickCheck (quickCheck, (<?>))
import Test.QuickCheck.Arbitrary (class Arbitrary, arbitrary)

import Games.RandomNumber.Core ( Bounds, RemainingGuesses, RandomInt
                               , GameResult(..)
                               , mkBounds, mkRemainingGuesses, mkRandomInt
                               , decrement
                               )
import Games.RandomNumber.Free.Core (game)

import Games.RandomNumber.Free.Domain (runCore)

import Games.RandomNumber.API (API_F(..))
import Games.RandomNumber.Free.API (API, runDomain)


-- helper type to refer to this record easier
type TestData_ = { random :: Int
                 , userInputs :: Array String
                 , result :: GameResult
                 }

newtype TestData = TestData TestData_
instance arb :: Arbitrary TestData where
  arbitrary = genTestData -- genTestData code is below main

main :: Effect Unit
main = do
  sample <- randomSample genTestData
  log $ show $ (\(TestData record) -> record) <$> sample

  -- This code doesn't work yet because I need to figure out
  -- how to "interpret" the API language in such a way that I
  -- can give it a different value for each run (e.g. pop off
  -- the next 'guess' user input from the stack of guesses,
  -- which is state manipulation). In other words, the test
  -- must use monadic effects and it seems that the Purescript's
  -- QuickCheck library doesn't yet support that.
---------------------------------
  -- quickCheck (\(TestData record) ->
  --   let gameResult = runAPI record (runDomain (runCore game))
  --   in gameResult == record.result <?>
  --     "GameResult:     " <> show gameResult <> "\n\
  --     \ExpectedResult: " <> show record.result
  -- )

-- runAPI :: forall a. TestData_ -> API a -> a
-- runAPI record = runFree go
--
--   where
--     go :: forall a. API_F (Free API_F a) -> Free API_F a
--     go = case _ of
--       Log _ next -> next
--       GetUserInput _ reply -> do
--         {-
--         State manipulation needed here. Something like this:
--
--         answer <- liftEffect $ flip Ref.modify' record.userInputs (\array ->
--           let {head: x, tail: array'} = unsafePartial $ fromJust $ uncons array
--           in {state: array', value: x})
--
--         reply answer
--         -}
--
--         -- since this is used for both the lower/upper bounds,
--         -- the "user input" will fail the API's data validation
--         -- and cause it to make another request to the Infrastructure
--         -- level, which returns the same value. Thus, the
--         -- program will loop forever and never complete.
--         reply "5"
--       GenRandomInt _ reply -> do
--         reply record.random
---------------------------------

type MockedBounds = Tuple Int Int

-- Generators

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
      let _Remaining = case (totalGuesses - takesXGuesses) of
            0 -> decrement $ mkRemainingGuesses_ 1
            unusedGuesses -> mkRemainingGuesses_ unusedGuesses
      pure $ TestData
        { random: random, userInputs: userInputs, result: PlayerWins _Remaining }
    Nothing -> do
      guesses <- genIncorrectGuesses totalGuesses bounds random
      let userInputs = mkUserInputs bounds totalGuesses guesses
      let _Random = mkRandomInt_ (mkBounds_ bounds) random
      pure $ TestData
        { random: random, userInputs: userInputs, result: PlayerLoses _Random }

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
  genIncorrectGuess r
    | r == lower = chooseInt afterRandom upper
    | r == upper = chooseInt lower beforeRandom
    | otherwise = do
        oneOf (
          chooseInt lower beforeRandom :| [chooseInt afterRandom upper]
        )

mkUserInputs :: MockedBounds -> Int -> Array Int -> Array String
mkUserInputs (Tuple lower upper) totalGueses guesses = do
  [show lower, show upper, show totalGueses] <> (show <$> guesses)


-- Creates these objects using partial functions because their arguments
-- will be valid
mkBounds_ :: MockedBounds -> Bounds
mkBounds_ (Tuple lower upper) =
  unsafePartial $ fromRight $ mkBounds lower upper

mkRemainingGuesses_ :: Int -> RemainingGuesses
mkRemainingGuesses_ i = unsafePartial $ fromRight $ mkRemainingGuesses i

mkRandomInt_ :: Bounds -> Int -> RandomInt
mkRandomInt_ b i = unsafePartial $ fromRight $ mkRandomInt b i
