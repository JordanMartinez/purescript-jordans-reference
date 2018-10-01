module Games.RandomNumber.Free.Domain (RandomNumberOperationF(..), RandomNumberOperation, runCore) where

import Prelude
import Data.Functor (class Functor)
import Control.Monad.Free (Free, liftF, substFree)
import Games.RandomNumber.Free.Core ( Bounds, RandomInt, Guess, RemainingGuesses
                                    , outOfGuesses, decrement, totalPossibleGuesses
                                    , (==#), mkGameInfo
                                    , GameResult(..), Game, GameF(..), game)

-- | Defines the operations we'll need to run
-- | a Random Number Guessing game
data RandomNumberOperationF a
  = NotifyUser String a
  | DefineBounds (Bounds -> a)
  | DefineTotalGuesses Bounds (RemainingGuesses -> a)
  | GenerateRandomInt Bounds (RandomInt -> a)
  | MakeGuess Bounds (Guess -> a)

derive instance f :: Functor RandomNumberOperationF

-- `Free` stuff
type RandomNumberOperation a = Free RandomNumberOperationF a

log :: String -> RandomNumberOperation Unit
log msg = liftF $ NotifyUser msg unit

defineBounds :: RandomNumberOperation Bounds
defineBounds = liftF $ DefineBounds identity

defineTotalGuesses :: Bounds -> RandomNumberOperation RemainingGuesses
defineTotalGuesses bounds = liftF $ DefineTotalGuesses bounds identity

generateRandomInt :: Bounds -> RandomNumberOperation RandomInt
generateRandomInt bounds = liftF $ GenerateRandomInt bounds identity

makeGuess :: Bounds -> RandomNumberOperation Guess
makeGuess b = liftF $ MakeGuess b identity

-- | Calls `makeGuess` recursively until either the random number is
-- | correctly guessed or the player runs out of guesses
gameLoop :: Bounds -> RandomInt -> RemainingGuesses -> RandomNumberOperation GameResult
gameLoop bounds randomInt remaining
  | outOfGuesses remaining = pure $ PlayerLoses randomInt
  | otherwise = do
    let remaining' = decrement remaining
    guess <- makeGuess bounds
    if guess ==# randomInt
      then pure $ PlayerWins remaining'
      else do
        log $ "Incorrect. You have " <> show remaining' <> " guesses remaining."
        gameLoop bounds randomInt remaining'

runCore :: Game ~> RandomNumberOperation
runCore = substFree go

  where
  go :: GameF ~> RandomNumberOperation
  go = case _ of
    ExplainRules next -> do
      log "This is a random integer guessing game. In this game, you must try \
          \to guess the random integer before running out of guesses."

      pure next
    SetupGame reply -> do
      log "Before we play the game, the computer needs you to define two things."

      bounds <- defineBounds
      totalGueses <- defineTotalGuesses bounds
      randomInt <- generateRandomInt bounds

      log $ "Everything is set. You will have " <> show totalGueses <>
            " guesses to guess a number between " <> show bounds <>
            ". Good luck!"

      pure (reply $ mkGameInfo bounds randomInt totalGueses)
    PlayGame ({ bound: b, number: n, remaining: remaining }) reply -> do
      result <- gameLoop b n remaining

      pure (reply result)
    -- EndGame gameResult next ->
    --   case gameResult of
    --     PlayerWins remaining -> do
    --       log "Player won!"
    --       log $ "Player guessed the random number with " <>
    --         show remaining <> " trie(s) remaining."
    --       pure next
    --     PlayerLoses randomInt -> do
    --       log "Player lost!"
    --       log $ "The number was: " <> show randomInt
    --       pure next
