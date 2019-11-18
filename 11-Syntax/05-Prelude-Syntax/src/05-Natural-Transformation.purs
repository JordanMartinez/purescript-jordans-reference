module Syntax.Prelude.NaturalTransformations where

-- Given this code
data Box1 a = Box1 a
data Box2 a = Box2 a

-- This function's type signature...
box1_to_box2_noisy :: forall a. Box1 a -> Box2 a
box1_to_box2_noisy (Box1 a) = Box2 a
-- ... has a lot of noise and could be re-written to something
-- that communicates our intent better via Natural Transformations...

-- Read: given an 'a' that is inside of a 'container' or 'context',
-- change the container F to container G.
-- I don't care what type 'a' is since it's irrelevant
type NaturalTransformation_ f g = forall a. f a -> g a

infixr 4 type NaturalTransformation_ as ~>

box1_to_box2 :: Box1 ~> Box2 {- much less noisy than
box1_to_box2 :: forall a. Box1 a -> Box2 a -}
box1_to_box2 (Box1 a) = Box2 a
