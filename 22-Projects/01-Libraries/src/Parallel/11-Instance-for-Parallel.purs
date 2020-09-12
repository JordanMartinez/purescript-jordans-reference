module Learn.Parallel.Instance
  ( AppM(..), runAppM
  -- Don't forget to export ParAppM!
  -- Otherwise, you get an unhelpful Type Class Constraint error
  , ParAppM(..)
  , Env
  ) where

import Prelude

import Control.Monad.Reader (class MonadAsk, ReaderT, asks, runReaderT)
import Control.Parallel (class Parallel, parallel, sequential)
import Effect.Aff (Aff, ParAff)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect)
import Type.Equality (class TypeEquals, from)

-- Simple Environment info
type Env = { name :: String }

-- | The 'sequential' version of our application's monad.
-- | Base monad here is the 'sequential' version of Aff.
newtype AppM a = AppM (ReaderT Env Aff a)

runAppM :: Env -> AppM ~> Aff
runAppM env (AppM m) = runReaderT m env

instance monadAskAppM :: TypeEquals e Env => MonadAsk e AppM where
  ask = AppM $ asks from

derive newtype instance functorAppM :: Functor AppM
derive newtype instance applyAppM :: Apply AppM
derive newtype instance applicativeAppM :: Applicative AppM
derive newtype instance bindAppM :: Bind AppM
derive newtype instance monadAppM :: Monad AppM
derive newtype instance monadEffectAppM :: MonadEffect AppM
derive newtype instance monadAffAppM :: MonadAff AppM

-- | The 'parallel' version of our application's monad.
-- | The base monad here is the parallel version of `Aff`: `ParAff`
newtype ParAppM a = ParAppM (ReaderT Env ParAff a)

derive newtype instance functorParAppM :: Functor ParAppM
derive newtype instance applyParAppM :: Apply ParAppM
derive newtype instance applicativeParAppM :: Applicative ParAppM

-- Now we can implement Parallel for our AppM
-- by delegating it to the underlying base monads
instance parallelAppM :: Parallel ParAppM AppM where
  parallel (AppM readerT) = ParAppM $ parallel readerT

  sequential (ParAppM readerT) = AppM $ sequential readerT
