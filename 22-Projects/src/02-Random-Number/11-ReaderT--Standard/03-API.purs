module RandomNumber.ReaderT.Standard.API
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
import RandomNumber.Core (Bounds, unBounds)

import RandomNumber.ReaderT.Standard.Domain (
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

derive newtype instance functorAppM :: Functor AppM
derive newtype instance applicativeAppM :: Applicative AppM
derive newtype instance applyAppM :: Apply AppM
derive newtype instance bindAppM :: Bind AppM
derive newtype instance monadAppM :: Monad AppM
derive newtype instance monadEffectAppM :: MonadEffect AppM
derive newtype instance monadAffAppM :: MonadAff AppM

-- Since Environment is type, we need to use TypeEquals
-- to make this work without newtyping Envirnoment
instance monadAskAppM :: TypeEquals e Environment => MonadAsk e AppM where
  ask = AppM $ asks from

-------------------------

instance notifyUserAppM :: NotifyUser AppM where
  notifyUser :: String -> AppM Unit
  notifyUser msg = do
    env <- ask
    liftAff $ env.notifyUser msg

instance getUserInputAppM :: GetUserInput AppM where
  getUserInput :: String -> AppM String
  getUserInput prompt = do
    env <- ask
    liftAff $ env.getUserInput prompt

instance createRandomIntAppM :: CreateRandomInt AppM where
  createRandomInt :: Bounds -> AppM Int
  createRandomInt bounds = do
    env <- ask
    liftAff $ unBounds bounds (\l u -> env.createRandomInt l u)
