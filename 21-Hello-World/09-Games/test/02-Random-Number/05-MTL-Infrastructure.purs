module Test.Games.RandomNumber.MTL.Infrastructure where

import Prelude
import Data.Tuple (Tuple(..))
import Data.Maybe (fromJust)
import Data.Array (uncons)
import Partial.Unsafe (unsafePartial)
import Effect (Effect)

import Control.Monad.Trans.Class (class MonadTrans, lift)
import Control.Monad.Reader.Trans (ReaderT, runReaderT)
import Control.Monad.Reader.Class (class MonadAsk, ask, asks)
import Control.Monad.State (State, runState)
import Control.Monad.State.Class (class MonadState, get, put)
import Type.Equality (class TypeEquals, from)

import Games.RandomNumber.Core (unBounds, GameResult)
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

import Test.QuickCheck (quickCheck, quickCheck',(<?>))
import Test.Games.RandomNumber.Generators (TestData(..))


main :: Effect Unit
main = do

-- Uncomment these two lines to see the da-- TODO: have to figure out how to do implement this function
            -- correctlyta the code generates:
  -- sample <- randomSample genTestData
  -- log $ show $ (\(TestData record) -> record) <$> sample

  -- quickCheck' 1000 (\(TestData record) ->    -- swap this line with next
  quickCheck (\(TestData record) ->             -- to run more tests
    let gameResult = produceGameResult record.random record.userInputs
    in gameResult == record.result <?>
      "GameResult:     " <> show gameResult <> "\n\
      \ExpectedResult: " <> show record.result
  )

runTestApp :: Int -> State (Array String) GameResult
runTestApp random =
  runAppM { notifyUser: (\_ -> pure unit)
          , getUserInput: (\_ -> do
              array <- get
              let {head: nextInput, tail: array'} = unsafePartial $ fromJust $ uncons array
              put array'

              pure nextInput
          )
          , createRandomInt: (\_ _ -> pure random)
          } game

produceGameResult :: Int -> Array String -> GameResult
produceGameResult random userInputs =
  let (Tuple result _) = runState (runTestApp random) userInputs
  in result

type Environment m = { notifyUser :: String -> m Unit
                     , getUserInput :: String -> m String
                     , createRandomInt :: Int -> Int -> m Int
                     }

newtype AppM m a = AppM (ReaderT (Environment m) m a)

runAppM :: Environment (State (Array String)) -> AppM (State (Array String)) ~> State (Array String)
runAppM env (AppM m) = runReaderT m env

derive newtype instance a1 :: (Functor m) => Functor (AppM m)
derive newtype instance a2 :: (Applicative m) => Applicative (AppM m)
derive newtype instance a3 :: (Apply m) => Apply (AppM m)
derive newtype instance a4 :: (Bind m) => Bind (AppM m)
derive newtype instance a5 :: (Monad m) => Monad (AppM m)
derive newtype instance a6 :: MonadTrans AppM

-- instance atrans :: MonadTrans AppM where
--   lift = AppM <<< readerTLift

derive newtype instance a7 :: (MonadState s m) => MonadState s (AppM m)
-- instance a7 :: (MonadState m (Array String)) => MonadState (AppM m) (Array String) where
--   state = lift

-- Since Environment is type, we need to use TypeEquals
-- to make this work without newtyping Envirnoment
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
