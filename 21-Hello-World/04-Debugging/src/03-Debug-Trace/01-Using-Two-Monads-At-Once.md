# Using Two Monads at Once

Before we can continue further, we need to review a concept, see the problem it creates, and show both possible solutions.

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

endingBox :: Box1 Int
endingBox = do
  b1_Int <- box1
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

## The Production-Code Solution

We use a type class that follows this idea:
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
This enables something like the following. It can be pasted into the REPL and one can try it out by calling `doBind`:
```purescript
import Prelude -- for the (+) and (~>) function aliases

data Box1 a = Box1 a
data Box2 a = Box2 a

class LiftSourceIntoTargetMonad sourceMonad targetMonad where
  liftSourceMonad :: sourceMonad ~> targetMonad

instance box2_to_box1 :: LiftSourceIntoTargetMonad Box2 Box1 where
  liftSourceMonad :: Box2 ~> Box1
  liftSourceMonad (Box2 a) = Box1 a

class Bind_ m where
  doBind :: forall a b. m a -> (a -> m b) -> m b

instance bb :: Bind_ Box1 where
  doBind (Box1 a) f = f a

instance bs :: (Show a) => Show (Box1 a) where
  show (Box1 a) = show a

bindAttempt :: Box1 Int
bindAttempt =  doBind (Box1 4) (\four -> doBind (liftSourceMonad (Box2 6)) (\six -> Box1 (four + six)))
```

## MonadEffect

When `Effect` is the source monad being lifted into a target monad, we can just use  [MonadEffect](https://pursuit.purescript.org/packages/purescript-effect/2.0.0/docs/Effect.Class#v:liftEffect):

```purescript
class (Monad m) <= MonadEffect m where
  liftEffect :: Effect ~> m
```

## The Developer-Code Solution

Another way way to get around this is use to a package that can be easily abused by new programmers.

The purpose of this package is for debugging and possibly prototyping as you write FP code. We'll be using it here to help us learn things. If any of its functions ever appear in production code, slap yourself, for you might as well write OO code instead.

This package's functions are also the reason why we talked about Custom Type Errors, as the compiler will notify you when you use them, so that you can remove all such instances before you push out production code.

This solution (covered next) is called [Debug.Trace](https://pursuit.purescript.org/packages/purescript-debug/4.0.0/docs/Debug.Trace)

**WARNING**: `Debug.Trace`'s functions are not always reliable when running concurrent code.
