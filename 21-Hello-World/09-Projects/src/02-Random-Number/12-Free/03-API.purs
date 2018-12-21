module Games.RandomNumber.Free.API (API_F(..), API, runDomain) where

import Prelude

import Control.Monad.Free (Free, liftF, substFree)
import Data.Int (fromString)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Games.RandomNumber.Core ( Bounds, mkBounds, mkGuess, mkRandomInt
                               , mkRemainingGuesses, totalPossibleGuesses
                               )

import Games.RandomNumber.Free.Domain (RandomNumberGameF(..), Game)

data API_F a
  = Log String a
  | GetUserInput String (String -> a)
  | GenRandomInt Bounds (Int -> a)

derive instance f :: Functor API_F

-- `Free` stuff

type API = Free API_F

getUserInput :: String -> API String
getUserInput prompt = liftF $ (GetUserInput prompt identity)

log :: String -> API Unit
log msg = liftF $ (Log msg unit)

genRandomInt :: Bounds -> API Int
genRandomInt bounds = liftF $ (GenRandomInt bounds identity)

recursivelyRunUntilPure :: forall e a. Show e => API (Either e a) -> API a
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

-- domain -> API
runDomain :: Game ~> API
runDomain = substFree go

  where
  getIntFromUser :: String -> API Int
  getIntFromUser prompt =
    recursivelyRunUntilPure (inputIsInt <$> getUserInput prompt)

  go :: RandomNumberGameF ~> API
  go = case _ of
    NotifyUser msg next -> do
      log msg
      pure next

    DefineBounds reply -> do
      log "Please, define the range from which to choose a random integer. \
          \This could be something easy like '1 to 5' or something hard like \
          \`1 to 100`. The range can also include negative numbers \
          \(e.g. '-10 to -1' or '-100 to 100')"

      bounds <- recursivelyRunUntilPure
        (mkBounds
          <$> getIntFromUser "Please enter either the lower or upper bound: "
          <*> getIntFromUser "Please enter the other bound: ")

      log $ "The random number will be between " <> show bounds <> "."
      pure (reply bounds)

    DefineTotalGuesses bounds reply -> do
      log $ "Please, define the number of guesses you will have. This must \
          \be a postive number. Note: due to the bounds you defined, there are "
          <> (show $ totalPossibleGuesses bounds) <> " possible answers."

      totalGuesses <- recursivelyRunUntilPure
        (mkRemainingGuesses <$>
          getIntFromUser "Please enter the total number of guesses: ")

      log $ "You have limited yourself to " <> show totalGuesses <> " guesses."
      pure (reply totalGuesses)

    GenerateRandomInt bounds reply -> do
      log $ "Now generating random number..."

      random <- recursivelyRunUntilPure
        (mkRandomInt bounds <$> genRandomInt bounds)

      log $ "Finished."
      pure (reply random)

    MakeGuess bounds reply -> do
      guess <- recursivelyRunUntilPure
        ((mkGuess bounds) <$> getIntFromUser "Your guess: ")
      pure (reply guess)
