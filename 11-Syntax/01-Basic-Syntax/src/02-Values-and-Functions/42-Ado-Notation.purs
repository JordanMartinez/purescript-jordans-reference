module Syntax.Notation.Ado where

import Prelude -- hiding ((<$>), (<*>), Functor, Apply, Applicative)

data Box a = Box a

-- Copied from Prelude to give as reference:
class Functor f where
  map :: forall a b. f a -> (a -> b) -> f b

class Apply f where
  apply :: forall a b. f (a -> b) -> f a -> f b

class Applicative f where
  pure :: forall a. a -> f a

infixl 4 map as <$>
infixl 4 apply as <*>

instance boxFunctor :: Functor Box where
  map (Box a) f = Box (f a)

instance boxApply :: Apply Box where
  apply (Box f) (Box a) = Box (f a)

instance boxApplicative :: Applicative Box where
  pure a = Box a

-- Link to original issue's comment
-- where this is fully explained: https://github.com/purescript/purescript/pull/2889#issuecomment-301260299

-- Following the 'do' notation of Monads, the 'ado' notation is for Applicative
-- Since Applicative can be used for parellel computation, one _might_
-- need to read the following code as
-- "produces some value at the same time it's producing another value"
-- rather than sequential computation, which is
-- "produces some value, and then uses that value to produce another value"
-- It depends on whether parallel applicatives are used or not.

------------------------------
-- ado
--   in h x
-- -- desugars into
-- pure (h x)
------------------------------
-- ado
--   x <- g
--   in f x
-- -- desugars into
-- (\x -> f x) <$> g
------------------------------
-- ado
--   x <- g
--   y <- h
--   in f x y
-- -- desugars into
-- (\x y -> f x y) <$> g <*> h
------------------------------
-- ado
--   x <- g
--   h
--   in f x
-- -- desugars into
-- (\x _ -> f x) <$> g <*> h
------------------------------
-- ado
--   x <- g
--   let y = x + 1
--   h
--   in f x y
-- -- desugars into
-- (\x -> let y = x + 1 in \_ -> f x y) <$> g <*> h
------------------------------
