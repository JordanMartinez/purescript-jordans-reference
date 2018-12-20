module Games.RandomNumber.MTL.SameMonad
  ( Environment
  , AppM(..), runAppM

  , question
  , runAPI

  , main
  )
  where

import Prelude
import Data.Either (Either(..))
import Effect.Random (randomInt)
import Control.Monad.Trans.Class (class MonadTrans, lift)
import Control.Monad.Reader.Trans (ReaderT, runReaderT)
import Control.Monad.Reader.Class (class MonadAsk, ask, asks)
import Control.Monad.State.Class (class MonadState)
import Effect (Effect)
import Effect.Console (log)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Aff (Aff, runAff_, makeAff)
import Node.ReadLine (
  Interface
, createConsoleInterface, noCompletion
, close
)
import Node.ReadLine as NR
import Type.Equality (class TypeEquals, from)

import Games.RandomNumber.Core (Bounds, unBounds, RandomInt, Guess, RemainingGuesses)
import Games.RandomNumber.MTL.Core (
  game
, class ExplainRules, class SetupGame, class PlayGame
)
import Games.RandomNumber.MTL.Domain (
  class NotifyUser
, class DefineBounds
, class DefineTotalGuesses
, class GenerateRandomInt
, class MakeGuess
, explainRulesToDomain, setupGameToDomain, playGameToDomain
)
import Games.RandomNumber.MTL.API (
  class GetUserInput
, class CreateRandomInt
, defineBoundsToAPI, defineTotalGuessesToAPI, generateRandomIntToAPI, makeGuessToAPI
)

-- Our types are updated to include a new 'm' type in their type definition
type Environment m = { notifyUser :: String -> m Unit
                     , getUserInput :: String -> m String
                     , createRandomInt :: Int -> Int -> m Int
                     }

newtype AppM m a = AppM (ReaderT (Environment m) m a)

runAppM :: forall m. Environment m -> AppM m ~> m
runAppM env (AppM m) = runReaderT m env

-- Our derived type classes look a little different than before
-- We need to add `m` to AppM so that it's kind is correct: Type -> Type
-- However, to guarantee that this type is the Monad that ReaderT
-- expects, we need to add these constraints as well.
derive newtype instance a1 :: (Functor m) => Functor (AppM m)
derive newtype instance a2 :: (Applicative m) => Applicative (AppM m)
derive newtype instance a3 :: (Apply m) => Apply (AppM m)
derive newtype instance a4 :: (Bind m) => Bind (AppM m)
derive newtype instance a5 :: (Monad m) => Monad (AppM m)
derive newtype instance a6 :: MonadTrans AppM

-- Defining this here because we'll use it in the Test module
derive newtype instance a7 :: (MonadState s m) => MonadState s (AppM m)

-- everything else below is the same as before.
instance monadAskAppM :: (Monad m, TypeEquals e (Environment m)) => MonadAsk e (AppM m) where
  ask = AppM $ asks from

-- Algebras

--------------------------------
-- runCore

instance explainRules :: (Monad m) => ExplainRules (AppM m) where
  explainRules = explainRulesToDomain

instance setupGame :: (Monad m) => SetupGame (AppM m) where
  setupGame = setupGameToDomain

instance playgame :: (Monad m) => PlayGame (AppM m) where
  playGame = playGameToDomain

--------------------------------
-- runDomain

instance defineBounds :: (Monad m) => DefineBounds (AppM m) where
  defineBounds = defineBoundsToAPI

instance defineTotalGueses :: (Monad m) => DefineTotalGuesses (AppM m) where
  defineTotalGuesses = defineTotalGuessesToAPI

instance generateRandomInt :: (Monad m) => GenerateRandomInt (AppM m) where
  generateRandomInt = generateRandomIntToAPI

instance makeGuess :: (Monad m) => MakeGuess (AppM m) where
  makeGuess = makeGuessToAPI

--------------------------------
-- runAPI

instance notifyUser :: (Monad m) => NotifyUser (AppM m) where
  notifyUser msg = do
    env <- ask
    lift $ env.notifyUser msg

instance getUserInputToInfrastructure :: (Monad m) => GetUserInput (AppM m) where
  getUserInput prompt = do
    env <- ask
    lift $ env.getUserInput prompt

instance createRandomIntToInfrastructure :: (Monad m) => CreateRandomInt (AppM m) where
  createRandomInt bounds = do
    env <- ask
    lift $ unBounds bounds (\l u -> env.createRandomInt l u)

-- Code for Infrastructure

question :: Interface -> String -> Aff String
question interface message = do
  makeAff go
  where
    go handler = NR.question message (handler <<< Right) interface $> mempty

runAPI :: Interface -> AppM Aff ~> Aff
runAPI iface =
  runAppM { notifyUser: liftEffect <<< log
          , getUserInput: question iface
          , createRandomInt: (\l u -> liftEffect $ randomInt l u) }

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion

  runAff_
    (\_ -> close interface)
    (runAPI interface game)
