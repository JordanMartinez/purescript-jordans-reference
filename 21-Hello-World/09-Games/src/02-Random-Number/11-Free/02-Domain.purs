module Games.RandomNumber.Free.Domain (RandomNumberOperation, runCore) where

import Prelude
import Control.Monad.Free (Free, liftF, substFree)
import Games.RandomNumber.Core ( Bounds, showTotalPossibleGuesses
                               , RandomInt, Guess, (==#)
                               , RemainingGuesses, outOfGuesses, decrement
                               , GameF(..), GameResult(..)
                               , mkGameInfo
                               )
import Games.RandomNumber.Free.Core (Game)
import Games.RandomNumber.Domain (RandomNumberOperationF(..))

type RandomNumberOperation a = Free RandomNumberOperationF a

log :: String -> RandomNumberOperation Unit
log msg = liftF $ NotifyUser msg unit

defineBounds :: RandomNumberOperation Bounds
defineBounds = liftF $ DefineBounds identity

defineTotalGuesses :: RandomNumberOperation RemainingGuesses
defineTotalGuesses = liftF $ DefineTotalGuesses identity

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

      log "First, please define the range from which to choose a random integer. \
          \This could be something easy like '1 to 5' or something hard like \
          \`1 to 100`. The range can also include negative numbers \
          \(e.g. '-10 to -1' or '-100 to 100')"
      bounds <- defineBounds
      log $ "The random number will be between " <> show bounds <> "."

      log $ "Second, please define the number of guesses you will have. This must \
          \be a postive number. Note: due to the bounds you defined, there are "
          <> showTotalPossibleGuesses bounds <> " possible answers."
      totalGueses <- defineTotalGuesses
      log $ "You have limited yourself to " <> show totalGueses <> " guesses."

      log $ "Now generating random number..."
      randomInt <- generateRandomInt bounds
      log $ "Finished."

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
