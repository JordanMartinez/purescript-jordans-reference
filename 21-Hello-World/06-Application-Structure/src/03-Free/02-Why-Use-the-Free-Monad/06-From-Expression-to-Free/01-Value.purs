module Free.Value (value, iter) where

import Prelude
import Control.Monad.Free (Free, resume)
import Data.Either (Either(..))

-- First, we define the value smart constructor
value :: forall f a. Functor f => a -> Free f a
value a = pure a

-- Second, we'll define the `iter` function we saw earlier here.
-- This will allow us to easily reuse it in the upcoming files
iter :: forall f a. Functor f => (f a -> a) -> Free f a -> a
iter k = go where
  go m = case resume m of
    Left f -> k (go <$> f)
    Right a -> a
