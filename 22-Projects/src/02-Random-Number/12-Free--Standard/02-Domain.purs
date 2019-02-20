module Games.RandomNumber.Free.Standard.Domain (API_F(..), Game, game) where

import Prelude

import Control.Monad.Free (Free, liftF)
import Data.Either (Either(..))
import Data.Int (fromString)
import Data.Maybe (Maybe(..))
import Games.RandomNumber.Core ( Bounds, mkBounds, totalPossibleGuesses
                               , RandomInt, mkRandomInt
                               , Guess, mkGuess
                               , RemainingGuesses, mkRemainingGuesses, outOfGuesses, decrement, (==#), GameResult(..))

-- | Defines the effects we'll need to run
-- | a Random Number Guessing game
data API_F a
  = Log String a
  | GetUserInput String (String -> a)
  | GenRandomInt Bounds (Int -> a)

derive instance functorAPI_F :: Functor API_F

-- `Free` stuff

type Game = Free API_F

getUserInput :: String -> Game String
getUserInput prompt = liftF $ (GetUserInput prompt identity)

log :: String -> Game Unit
log msg = liftF $ (Log msg unit)

genRandomInt :: Bounds -> Game Int
genRandomInt bounds = liftF $ (GenRandomInt bounds identity)

game :: Game GameResult
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
  result <- gameLoop bounds randomInt totalGueses
  case result of
    PlayerWins remaining -> do
      log "Player won!"
      log $ "Player guessed the random number with " <>
        show remaining <> " try(s) remaining."
    PlayerLoses randomInt' -> do
      log "Player lost!"
      log $ "The number was: " <> show randomInt'

  -- return game result
  pure result

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

-- domain -> API
getIntFromUser :: String -> Game Int
getIntFromUser prompt =
  recursivelyRunUntilPure (inputIsInt <$> getUserInput prompt)

defineBounds :: Game Bounds
defineBounds = do
  log "Please, define the range from which to choose a random integer. \
      \This could be something easy like '1 to 5' or something hard like \
      \`1 to 100`. The range can also include negative numbers \
      \(e.g. '-10 to -1' or '-100 to 100')"

  bounds <- recursivelyRunUntilPure
    (mkBounds
      <$> getIntFromUser "Please enter either the lower or upper bound: "
      <*> getIntFromUser "Please enter the other bound: ")

  log $ "The random number will be between " <> show bounds <> "."
  pure bounds

defineTotalGuesses :: Bounds -> Game RemainingGuesses
defineTotalGuesses bounds = do
  log $ "Please, define the number of guesses you will have. This must \
      \be a postive number. Note: due to the bounds you defined, there are "
      <> (show $ totalPossibleGuesses bounds) <> " possible answers."

  totalGuesses <- recursivelyRunUntilPure
    (mkRemainingGuesses <$>
      getIntFromUser "Please enter the total number of guesses: ")

  log $ "You have limited yourself to " <> show totalGuesses <> " guesses."
  pure totalGuesses

generateRandomInt :: Bounds -> Game RandomInt
generateRandomInt bounds = do
  recursivelyRunUntilPure
    (mkRandomInt bounds <$> genRandomInt bounds)

makeGuess :: Bounds -> Game Guess
makeGuess bounds = do
  recursivelyRunUntilPure
    ((mkGuess bounds) <$> getIntFromUser "Your guess: ")

recursivelyRunUntilPure :: forall e a. Show e => Game (Either e a) -> Game a
recursivelyRunUntilPure computation = do
  result <- computation
  case result of
    Left e -> do
      log $ show e <> " Please try again."
      recursivelyRunUntilPure computation
    Right a -> pure a

data InputError = NotAnInt String
instance ies :: Show InputError where
  show (NotAnInt s) = "User inputted a non-integer value: " <> s

inputIsInt :: String -> Either InputError Int
inputIsInt s = case fromString s of
  Just i -> Right i
  Nothing -> Left $ NotAnInt s
