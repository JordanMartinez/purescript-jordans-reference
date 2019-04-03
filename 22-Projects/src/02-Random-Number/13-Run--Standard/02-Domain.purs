module RandomNumber.Run.Standard.Domain
  ( NotifyUserF(..), NOTIFY_USER, _notifyUser, notifyUser
  , GetUserInputF(..), GET_USER_INPUT, _getUserInput, getUserInput
  , CreateRandomIntF(..), CREATE_RANDOM_INT, _createRandomInt, createRandomInt
  , game
  ) where

import Prelude
import Data.Either (Either(..))
import Data.Int (fromString)
import Data.Maybe (Maybe(..))
import Data.Symbol (SProxy(..))
import Type.Row (type (+))
import Run (Run, FProxy, lift)
import RandomNumber.Core ( Bounds, mkBounds, totalPossibleGuesses
                               , RandomInt, mkRandomInt
                               , Guess, mkGuess
                               , RemainingGuesses, mkRemainingGuesses, outOfGuesses, decrement, (==#), GameResult(..))

{-
data API_F a
  = Log String a
  | GetUserInput String (String -> a)
  | CreateRandomInt Bounds (Int -> a)
-}

data NotifyUserF a = NotifyUserF String a
derive instance functorNotifyUserF :: Functor NotifyUserF

_notifyUser :: SProxy "notifyUser"
_notifyUser = SProxy

type NOTIFY_USER r = (notifyUser :: FProxy NotifyUserF | r)

notifyUser :: forall r. String -> Run (NOTIFY_USER + r) Unit
notifyUser msg = lift _notifyUser (NotifyUserF msg unit)

---

data GetUserInputF a = GetUserInputF String (String -> a)
derive instance functorGetUserInputF :: Functor GetUserInputF

_getUserInput :: SProxy "getUserInput"
_getUserInput = SProxy

type GET_USER_INPUT r = (getUserInput :: FProxy GetUserInputF | r)

getUserInput :: forall r. String -> Run (GET_USER_INPUT + r) String
getUserInput msg = lift _getUserInput (GetUserInputF msg identity)

---

data CreateRandomIntF a = CreateRandomIntF Bounds (Int -> a)
derive instance functorCreateRandomIntF :: Functor CreateRandomIntF

_createRandomInt :: SProxy "createRandomInt"
_createRandomInt = SProxy

type CREATE_RANDOM_INT r = (createRandomInt :: FProxy CreateRandomIntF | r)

createRandomInt :: forall r. Bounds -> Run (CREATE_RANDOM_INT + r) Int
createRandomInt bounds = lift _createRandomInt (CreateRandomIntF bounds identity)

game :: forall r.
        Run ( NOTIFY_USER
            + CREATE_RANDOM_INT
            + GET_USER_INPUT
            + r
            ) GameResult
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
  randomInt <- genRandomInt bounds

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


-- Code

defineBounds :: forall r. Run (NOTIFY_USER + GET_USER_INPUT + r) Bounds
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

defineTotalGuesses :: forall r. Bounds -> Run (NOTIFY_USER + GET_USER_INPUT + r) RemainingGuesses
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

genRandomInt :: forall r. Bounds -> Run (NOTIFY_USER + CREATE_RANDOM_INT + r) RandomInt
genRandomInt bounds = do
  notifyUser $ "Now generating random number..."

  random <- recursivelyRunUntilPure
    (mkRandomInt bounds <$> createRandomInt bounds)

  notifyUser $ "Finished."
  pure random

makeGuess :: forall r. Bounds -> Run (NOTIFY_USER + GET_USER_INPUT + r) Guess
makeGuess bounds = do
  guess <- recursivelyRunUntilPure
    ((mkGuess bounds) <$> getIntFromUser "Your guess: ")
  pure guess

-- | Calls `makeGuess` recursively until either the random number is
-- | correctly guessed or the player runs out of guesses
-- | MonadRec is not used here because `Aff` is stack-safe
gameLoop :: forall r
          . Bounds -> RandomInt -> RemainingGuesses
         -> Run (NOTIFY_USER + GET_USER_INPUT + r) GameResult
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

getIntFromUser :: forall r. String -> Run (NOTIFY_USER + GET_USER_INPUT + r) Int
getIntFromUser prompt =
  recursivelyRunUntilPure (inputIsInt <$> getUserInput prompt)

recursivelyRunUntilPure :: forall r e a
                         . Show e
                        => Run (NOTIFY_USER + r) (Either e a)
                        -> Run (NOTIFY_USER + r) a
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
