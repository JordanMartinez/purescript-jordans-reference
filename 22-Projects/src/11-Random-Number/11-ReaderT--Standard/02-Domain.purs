module RandomNumber.ReaderT.Standard.Domain
  ( class NotifyUser, notifyUser
  , class GetUserInput, getUserInput
  , class CreateRandomInt, createRandomInt

  , game
  ) where

import Prelude
import Data.Maybe (Maybe(..))
import Data.Either (Either(..))
import Data.Int (fromString)
import RandomNumber.Core ( Bounds, mkBounds, totalPossibleGuesses
                               , RandomInt, mkRandomInt
                               , Guess, mkGuess, (==#)
                               , RemainingGuesses, mkRemainingGuesses, outOfGuesses, decrement
                               , GameResult(..)
                               )

-- Capabilities whose instances are later defined in API file

class (Monad m) <= NotifyUser m where
  notifyUser :: String -> m Unit

class (Monad m) <= GetUserInput m where
  getUserInput :: String -> m String

class (Monad m) <= CreateRandomInt m where
  createRandomInt :: Bounds -> m Int

-- actual game logic which uses those capabilities
game :: forall m.
        NotifyUser m =>
        GetUserInput m =>
        CreateRandomInt m =>
        m GameResult
game = do
  -- explain rules
  notifyUser "This is a random integer guessing game. \
             \In this game, you must try to guess the random integer \
             \before running out of guesses."

  -- setup game
  notifyUser "Before we play the game, the computer needs you to \
             \define two things."

  bounds <- defineBounds
  totalGueses <- defineTotalGuesses bounds
  randomInt <- generateRandomInt bounds

  notifyUser $ "Everything is set. You will have " <> show totalGueses <>
               " guesses to guess a number between " <> show bounds <>
               ". Good luck!"

  -- play game
  result <- gameLoop bounds randomInt totalGueses

  case result of
    PlayerWins remaining -> do
      notifyUser "Player won!"
      notifyUser $ "Player guessed the random number with " <>
        show remaining <> " try(s) remaining."
    PlayerLoses randomInt' -> do
      notifyUser "Player lost!"
      notifyUser $ "The number was: " <> show randomInt'

  pure result

-- Helper functions that makes the above more readable

-- | Calls `makeGuess` recursively until either the random number is
-- | correctly guessed or the player runs out of guesses
-- | MonadRec is not used here because `Aff` is stack-safe
defineBounds :: forall m.
                NotifyUser m =>
                GetUserInput m =>
                m Bounds
defineBounds = do
  notifyUser "Please, define the range from which to choose a \
             \random integer. This could be something easy like '1 to 5' \
             \or something hard like `1 to 100`. The range can also include \
             \negative numbers (e.g. '-10 to -1' or '-100 to 100')"

  bounds <- recursivelyRunUntilPure
    (mkBounds
      <$> getIntFromUser "Please enter either the lower or upper bound: "
      <*> getIntFromUser "Please enter the other bound: ")

  notifyUser $ "The random number will be between " <> show bounds <> "."
  pure bounds

defineTotalGuesses :: forall m.
                      NotifyUser m =>
                      GetUserInput m =>
                      Bounds -> m RemainingGuesses
defineTotalGuesses bounds = do
  notifyUser $ "Please, define the number of guesses you will have. \
               \This must be a postive number. Note: due to the bounds you \
               \defined, there are " <> (show $ totalPossibleGuesses bounds)
               <> " possible answers."

  totalGuesses <- recursivelyRunUntilPure
    (mkRemainingGuesses <$>
      getIntFromUser "Please enter the total number of guesses: ")

  notifyUser $ "You have limited yourself to " <> show totalGuesses
               <> " guesses."
  pure totalGuesses

generateRandomInt :: forall m.
                          NotifyUser m =>
                          CreateRandomInt m =>
                          Bounds -> m RandomInt
generateRandomInt bounds = do
  notifyUser $ "Now generating random number..."

  random <- recursivelyRunUntilPure
    (mkRandomInt bounds <$> createRandomInt bounds)

  notifyUser $ "Finished."
  pure random

makeGuess :: forall m.
                  NotifyUser m =>
                  GetUserInput m =>
                  Bounds -> m Guess
makeGuess bounds = do
  guess <- recursivelyRunUntilPure
    ((mkGuess bounds) <$> getIntFromUser "Your guess: ")
  pure guess

gameLoop :: forall m.
            NotifyUser m =>
            GetUserInput m =>
            Bounds -> RandomInt -> RemainingGuesses -> m GameResult
gameLoop bounds randomInt remaining
  | outOfGuesses remaining = pure $ PlayerLoses randomInt
  | otherwise = do
    let remaining' = decrement remaining
    guess <- makeGuess bounds
    if guess ==# randomInt
      then pure $ PlayerWins remaining'
      else do
        notifyUser $ "Incorrect. You have " <> show remaining'
          <> " guesses remaining."
        gameLoop bounds randomInt remaining'

-- Code

getIntFromUser :: forall m.
                  NotifyUser m =>
                  GetUserInput m =>
                  String -> m Int
getIntFromUser prompt =
  recursivelyRunUntilPure (inputIsInt <$> getUserInput prompt)

recursivelyRunUntilPure :: forall m e a.
                           Show e =>
                           NotifyUser m =>
                           m (Either e a) -> m a
recursivelyRunUntilPure computation = do
  result <- computation
  case result of
    Left e -> do
      notifyUser $ show e <> " Please try again."
      recursivelyRunUntilPure computation
    Right a -> pure a

data InputError = NotAnInt String
instance ies :: Show InputError where
  show (NotAnInt s) = "User inputted a non-integer value: " <> s

inputIsInt :: String -> Either InputError Int
inputIsInt s = case fromString s of
  Just i -> Right i
  Nothing -> Left $ NotAnInt s
