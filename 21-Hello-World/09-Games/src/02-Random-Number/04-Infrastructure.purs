module Game.RandomNumber.Infrastructure (main) where

import Prelude
import Control.Monad.Free (foldFree)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Int (fromString)
import Effect.Random (randomInt)
import Effect.Class (liftEffect)
import Effect (Effect)
import Effect.Console (log)
import Effect.Aff (Aff, runAff_, makeAff)
import Node.ReadLine ( Interface
                     , createConsoleInterface, noCompletion
                     , close
                     )
import Node.ReadLine as NR

import Games.RandomNumber.Core ( Bounds, mkBounds, unBounds
                               , RandomInt, mkRandomInt
                               , Guess, mkGuess
                               , Count, mkCount
                               )
import Games.RandomNumber.Domain (game)
import Games.RandomNumber.API ( RandomNumberOperationF(..)
                              , RandomNumberOperation
                              , runGame
                              )

question :: String -> Interface -> Aff String
question message interface = do
  makeAff go
  where
    go handler = NR.question message (handler <<< Right) interface $> mempty

logAff :: String -> Aff Unit
logAff msg = liftEffect $ log msg

data InputError = NotAnInt String
instance ies :: Show InputError where
  show (NotAnInt s) = "User inputted a non-integer value: " <> s

inputIsInt :: String -> Either InputError Int
inputIsInt s = case fromString s of
  Just i -> Right i
  Nothing -> Left $ NotAnInt s

getInt :: Interface -> String -> Aff Int
getInt iface prompt = do
  result <- question prompt iface
  case inputIsInt result of
    Left e -> do
      logAff $ show e <> " Please try again."
      getInt iface prompt
    Right i -> pure i

getBounds :: Interface -> Aff Bounds
getBounds iface = do
  result <- mkBounds <$>
              (getInt iface "Please enter an upper or lower bound: ") <*>
              (getInt iface "Please enter the other bound: ")
  case result of
    Left e -> do
      logAff $ show e <> " Please try again."
      getBounds iface
    Right b -> pure b

getCount :: Interface -> Aff Count
getCount iface = do
  result <- mkCount <$> (getInt iface "Please enter the number of guesses: ")
  case result of
    Left e -> do
      logAff $ show e <> " Please try again."
      getCount iface
    Right c -> pure c

genRandomInt :: Bounds -> Aff RandomInt
genRandomInt bounds = do
  randomInt <- unBounds bounds (\l u -> liftEffect $ randomInt l u)
  case mkRandomInt bounds randomInt of
    Left e -> do
      logAff $ show e <> " Please try again."
      genRandomInt bounds
    Right r -> pure r

guess :: Interface -> Bounds -> Aff Guess
guess iface b = do
  result <- (mkGuess b) <$>
    (getInt iface $ "Please guess an integer between " <> show b <> ": ")
  case result of
      Left e -> do
        logAff $ show e <> " Please try again."
        guess iface b
      Right g -> pure g

runRandomNumberOperation :: Interface -> RandomNumberOperation ~> Aff
runRandomNumberOperation iface_ = foldFree (go iface_)

  where
  go :: Interface -> RandomNumberOperationF ~> Aff
  go iface = case _ of
    LogOutput msg next -> do
      logAff msg
      pure next
    DefineBounds reply -> do
      bounds <- getBounds iface

      pure (reply bounds)
    DefineCount reply -> do
      count <- getCount iface

      pure (reply count)
    GenerateRandomInt bounds reply -> do
      randomInt <- genRandomInt bounds

      pure (reply randomInt)

    MakeGuess bounds reply -> do
      g <- guess iface bounds
      pure (reply g)

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion

  runAff_
    (\_ -> close interface)
    (runRandomNumberOperation interface (runGame game))
