# Useful Types

The following is not an exact copy of the code, but accurate enough to get the idea across

## Void

A type with no values that is useful for proving that a type can never exist or a computation path can never occur

```purescript
-- Data.Void (Void, absurd)

newtype Void = Void Void

-- needed when one needs to refer to void
absurd :: forall a. Void -> a

-- for example...
data Either a b
  = Left a
  | Right b

-- if this function compiles, it asserts that
-- only the `Right i` path is ever taken
function :: Either Void Int -> Int
function Left v  = absurd v
function Right i = i
```

## Unit

A type with 1 value, Unit, though most will see it used via `unit`. It usually indicates a "side effect", mutation, or impure code.
```purescript
-- Data.Unit (Unit, unit)

data Unit = Unit

unit :: Unit
unit = Unit
```
It's also used to indicate a `thunk`, a computation that we know how to do but have chosen to delay executing/evaluating until later:
```purescript
type ComputationThatReturns a = (Unit -> a)

thunk :: forall a. a -> ComputationThatReturns a
thunk a = (\_ -> a)

-- We run the pending computation (force the thunk) by passing
-- unit to it:
runPendingComputation :: ComputationThatReturns a -> a
runPendingComputation thunk = thunk unit
```

## Natural Transformations

Takes an `a` out of some `Box`-like type and puts it into another `Box`-like type

```purescript
-- Data.NaturalTransformation (NaturalTransformation, (~>))

-- Given this code
data Box1 a = Box1 a
data Box2 a = Box2 a

-- This function's type signature...
box1_to_box2 :: forall a. Box1 a -> Box2 a
box1_to_box2 (Box1 a) = Box2 a
-- ... has a lot of noise and could be re-written to something
-- that communicates our intent better via Natural Transformations...

-- Read: change the container F to container G.
-- I don't care what type 'a' is since it's irrelevant
type NaturalTransformation f g = forall a. f a -> g a

infixr 4 NaturalTransformation as ~>

box1_to_box2 ::           Box1   ~> Box2 {- much less noisy than
box1_to_box2 :: forall a. Box1 a -> Box2 a -}
box1_to_box2             (Box1 a) = Box2 a
```
