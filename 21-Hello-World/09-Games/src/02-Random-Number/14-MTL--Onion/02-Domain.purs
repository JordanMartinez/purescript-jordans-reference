module Games.RandomNumber.MTL.Domain
  ( class NotifyUser, notifyUser
  , class DefineBounds, defineBounds
  , class DefineTotalGuesses, defineTotalGuesses
  , class GenerateRandomInt, generateRandomInt
  , class MakeGuess, makeGuess

  , explainRulesToDomain
  , setupGameToDomain
  , playGameToDomain
  , gameLoop
  ) where

import Prelude
import Control.Monad.Trans.Class (class MonadTrans, lift)
import Games.RandomNumber.Core ( Bounds
                               , RandomInt, Guess, (==#)
                               , RemainingGuesses, outOfGuesses, decrement
                               , GameResult(..)
                               , mkGameInfo
                               , GameInfo, GameResult
                               )
import Games.RandomNumber.MTL.Core (
  class ExplainRules
, class SetupGame
, class PlayGame
)

class (Monad m) <= NotifyUser m where
  notifyUser :: String -> m Unit

class (Monad m) <= DefineBounds m where
  defineBounds :: m Bounds

class (Monad m) <= DefineTotalGuesses m where
  defineTotalGuesses :: Bounds -> m RemainingGuesses

class (Monad m) <= GenerateRandomInt m where
  generateRandomInt :: Bounds -> m RandomInt

class (Monad m) <= MakeGuess m where
  makeGuess :: Bounds -> m Guess

-- Algebras

explainRulesToDomain :: forall m. (NotifyUser m) => m Unit
explainRulesToDomain = do
  notifyUser "This is a random integer guessing game. \
             \In this game, you must try to guess the random integer \
             \before running out of guesses."

setupGameToDomain :: forall m.
                     NotifyUser m =>
                     DefineBounds m =>
                     DefineTotalGuesses m =>
                     GenerateRandomInt m =>
                     m GameInfo
setupGameToDomain = do
  notifyUser "Before we play the game, the computer needs you to \
             \define two things."

  bounds <- defineBounds
  totalGueses <- defineTotalGuesses bounds
  randomInt <- generateRandomInt bounds

  notifyUser $ "Everything is set. You will have " <> show totalGueses <>
               " guesses to guess a number between " <> show bounds <>
               ". Good luck!"

  pure $ mkGameInfo bounds randomInt totalGueses

playGameToDomain :: forall m.
                    NotifyUser m =>
                    MakeGuess m =>
                    GameInfo -> m GameResult
playGameToDomain { bound: b, number: n, remaining: remaining } = do
  result <- gameLoop b n remaining

  case result of
    PlayerWins remaining -> do
      notifyUser "Player won!"
      notifyUser $ "Player guessed the random number with " <>
        show remaining <> " try(s) remaining."
    PlayerLoses randomInt -> do
      notifyUser "Player lost!"
      notifyUser $ "The number was: " <> show randomInt

  pure result

-- Code

-- | Calls `makeGuess` recursively until either the random number is
-- | correctly guessed or the player runs out of guesses
-- | MonadRec is not used here because `Aff` is stack-safe
gameLoop :: forall m.
            NotifyUser m =>
            MakeGuess m =>
            Bounds -> RandomInt -> RemainingGuesses ->
            m GameResult
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
