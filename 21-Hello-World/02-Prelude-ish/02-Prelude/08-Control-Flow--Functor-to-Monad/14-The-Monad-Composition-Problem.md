# The Monad Composition Problem

Before we can continue further, I need to review a concept and demonstrate the problem it creates. I will show one way to solve this problem, but it's not necessarily the solution most will use for more complicated scenarios (that's what the `Application Structure` folder is for). In short, "different monads do not compose."

## Reducing a Monad Chain into Its Final Value

Let's say we have two monads, `Box1` and `Box2` that have the same implementations for their `Bind` type class instances:
```purescript
data Box1 a = Box1 a
data Box2 a = Box2 a

{-
class Bind m where
  bind :: forall a b. m    a -> (a -> m    b) -> m    b                 -}
instance b1 :: Bind Box1 where
  bind :: forall a b. Box1 a -> (a -> Box1 b) -> Box1 b
  bind               (Box1 a)   f              = f a
instance b2 :: Bind Box2 where
  bind :: forall a b. Box2 a -> (a -> Box2 b) -> Box2 b
  bind               (Box2 a)   f              = f a
```
Due to the above implementation for `Box1`, we can write something like this using do notation...
```purescript
computation :: Box1 Int -> Box1 Unit
computation boxWithInt = do
  theInt <- boxWithInt
  pure unit

```
... which, when fully desugared, is a single line of code...
```purescript
computation :: Box1 Int -> Box1 Unit
-- convert from `do` notation to `>>=` bind's infix notation
computation boxWithInt = boxWithInt >>= (\theInt -> pure unit)
-- convert from `>>=` infix notation to bind function
computation boxWithInt = bind boxWithInt (\theInt -> pure unit)
```
... that, when evaluated, will go through the following reduction:
```purescript
computation :: Box1 Int -> Box1 Unit
computation boxWithInt = bind boxWithInt (\theInt -> pure unit)

{- Step 1a: Look at the Bind instance for Box1...
      bind :: forall f a b. Box1 a -> (a -> Box1 b) -> Box1 b
      bind                 (Box1 a)   f              = f a
   Step 1b: ... and unbox the int in Box1                             -}
computation (Box1 a) = bind (Box1 a) (\theInt -> pure unit)          {-
   Step 1c: ... and replace the function call with its definition     -}
computation (Box1 a) = (\theInt -> pure unit) a                      {-
   Step 2: Apply the 'a' tothe function                               -}
computation (Box1 a) = pure unit                                     {-
   Step 3a: Look at the Applicative instance for Box1...
      pure :: forall a. a -> Box1 a
      pure              a  = Box1 a
   Step 3b: ... and replace the function call with its definition     -}
computation (Box1 a) = Box1 unit                                     {-
-}
```

## The Problem Defined

Due to `bind`'s type signature, the function, `f`, must return a `Box1` monad and not some other monad. In other words, it cannot return a `Box2` monad.

For example, the following code can never compile:
```purescript
box1 :: Box1 Int
box1 = Box1 4

box2 :: Box2 Int
box2 = Box2 6

-- this type signatures shows we have commited to the `Box1` monadic context
endingBox :: Box1 Int
endingBox = do
  b1_Int <- box1

  -- here we suddenly try to introduce a non-`Box1` monadic context
  -- which causes this code to fail
  b2_Int <- box2
  pure (b1_Int + b2_Int)
```
To see why, we need only to desugar the do-notation:
```purescript
endingBox :: Box1 Int
endingBox = do
  b1_Int <- box1
  b2_Int <- box2
  pure (b1_Int + b2_Int)

-- from do notation to `>>=` infix notation
endingBox = box1 >>= (\b1_Int -> box2 >>= (b2_Int -> pure (b1_Int + b2_Int)))

-- from `>>=` infix notation to bind function
endingBox = bind box1 (\b1_Int -> bind box2 (b2_Int -> pure (b1_Int + b2_Int)))

-- Unbox Box1
endingBox = bind (Box1 4) (\b1_Int -> bind box2 (b2_Int -> pure (b1_Int + b2_Int)))

-- Replace `bind` function with Box1's instance's implementation
endingBox :: Box1 Int
endingBox = (\b1_Int -> bind box2 (b2_Int -> pure (b1_Int + b2_Int))) 4

-- Apply the argument to the function
endingBox =             bind box2 (b2_Int -> pure (4 + b2_Int))

-- (Remove extra white space)
endingBox = bind box2 (b2_Int -> pure (4 + b2_Int))

-- Unbox Box2 to expose its int
--    Here is where the `bind` function forces the `m` type
--    to change to Box2
endingBox = bind (Box2 6) (b2_Int -> pure (4 + b2_Int))

-- Compiler Error: actual type, `Box2`, isn't the expected type, `Box1`
```

As soon as we commit to using one monadic context to compute something, we can no longer use other monads in that context. In the upcoming folders, we'll mention this problem again and show the various ways one can workaround that issue.

## Lifting One Monad into Another

To help develop the necessary foundation for later understanding, we'll now show a way to do this. We use a type class that follows this idea:
```purescript
class LiftSourceIntoTargetMonad sourceMonad targetMonad where {-
  liftSourceMonad :: forall a. sourceMonad a -> targetMonad a -}
  liftSourceMonad ::           sourceMonad   ~> targetMonad

-- Note: instances of this idea might be much more complicated than this one
instance box2_into_box1 :: LiftSourceIntoTargetMonad Box2 Box1 where {-
  liftSourceMonad :: forall a. Box2 a -> Box1 a                      -}
  liftSourceMonad ::           Box2   ~> Box1
  liftSourceMonad (Box2 a) = Box1 a
```
This enables something like the following. It can be pasted into the REPL and one can try it out by calling `bindAttempt`:
```purescript
import Prelude -- for the (+) and (~>) function aliases

data Box1 a = Box1 a
data Box2 a = Box2 a

class LiftSourceIntoTargetMonad sourceMonad targetMonad where
  liftSourceMonad :: sourceMonad ~> targetMonad

instance box2_to_box1 :: LiftSourceIntoTargetMonad Box2 Box1 where
  liftSourceMonad :: Box2 ~> Box1
  liftSourceMonad (Box2 a) = Box1 a

instance bs :: (Show a) => Show (Box1 a) where
  show (Box1 a) = show a

bindAttempt :: Box1 Int
bindAttempt = do
  four <- Box1 4
  six <- liftSourceMonad $ Box2 6
  pure $ four + six

-- type class instances for Monad hierarchy

instance functor :: Functor Box1 where
  map :: forall a b. (a -> b) -> Box1 a -> Box1  b
  map f (Box1 a) = Box1 (f a)

instance apply :: Apply Box1 where
  apply :: forall a b. Box1 (a -> b) -> Box1 a -> Box1  b
  apply (Box1 f) (Box1 a) = Box1 (f a)

instance bind :: Bind Box1 where
  bind :: forall a b. Box1 a -> (a -> Box1 b) -> Box1 b
  bind (Box1 a) f = f a

instance applicative :: Applicative Box1 where
  pure :: forall a. a -> Box1 a
  pure a =  Box1 a

instance monad :: Monad Box1
```
