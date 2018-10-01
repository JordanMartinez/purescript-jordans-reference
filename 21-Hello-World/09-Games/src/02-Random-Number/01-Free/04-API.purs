module Games.RandomNumber.Free.API (API_F(..), API, runDomain) where

import Prelude

import Control.Monad.Free (Free, liftF, substFree)
import Data.Int (fromString)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Games.RandomNumber.Free.Core ( Bounds, mkBounds, mkGuess, mkRandomInt
                                    , mkRemainingGuesses
                                    )

import Games.RandomNumber.Free.Domain (RandomNumberOperationF(..), RandomNumberOperation)

import Games.RandomNumber.Free.API (API_F(..))

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

runDomain :: RandomNumberOperation ~> API
runDomain = substFree go

  where
  getIntFromUser :: String -> API Int
  getIntFromUser prompt =
    recursivelyRunUntilPure (inputIsInt <$> getUserInput prompt)

  go :: RandomNumberOperationF ~> API
  go = case _ of
    NotifyUser msg next -> do
      log msg
      pure next

    DefineBounds reply -> do
      bounds <- recursivelyRunUntilPure
        (mkBounds
          <$> getIntFromUser "Please enter either the lower or upper bound: "
          <*> getIntFromUser "Please enter the other bound: ")
      pure (reply bounds)

    DefineTotalGuesses reply -> do
      totalGuesses <- recursivelyRunUntilPure
        (mkRemainingGuesses <$>
          getIntFromUser "Please enter the total number of guesses: ")
      pure (reply totalGuesses)

    GenerateRandomInt bounds reply -> do
      random <- recursivelyRunUntilPure
        (mkRandomInt bounds <$> genRandomInt bounds)
      pure (reply random)

    MakeGuess bounds reply -> do
      guess <- recursivelyRunUntilPure
        ((mkGuess bounds) <$> getIntFromUser "Your guess: ")
      pure (reply guess)
