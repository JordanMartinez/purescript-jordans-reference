-- not accurate but gets the idea across

-- type with no instances
-- useful for proving that a type can never exist
newtype Void = -- nothing, as this type has no instances

-- needed when one needs to refer to void
absurd :: forall a. Void -> a

function :: Either Void Int -> Int
function Right i = i -- only route that can occur
function Left v = abusrd v -- impossible to run but satisfies compiler

-- type with 1 instance, usually indicates a "side effect"/mutation/impure code
data Unit = Unit

unit :: Unit
unit = Unit

infix {- not sure -} unit as ()

-- not caring about what 'a' is, changes the 'container' or 'context'
-- from F to G
type NaturalTransformation f g = forall a. f a -> g a

infixr 4 NaturalTransformation as ~>

-- Example:
data Box1 a = Box1 a
data Box2 a = Box2 a

box1_to_box2 :: Box1 ~> Box2
-- desugars to
box1_to_box2 :: forall a. Box1 a -> Box2 a
-- which can be easily implemented:
--  unbox Box1's value and stick it into a Box2 instance
box1_to_box2 (Box1 a) = Box2 a
