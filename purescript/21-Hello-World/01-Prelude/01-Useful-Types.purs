-- not accurate but gets the idea across

-- type with no instances
-- useful for proving that a type can never exist
newtype Void = -- nothing, as this type has no instances

-- needed when one needs to refer to void
absurd :: forall a. Void -> a

function :: Either Void Int -> Int
function Right i = i -- only route that can occur
function Left v  = abusrd v -- if it compiles, it asserts our logic
                            -- that this path is never taken

-- type with 1 instance, usually indicates a "side effect"/mutation/impure code
data Unit = Unit

unit :: Unit
unit = Unit


-- Natural Transformations
-- Given this code
data Box1 a = Box1 a
data Box2 a = Box2 a

-- This function's type signature...
box1_to_box2 :: forall a. Box1 a -> Box2 a
box1_to_box2 (Box1 a) = Box2 a
-- ... has a lot of noise and could be re-written to something
-- that communicates our intent better via Natural Transformations...

-- Read: given an 'a' that is inside of a 'container' or 'context',
-- change the container F to container G.
-- I don't care what type 'a' is since it's irrelevant
type NaturalTransformation f g = forall a. f a -> g a

infixr 4 NaturalTransformation as ~>

box1_to_box2 :: Box1 ~> Box2 {- much less noisy than
box1_to_box2 :: forall a. Box1 a -> Box2 a -}
box1_to_box2 (Box1 a) = Box2 a
