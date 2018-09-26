module Games.RandomNumber.API
  ( RandomNumberOperationF(..), RandomNumberOperation
  , runGame
  ) where

import Prelude
import Control.Monad.Free (Free, liftF, substFree)
import Data.Tuple (Tuple(..))
import Games.RandomNumber.Core (
    Bounds, showTotalPossibleGuesses
  , RandomInt, Guess
  , (==#)
  , Count, decrement, outOfGuesses
  )
import Games.RandomNumber.Domain (
    GameInfo(..), mkGameInfo
  , GameResult(..)
  , GameF(..), Game
  )

-- | Defines the operations we'll need to run
-- | a Random Number Guessing game
data RandomNumberOperationF a
  = LogOutput String a
  | DefineBounds (Bounds -> a)
  | DefineCount (Count -> a)
  | GenerateRandomInt Bounds (RandomInt -> a)
  | MakeGuess Bounds (Guess -> a)

type RandomNumberOperation a = Free RandomNumberOperationF a

log :: String -> RandomNumberOperation Unit
log msg = liftF $ LogOutput msg unit

defineBounds :: RandomNumberOperation Bounds
defineBounds = liftF $ DefineBounds identity

defineCount :: RandomNumberOperation Count
defineCount = liftF $ DefineCount identity

generateRandomInt :: Bounds -> RandomNumberOperation RandomInt
generateRandomInt bounds = liftF $ GenerateRandomInt bounds identity

makeGuess :: Bounds -> RandomNumberOperation Guess
makeGuess b = liftF $ MakeGuess b identity

-- | Calls `makeGuess` recursively until either the random number is
-- | correctly guessed or the player runs out of guesses
gameLoop :: Bounds -> RandomInt -> Count -> RandomNumberOperation GameResult
gameLoop bounds randomInt count
  | outOfGuesses count = pure $ PlayerLoses $ randomInt
  | otherwise = do
    let newCount = decrement count
    guess <- makeGuess bounds
    if guess ==# randomInt
      then pure $ PlayerWins newCount
      else gameLoop bounds randomInt newCount

runGame :: Game ~> RandomNumberOperation
runGame = substFree go

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
      count <- defineCount
      log $ "You have limited yourself to " <> show count <> " guesses."

      log $ "Now generating random number..."
      randomInt <- generateRandomInt bounds
      log $ "Finished."

      log $ "Everything is set. You will have " <> show count <> " guesses \
            \to guess a number between " <> show bounds <> ". Good luck!"

      pure (reply $ Tuple (mkGameInfo bounds randomInt) count)
    PlayGame (GameInfo {bound: b, number: n}) count reply -> do
      result <- gameLoop b n count

      pure (reply result)
    EndGame gameResult next ->
      case gameResult of
        PlayerWins count -> do
          log "Player won!"
          log $ "Player guessed the random number with " <>
            show count <> " trie(s) remaining."
          pure next
        PlayerLoses randomInt -> do
          log "Player lost!"
          log $ "The number was: " <> show randomInt
          pure next
