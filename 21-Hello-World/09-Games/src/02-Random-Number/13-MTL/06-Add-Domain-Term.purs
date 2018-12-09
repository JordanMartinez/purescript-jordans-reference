module Games.RandomNumber.MTL.AddDomainTerm where

import Prelude
import Effect.Random (randomInt)
import Control.Monad.Reader.Trans (ReaderT, runReaderT)
import Control.Monad.Reader.Class (class MonadAsk, ask, asks)
import Effect (Effect)
import Effect.Console (log)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Aff (Aff, runAff_)
import Node.ReadLine (
  Interface
, createConsoleInterface, noCompletion
, close
)
import Type.Equality (class TypeEquals, from)

import Games.RandomNumber.Core (Bounds, unBounds, RandomInt, Guess, RemainingGuesses, GameInfo, GameResult(..), outOfGuesses, decrement, (==#), unRemainingGuesses)
import Games.RandomNumber.MTL.Core (
  game
, class ExplainRules, class SetupGame, class PlayGame
)
import Games.RandomNumber.MTL.Domain (
  class NotifyUser, notifyUser
, class DefineBounds
, class DefineTotalGuesses
, class GenerateRandomInt
, class MakeGuess, makeGuess
, explainRulesToDomain, setupGameToDomain
)
import Games.RandomNumber.MTL.API (
  class GetUserInput
, class CreateRandomInt
, defineBoundsToAPI, defineTotalGuessesToAPI, generateRandomIntToAPI, makeGuessToAPI
)
import Games.RandomNumber.MTL.Infrastructure (Environment, question)

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion

  runAff_
    (\_ -> close interface)
    (runAPI interface game)

runAPI :: Interface -> AppWithJoke ~> Aff
runAPI iface =
  runAppWithJoke
          { notifyUser: liftEffect <<< log
          , getUserInput: question iface
          , createRandomInt: (\l u -> liftEffect $ randomInt l u)
          }

--------------------------

class (Monad m) <= TellJoke m where
  tellJoke :: m Unit

-- Algebras

tellJokeToNotifyUser :: forall m.
                        NotifyUser m =>
                        m Unit
tellJokeToNotifyUser = do
  notifyUser "Why did the chicken cross the road?"
  -- normally one would wait for the user's response here,
  -- but I'm not going to do so to keep this example simple
  notifyUser "To get to the other slide!"
  notifyUser "What!? What do you mean that's not funny!? \
             \...Well, what did you expect!? :-p"

-- Code

gameLoop :: forall m.
            NotifyUser m =>
            -------------
            TellJoke m => -- new capability
            -------------
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

        -- new code! -----
        when (unRemainingGuesses remaining' (_ == 1)) do
          notifyUser "Oh no! Only 1 guess left!? How about I tell you \
                     \a joke to help you calm down?"
          tellJoke
          notifyUser "That was a fun tangent! Back to the game!"
        -------------

        gameLoop bounds randomInt remaining'

-- Need to reimplement this function so it uses the updated `gameLoop` function
playGameToDomain2 :: forall m.
                     NotifyUser m =>
                     TellJoke m =>
                     MakeGuess m =>
                     GameInfo -> m GameResult
playGameToDomain2 { bound: b, number: n, remaining: remaining } = do
  result <- gameLoop b n remaining

  case result of
    PlayerWins remaining' -> do
      notifyUser "Player won!"
      notifyUser $ "Player guessed the random number with " <>
        show remaining' <> " try(s) remaining."
    PlayerLoses randomInt -> do
      notifyUser "Player lost!"
      notifyUser $ "The number was: " <> show randomInt

  pure result

newtype AppWithJoke a = AppWithJoke (ReaderT Environment Aff a)

runAppWithJoke :: Environment -> AppWithJoke ~> Aff
runAppWithJoke env (AppWithJoke m) = runReaderT m env

derive newtype instance a1 :: Functor AppWithJoke
derive newtype instance a2 :: Applicative AppWithJoke
derive newtype instance a3 :: Apply AppWithJoke
derive newtype instance a4 :: Bind AppWithJoke
derive newtype instance a5 :: Monad AppWithJoke
derive newtype instance a6 :: MonadEffect AppWithJoke
derive newtype instance a7 :: MonadAff AppWithJoke

instance monadAskAppWithJoke :: TypeEquals e Environment => MonadAsk e AppWithJoke where
  ask = AppWithJoke $ asks from

--------------------------------

-- Algebras

--------------------------------
-- runCore

instance explainRules :: ExplainRules AppWithJoke where
  explainRules :: AppWithJoke Unit
  explainRules = explainRulesToDomain

instance setupGame :: SetupGame AppWithJoke where
  setupGame = setupGameToDomain

instance playgame :: PlayGame AppWithJoke where
  playGame = playGameToDomain2

--------------------------------
-- runDomain

instance tellJokeAppM :: TellJoke AppWithJoke where
  tellJoke :: AppWithJoke Unit
  tellJoke = tellJokeToNotifyUser

instance defineBounds :: DefineBounds AppWithJoke where
  defineBounds :: AppWithJoke Bounds
  defineBounds = defineBoundsToAPI

instance defineTotalGueses :: DefineTotalGuesses AppWithJoke where
  defineTotalGuesses :: Bounds -> AppWithJoke RemainingGuesses
  defineTotalGuesses = defineTotalGuessesToAPI

instance generateRandomInt :: GenerateRandomInt AppWithJoke where
  generateRandomInt :: Bounds -> AppWithJoke RandomInt
  generateRandomInt = generateRandomIntToAPI

-- Here's where we use a different function instead
instance makeGuess :: MakeGuess AppWithJoke where
  makeGuess :: Bounds -> AppWithJoke Guess
  makeGuess = makeGuessToAPI

--------------------------------
-- runAPI

instance notifyUser :: NotifyUser AppWithJoke where
  notifyUser msg = do
    env <- ask
    liftAff $ env.notifyUser msg

instance getUserInputToInfrastructure :: GetUserInput AppWithJoke where
  getUserInput :: String -> AppWithJoke String
  getUserInput prompt = do
    env <- ask
    liftAff $ env.getUserInput prompt

instance createRandomIntToInfrastructure :: CreateRandomInt AppWithJoke where
  createRandomInt :: Bounds -> AppWithJoke Int
  createRandomInt bounds = do
    env <- ask
    liftAff $ unBounds bounds (\l u -> env.createRandomInt l u)
