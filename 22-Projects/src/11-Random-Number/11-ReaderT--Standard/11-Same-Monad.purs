module RandomNumber.ReaderT.Standard.SameMonad
  ( Environment
  , AppT(..), runAppT

  , runAPI

  , main
  )
  where

import Prelude
import Effect.Random (randomInt)
import Control.Monad.Trans.Class (class MonadTrans, lift)
import Control.Monad.Reader.Trans (ReaderT, runReaderT)
import Control.Monad.Reader.Class (class MonadAsk, ask, asks)
import Control.Monad.State.Class (class MonadState)
import Effect (Effect)
import Effect.Aff (Aff, runAff_)
import Effect.Console (log)
import Effect.Class (liftEffect)
import Node.ReadLine (
  Interface
, createConsoleInterface, noCompletion
, close
)
import Type.Equality (class TypeEquals, from)

import RandomNumber.Core (unBounds)
import RandomNumber.Infrastructure.ReadLineAff (question)
import RandomNumber.ReaderT.Standard.Domain (
  game
, class NotifyUser
, class GetUserInput
, class CreateRandomInt
)

-- Our types are updated to include a new 'm' type in their type definition
type Environment m = { notifyUser :: String -> m Unit
                     , getUserInput :: String -> m String
                     , createRandomInt :: Int -> Int -> m Int
                     }

-- Since thie type works just like a monad transformer,
-- we'll add the "T" suffix to indicate that it is a monad transformer.
newtype AppT m a = AppT (ReaderT (Environment m) m a)

runAppT :: forall m. Environment m -> AppT m ~> m
runAppT env (AppT m) = runReaderT m env

-- Our derived type classes look a little different than before
-- We need to add `m` to AppT so that it's kind is correct: Type -> Type
-- However, to guarantee that this type is the Monad that ReaderT
-- expects, we need to add these constraints as well.
derive newtype instance functorAppT :: (Functor m) => Functor (AppT m)
derive newtype instance applicativeAppT :: (Applicative m) => Applicative (AppT m)
derive newtype instance applyAppT :: (Apply m) => Apply (AppT m)
derive newtype instance bindAppT :: (Bind m) => Bind (AppT m)
derive newtype instance monadAppT :: (Monad m) => Monad (AppT m)
derive newtype instance monadTransAppT :: MonadTrans AppT

-- Defining this here because we'll use it in the Test module
derive newtype instance monadStateAppT :: (MonadState s m) => MonadState s (AppT m)

-- everything else below is the same as before.
instance monadAskAppT :: (Monad m, TypeEquals e (Environment m)) => MonadAsk e (AppT m) where
  ask = AppT $ asks from

--------------------------------

instance notifyUserAppT :: (Monad m) => NotifyUser (AppT m) where
  notifyUser msg = do
    env <- ask
    lift $ env.notifyUser msg

instance getUserInputAppT :: (Monad m) => GetUserInput (AppT m) where
  getUserInput prompt = do
    env <- ask
    lift $ env.getUserInput prompt

instance createRandomIntAppT :: (Monad m) => CreateRandomInt (AppT m) where
  createRandomInt bounds = do
    env <- ask
    lift $ unBounds bounds (\l u -> env.createRandomInt l u)

-- Code for Infrastructure

runAPI :: Interface -> AppT Aff ~> Aff
runAPI iface =
  runAppT { notifyUser: liftEffect <<< log
          , getUserInput: question iface
          , createRandomInt: (\l u -> liftEffect $ randomInt l u) }

-- Level 0 / Machine Code
main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion

  runAff_
    (\_ -> close interface)
    (runAPI interface game)
