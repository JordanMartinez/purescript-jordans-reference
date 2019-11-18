module Syntax.Modification.MonadLikeTypeClasses
  ( class IxFunctor, imap, map
  , class IxApply, iapply, apply
  , class IxApplicative, ipure, pure
  , class IxBind, ibind, bind
  , class IxMonad
  , Box(..)
  ) where

import Data.Unit (Unit)
import Data.Show (class Show, show)
import Data.Semigroup ((<>))

-- Given a data type with instances for the IndexedMonad type class
-- hierarchy (type class instances are below each type class)
data Box phantomInput phantomOutput storedValue = Box storedValue

instance showBox :: (Show a) => Show (Box x x a) where
  show (Box a) = "Box(" <> show a <> ")"

-- Requirement 1: type classes that are similar to Functor to Monad hierarchy
--  - ado requirements: Functor, Apply, and Applicative
--  - do requirements: Functor, Apply, Applicative, Bind, and Monad

class IxFunctor f where
  imap :: forall a b x. (a -> b) -> f   x x a -> f   x x b

instance ixFunctorBox :: IxFunctor Box where
  imap :: forall a b x. (a -> b) -> Box x x a -> Box x x b
  imap f (Box a) = Box (f a)


class (IxFunctor f) <= IxApply f where
  iapply :: forall a b x y z. f   x y (a -> b) -> f   y z a -> f   x z b

instance ixApplyBox :: IxApply Box where
  iapply :: forall a b x y z. Box x y (a -> b) -> Box y z a -> Box x z b
  iapply (Box f) (Box a) = Box (f a)


class (IxApply f) <= IxApplicative f where
  ipure :: forall a x. a -> f   x x a

instance ixApplicativeBox :: IxApplicative Box where
  ipure :: forall a x. a -> Box x x a
  ipure a = Box a


class (IxApply m) <= IxBind m where
  ibind :: forall a b x y z. m   x y a -> (a -> m   y z b) -> m   x z b

instance ixBindBox :: IxBind Box where
  ibind :: forall a b x y z. Box x y a -> (a -> Box y z b) -> Box x z b
  ibind (Box a) f =
    -- `f a` produces a value with the type, `Box y z b`, which is
    -- not the return type of this function, `Box x z b`.
    --
    -- So, we can either `unsafeCoerce` the result of `f a` or just
    -- rewrap the 'b' value in a new Box. We've chosen to take the
    -- latter option here for simplicity.
    case f a of Box b -> Box b


class (IxApplicative m, IxBind m) <= IxMonad m

instance ixMonadBox :: IxMonad Box

-- Requirement 2: define functions whose names correspond to the ones used
-- in the regular type classes: `map`, `apply`, 'pure', 'bind', and
-- 'discard' (for when bind returns 'unit')
map :: forall f a b x. IxFunctor f => (a -> b) -> f x x a -> f x x b
map = imap

apply :: forall f a b x y z. IxApply f => f x y (a -> b) -> f y z a -> f x z b
apply = iapply

pure :: forall f a x. IxApplicative f => a -> f x x a
pure = ipure

bind :: forall m a b x y z. IxBind m => m x y a -> (a -> m y z b) -> m x z b
bind = ibind

discard :: forall a x y z m. IxBind m => m x y a -> (a -> m y z Unit) -> m x z Unit
discard = ibind
