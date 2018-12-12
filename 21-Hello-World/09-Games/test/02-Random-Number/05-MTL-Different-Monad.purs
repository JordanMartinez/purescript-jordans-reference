module Test.Games.RandomNumber.MTL.DifferentMonad where

import Prelude
import Data.Tuple (Tuple(..))
import Data.Maybe (fromJust)
import Data.Array (uncons)
import Partial.Unsafe (unsafePartial)
import Effect (Effect)

import Control.Monad.Reader.Trans (ReaderT(..), runReaderT)
import Control.Monad.Reader.Class (class MonadAsk, asks)
import Control.Monad.State (State, runState)
import Control.Monad.State.Class (get, put)
import Type.Equality (class TypeEquals, from)

import Games.RandomNumber.Core (Bounds, unBounds, GameResult, Guess, RandomInt, RemainingGuesses)
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

-- State (Array String) will be used to
-- return a different String each time we call
-- `getUserInput` via the State monad.
--
-- It replaces `Aff` as the base Monad that ReaderT transforms.
type StateMonad_User_Inputs = State (Array String)

type Environment = { notifyUser :: String -> StateMonad_User_Inputs Unit
                   , getUserInput :: String -> StateMonad_User_Inputs String
                   , createRandomInt :: Int -> Int -> StateMonad_User_Inputs Int
                   }

newtype AppM a = AppM (ReaderT Environment StateMonad_User_Inputs a)

runAppM :: Environment -> AppM ~> StateMonad_User_Inputs
runAppM env (AppM m) = runReaderT m env

produceGameResult :: Int -> Array String -> GameResult
produceGameResult random userInputs =
  let (Tuple result _) = runState (runTestApp random) userInputs
  in result

                  -- StateT (Array String) Identity GameResult
                  -- State  (Array String)          GameResult
runTestApp :: Int -> StateMonad_User_Inputs GameResult
runTestApp random =
  runAppM { notifyUser: (\_ -> pure unit)
          , getUserInput: (\_ -> do
              array <- get
              let { head: nextInput, tail: array' } = unsafePartial $ fromJust $ uncons array
              put array'

              pure nextInput
          )
          , createRandomInt: (\_ _ -> pure random)
          } game

                                                                      {-
Below, only a few things differ from the production monad:
- We no longer derive an instance for MonadEffect/MonadAff
- Because `AppM` has kind `Type` instead of `Type -> Type`, we cannot
    derive an instance for `MonadTrans` and gain access to `lift`.
    Thus, we'll need to implement things ourselves. See the API
    type classes for a better explanation as to what I mean.

---------------------------------------------                         -}

derive newtype instance a1 :: Functor AppM
derive newtype instance a2 :: Applicative AppM
derive newtype instance a3 :: Apply AppM
derive newtype instance a4 :: Bind AppM
derive newtype instance a5 :: Monad AppM

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
                                                                            {-
In our production monad, we would write `notifyUser` instance like so:
  notifyUser msg = do
    env <- ask
    liftAff $ env.notifyUser msg

This worked because we were interpreting our AppM monad into Aff
(i.e. AppM ~> Aff)

However, in our test monad, we cannot write the same-looking code
because we can not define `MonadTrans` for `AppM` as it has kind `Type`
and not kind `Type -> Type`.
  notifyUser msg = do
    env <- ask
    lift $ env.notifyUser msg

Thus, we must resort to this code:
  notifyUser msg =
    AppM $ ReaderT (\env -> env.notifyUser msg)

which means `MonadAsk` for our test monad is rather pointless
-}
instance notifyUser :: NotifyUser AppM where
  notifyUser :: String -> AppM Unit
  notifyUser msg =
    AppM $ ReaderT (\env -> env.notifyUser msg)

instance getUserInputToInfrastructure :: GetUserInput AppM where
  getUserInput :: String -> AppM String
  getUserInput prompt =
    AppM $ ReaderT (\env -> env.getUserInput prompt)

instance createRandomIntToInfrastructure :: CreateRandomInt AppM where
  createRandomInt :: Bounds -> AppM Int
  createRandomInt bounds =
    AppM $ ReaderT (\env -> unBounds bounds (\l u -> env.createRandomInt l u))
