module Games.RandomNumber.Free.Domain (RandomNumberGameF(..), Game, game) where

import Prelude

import Control.Monad.Free (Free, liftF)
import Data.Functor (class Functor)
-- import Games.RandomNumber.Free (Game(..))
import Games.RandomNumber.Free.Core (Bounds, RandomInt, Guess, RemainingGuesses, outOfGuesses, decrement, totalPossibleGuesses, (==#), mkGameInfo, GameResult(..))

-- | Defines the operations we'll need to run
-- | a Random Number Guessing game
data RandomNumberGameF a
  = NotifyUser String a
  | DefineBounds (Bounds -> a)
  | DefineTotalGuesses Bounds (RemainingGuesses -> a)
  | GenerateRandomInt Bounds (RandomInt -> a)
  | MakeGuess Bounds (Guess -> a)

derive instance f :: Functor RandomNumberGameF

-- `Free` stuff
type Game = Free RandomNumberGameF

log :: String -> Game Unit
log msg = liftF $ NotifyUser msg unit

defineBounds :: Game Bounds
defineBounds = liftF $ DefineBounds identity

defineTotalGuesses :: Bounds -> Game RemainingGuesses
defineTotalGuesses bounds = liftF $ DefineTotalGuesses bounds identity

generateRandomInt :: Bounds -> Game RandomInt
generateRandomInt bounds = liftF $ GenerateRandomInt bounds identity

makeGuess :: Bounds -> Game Guess
makeGuess b = liftF $ MakeGuess b identity

-- | Calls `makeGuess` recursively until either the random number is
-- | correctly guessed or the player runs out of guesses
gameLoop :: Bounds -> RandomInt -> RemainingGuesses -> Game GameResult
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

game :: Game playerResult
game = do
  -- explain rules
  log "This is a random integer guessing game. In this game, you must try \
      \to guess the random integer before running out of guesses."

  -- setup game
  log "Before we play the game, the computer needs you to define two things."

  bounds <- defineBounds
  totalGueses <- defineTotalGuesses bounds
  randomInt <- generateRandomInt bounds

  log $ "Everything is set. You will have " <> show totalGueses <>
        " guesses to guess a number between " <> show bounds <>
        ". Good luck!"

  -- play game
  result <- gameLoop bounds totalGueses remaining
  case result of
    PlayerWins remaining -> do
      log "Player won!"
      log $ "Player guessed the random number with " <>
        show remaining <> " try(s) remaining."
    PlayerLoses randomInt -> do
      log "Player lost!"
      log $ "The number was: " <> show randomInt

  -- return game result
  pure result
