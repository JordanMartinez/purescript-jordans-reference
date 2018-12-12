module Test.Games.RandomNumber.MTL.SameMonad where

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

  -- quickCheck' 1000 (\(TestData record) ->    -- swap this line with next
  quickCheck (\(TestData record) ->             -- to run more tests
    let gameResult = produceGameResult record.random record.userInputs
    in gameResult == record.result <?>
      "GameResult:     " <> show gameResult <> "\n\
      \ExpectedResult: " <> show record.result
  )

{-
The difference in this file from the MTL-Different-Monad lies in a few ideas:
- We delegate the Infrastructure implementation to the Environment type.
    This new type will store all the API functions we need. Thus, we can
    use the same monad for both test and production code.
- Thus, we need to update Environment and AppM to take a monad type in their
     type constructor (e.g. AppM a -> AppM m a)
- We will also need to change how we derive AppM's type class instances.
-}

runTestApp :: Int -> State (Array String) GameResult
runTestApp random =
  runAppM { notifyUser: (\_ -> pure unit)

          {-
          Here, we'll use the State monad to run our state-like operations
          to get the next user input
          -}
          , getUserInput: (\_ -> do
              array <- get
              let {head: nextInput, tail: array'} = unsafePartial $ fromJust $ uncons array
              put array'

              pure nextInput
          )
          , createRandomInt: (\_ _ -> pure random)
          } game

-- Here is where we combine the AppM and State monad together
-- to get our final computed game result
produceGameResult :: Int -> Array String -> GameResult
produceGameResult random userInputs =
  let (Tuple result _) = runState (runTestApp random) userInputs
  in result

-- Our types are updated to include a new 'm' type in their type definition
type Environment m = { notifyUser :: String -> m Unit
                     , getUserInput :: String -> m String
                     , createRandomInt :: Int -> Int -> m Int
                     }

newtype AppM m a = AppM (ReaderT (Environment m) m a)

runAppM :: forall m. Environment m -> AppM m ~> m
runAppM env (AppM m) = runReaderT m env

-- Our dervied type classes look a little different than before
-- We need to add `m` to AppM so that its' kind is correct: Type -> Type
-- However, to guarantee that this type is the Monad that ReaderT
-- expects, we need to add these constraints as well.
derive newtype instance a1 :: (Functor m) => Functor (AppM m)
derive newtype instance a2 :: (Applicative m) => Applicative (AppM m)
derive newtype instance a3 :: (Apply m) => Apply (AppM m)
derive newtype instance a4 :: (Bind m) => Bind (AppM m)
derive newtype instance a5 :: (Monad m) => Monad (AppM m)
derive newtype instance a6 :: MonadTrans AppM

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
