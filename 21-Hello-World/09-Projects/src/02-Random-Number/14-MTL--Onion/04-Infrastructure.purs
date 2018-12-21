module Games.RandomNumber.MTL.Infrastructure
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
import Control.Monad.Reader.Trans (ReaderT, runReaderT)
import Control.Monad.Reader.Class (class MonadAsk, ask, asks)
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

-- ReaderT Design Pattern

type Environment = { notifyUser :: String -> Aff Unit
                   , getUserInput :: String -> Aff String
                   , createRandomInt :: Int -> Int -> Aff Int
                   }

newtype AppM a = AppM (ReaderT Environment Aff a)

runAppM :: Environment -> AppM ~> Aff
runAppM env (AppM m) = runReaderT m env

derive newtype instance a1 :: Functor AppM
derive newtype instance a2 :: Applicative AppM
derive newtype instance a3 :: Apply AppM
derive newtype instance a4 :: Bind AppM
derive newtype instance a5 :: Monad AppM
derive newtype instance a6 :: MonadEffect AppM
derive newtype instance a7 :: MonadAff AppM

-- Since Environment is type, we need to use TypeEquals
-- to make this work without newtyping Envirnoment
instance monadAskAppM :: TypeEquals e Environment => MonadAsk e AppM where
  ask = AppM $ asks from

-- Algebras

--------------------------------
-- runCore

instance explainRules :: ExplainRules AppM where
  explainRules :: AppM Unit
  explainRules = explainRulesToDomain

instance setupGame :: SetupGame AppM where
  setupGame = setupGameToDomain

instance playgame :: PlayGame AppM where
  playGame = playGameToDomain

--------------------------------
-- runDomain

instance defineBounds :: DefineBounds AppM where
  defineBounds :: AppM Bounds
  defineBounds = defineBoundsToAPI

instance defineTotalGueses :: DefineTotalGuesses AppM where
  defineTotalGuesses :: Bounds -> AppM RemainingGuesses
  defineTotalGuesses = defineTotalGuessesToAPI

instance generateRandomInt :: GenerateRandomInt AppM where
  generateRandomInt :: Bounds -> AppM RandomInt
  generateRandomInt = generateRandomIntToAPI

instance makeGuess :: MakeGuess AppM where
  makeGuess :: Bounds -> AppM Guess
  makeGuess = makeGuessToAPI

--------------------------------
-- runAPI

instance notifyUser :: NotifyUser AppM where
  notifyUser msg = do
    env <- ask
    liftAff $ env.notifyUser msg

instance getUserInputToInfrastructure :: GetUserInput AppM where
  getUserInput :: String -> AppM String
  getUserInput prompt = do
    env <- ask
    liftAff $ env.getUserInput prompt

instance createRandomIntToInfrastructure :: CreateRandomInt AppM where
  createRandomInt :: Bounds -> AppM Int
  createRandomInt bounds = do
    env <- ask
    liftAff $ unBounds bounds (\l u -> env.createRandomInt l u)

-- Code for Infrastructure

question :: Interface -> String -> Aff String
question interface message = do
  makeAff go
  where
    go handler = NR.question message (handler <<< Right) interface $> mempty

runAPI :: Interface -> AppM ~> Aff
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
