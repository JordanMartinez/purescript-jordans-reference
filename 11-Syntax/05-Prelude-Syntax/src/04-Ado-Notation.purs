{-
Link to original issue's comment
where this is fully explained:
https://github.com/purescript/purescript/pull/2889#issuecomment-301260299

Following the 'do' notation of Monads, the 'ado' notation is for Applicative
Since Applicative can be used for parellel computation, one **might**
   read the following code as
     "produces some value at the same time it's producing another value"
   rather than sequential computation, which is
     "produces some value, and then uses that value to produce another value"
It depends on whether parallel applicatives are used or not.
-}
module Syntax.Prelude.Notation.Ado where

import Prelude

data Box a = Box a

instance functorBox :: Functor Box where
  map :: forall a b. (a -> b) -> Box a -> Box b
  map f (Box a) = Box (f a)
-- infixl 4 map as <$>

instance applyBox :: Apply Box where
  apply :: forall a b. Box (a -> b) -> Box a -> Box b
  apply (Box f) (Box a) = Box (f a)
-- infixl 4 apply as <*>

instance applicativeBox :: Applicative Box where
  pure :: forall a. a -> Box a
  pure a = Box a
------------------------------
pure_no_sugar :: forall a b. (a -> b) -> a -> Box b
pure_no_sugar f a = pure (f a)

pure_sugar :: forall a b. (a -> b) -> a -> Box b
pure_sugar f a = ado
  in f a
------------------------------
map_no_sugar :: forall a b. (a -> b) -> Box a -> Box b
map_no_sugar f g = (\x -> f x) <$> g

map_sugar :: forall a b. (a -> b) -> Box a -> Box b
map_sugar f g = ado
  x <- g
  in f x
------------------------------
-- See `lift2` from Apply: https://pursuit.purescript.org/packages/purescript-prelude/4.1.0/docs/Control.Apply#v:lift2
liftN_no_sugar :: forall a b c. (a -> b -> c) -> Box a -> Box b -> Box c
liftN_no_sugar f g h = (\x y -> f x y) <$> g <*> h

liftN_sugar :: forall a b c. (a -> b -> c) -> Box a -> Box b -> Box c
liftN_sugar f g h = ado
  x <- g
  y <- h
  in f x y
------------------------------
liftN_unit_no_sugar :: forall a b. (a -> b) -> Box a -> Box Unit -> Box b
liftN_unit_no_sugar f g h = (\x _ -> f x) <$> g <*> h

liftN_unit_sugar :: forall a b. (a -> b) -> Box a -> Box Unit -> Box b
liftN_unit_sugar f g h = ado
  x <- g
  h
  in f x
------------------------------
liftN_Let_no_sugar :: forall a. (Int -> Int -> a) -> Box Int -> Box Unit -> Box a
liftN_Let_no_sugar f g h = (\x -> let y = x + 1 in (\_ -> f x y)) <$> g <*> h

liftN_Let_sugar :: forall a. (Int -> Int -> a) -> Box Int -> Box Unit -> Box a
liftN_Let_sugar f g h = ado
  x <- g
  let y = x + 1
  h
  in f x y
