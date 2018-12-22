module Games.RandomNumber.ReaderT.Standard.API
  ( Environment
  , AppM(..), runAppM
  )
  where

import Prelude
import Control.Monad.Reader.Trans (ReaderT, runReaderT)
import Control.Monad.Reader.Class (class MonadAsk, ask, asks)
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect)
import Games.RandomNumber.Core (Bounds, unBounds)

import Games.RandomNumber.ReaderT.Standard.Domain (
  class NotifyUser
, class GetUserInput
, class CreateRandomInt
)
import Type.Equality (class TypeEquals, from)

-- ReaderT Design Pattern

type Environment = { notifyUser :: String -> Aff Unit
                   , getUserInput :: String -> Aff String
                   , createRandomInt :: Int -> Int -> Aff Int
                   }

-- While this type is a newtype wrapper around ReaderT, this type
-- is not a monad transformer. It's just a monad. Thus, we'll add
-- the "M" suffix to indicate that.
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

-------------------------

instance notifyUser :: NotifyUser AppM where
  notifyUser :: String -> AppM Unit
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
