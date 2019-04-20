module Test.RandomNumber.ReaderT.Standard.DifferentMonad
  ( main
  , produceGameResult
  ) where

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

import RandomNumber.Core (Bounds, unBounds, GameResult)
import RandomNumber.ReaderT.Standard.Domain (
  game
, class NotifyUser
, class GetUserInput
, class CreateRandomInt
)

import Test.QuickCheck (quickCheck, quickCheck',(<?>))
import Test.RandomNumber.Generators (TestData(..))


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

newtype TestM a = TestM (ReaderT Environment StateMonad_User_Inputs a)

runTestM :: Environment -> TestM ~> StateMonad_User_Inputs
runTestM env (TestM m) = runReaderT m env

produceGameResult :: Int -> Array String -> GameResult
produceGameResult random userInputs =
  let (Tuple result _) = runState (runTestApp random) userInputs
  in result

                  -- StateT (Array String) Identity GameResult
                  -- State  (Array String)          GameResult
runTestApp :: Int -> StateMonad_User_Inputs GameResult
runTestApp random =
  runTestM { notifyUser: (\_ -> pure unit)
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
- Because `TestM` has kind `Type` instead of `Type -> Type`, we cannot
    derive an instance for `MonadTrans` and gain access to `lift`.
    Thus, we'll need to implement things ourselves. See the API
    type classes for a better explanation as to what I mean.

---------------------------------------------                         -}

derive newtype instance functorTestM :: Functor TestM
derive newtype instance applicativeTestM :: Applicative TestM
derive newtype instance applyTestM :: Apply TestM
derive newtype instance bindTestM :: Bind TestM
derive newtype instance monadTestM :: Monad TestM

instance monadAskTestM :: TypeEquals e Environment => MonadAsk e TestM where
  ask = TestM $ asks from

--------------------------------
                                                                            {-
In our production monad, we would write `notifyUser` instance like so:
  notifyUser msg = do
    env <- ask
    liftAff $ env.notifyUser msg

This worked because we were interpreting our AppM monad into Aff
(i.e. AppM ~> Aff)

However, in our test monad, we cannot write the same-looking code
because we can not define `MonadTrans` for `TestM` as it has kind `Type`
and not kind `Type -> Type`.
  notifyUser msg = do
    env <- ask
    lift $ env.notifyUser msg

Thus, we must resort to this code:
  notifyUser msg =
    TestM $ ReaderT (\env -> env.notifyUser msg)

which means `MonadAsk` for our test monad is rather pointless
-}
instance notifyUserTestM :: NotifyUser TestM where
  notifyUser :: String -> TestM Unit
  notifyUser msg =
    TestM $ ReaderT (\env -> env.notifyUser msg)

instance getUserInputTestM :: GetUserInput TestM where
  getUserInput :: String -> TestM String
  getUserInput prompt =
    TestM $ ReaderT (\env -> env.getUserInput prompt)

instance createRandomIntTestM :: CreateRandomInt TestM where
  createRandomInt :: Bounds -> TestM Int
  createRandomInt bounds =
    TestM $ ReaderT (\env -> unBounds bounds (\l u -> env.createRandomInt l u))
