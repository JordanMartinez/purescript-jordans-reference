module Games.RandomNumber.MTL.API
  ( class GetUserInput, getUserInput
  , class CreateRandomInt, createRandomInt

  , defineBoundsToAPI, defineTotalGuessesToAPI, generateRandomIntToAPI, makeGuessToAPI
  , getIntFromUser, recursivelyRunUntilPure

  , inputIsInt, InputError(..)
  )
  where

import Prelude
import Data.Int (fromString)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Console (log)
import Control.Monad.Trans.Class (class MonadTrans, lift)
import Games.RandomNumber.Core ( Bounds, mkBounds, mkGuess, RandomInt, mkRandomInt
                               , Guess, RemainingGuesses, mkRemainingGuesses, totalPossibleGuesses
                               )

import Games.RandomNumber.MTL.Domain (
  class NotifyUser, notifyUser
, class DefineBounds, defineBounds
, class DefineTotalGuesses, defineTotalGuesses
, class GenerateRandomInt, generateRandomInt
, class MakeGuess, makeGuess
)

class (Monad m) <= GetUserInput m where
  getUserInput :: String -> m String

class (Monad m) <= CreateRandomInt m where
  createRandomInt :: Bounds -> m Int

-- Algebras

defineBoundsToAPI :: forall m.
                NotifyUser m =>
                GetUserInput m =>
                m Bounds
defineBoundsToAPI = do
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

defineTotalGuessesToAPI :: forall m.
                      NotifyUser m =>
                      GetUserInput m =>
                      Bounds -> m RemainingGuesses
defineTotalGuessesToAPI bounds = do
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

generateRandomIntToAPI :: forall m.
                          NotifyUser m =>
                          CreateRandomInt m =>
                          Bounds -> m RandomInt
generateRandomIntToAPI bounds = do
  notifyUser $ "Now generating random number..."

  random <- recursivelyRunUntilPure
    (mkRandomInt bounds <$> createRandomInt bounds)

  notifyUser $ "Finished."
  pure random

makeGuessToAPI :: forall m.
                  NotifyUser m =>
                  GetUserInput m =>
                  Bounds -> m Guess
makeGuessToAPI bounds = do
  guess <- recursivelyRunUntilPure
    ((mkGuess bounds) <$> getIntFromUser "Your guess: ")
  pure guess

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
