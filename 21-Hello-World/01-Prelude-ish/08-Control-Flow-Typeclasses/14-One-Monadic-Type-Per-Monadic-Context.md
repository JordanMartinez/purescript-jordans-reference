# One Monadic Type Per Monadic Context

Before we can continue further, we must understand one of the implications of the `bind` function.

## Defining the Problem

Let's look at the type signature for the `bind` function.
```haskell
class Apply boxLike <= Bind boxLike where
  bind :: forall a b. boxLike a -> (a -> boxLike b) -> boxLike b
```

If we ignore the `(a -> boxLike b)` argument, we can summarize it like this:
> If you give me a "box-like" type, I will output the **same** "box-like" type.

In other words, once we use `bind` in a given computation (e.g. `do notation`), we restrict all usages of `bind` within that same computation to the same "box-like" type we originally passed in. This restriction is a good thing. There are ways to workaround the limitation. We'll cover one workaround below, but the other workarounds will be covered in the `Application Structure` folder.

Throughout this work, we will refer to this restriction as the "`bind` outputs the same box-like type it receives" restriction.

For now, let's provide an example of this problem.

## Example of the Problem

Let's say we have two `Box` types. They differ only in their name. Each implements the `Functor`, `Apply`, and `Bind` instances in the exact same way. Below, we will only show the `Bind` instance, but assume they have implemented the other type classes:
```haskell
data Box1 a = Box1 a
data Box2 a = Box2 a

class Apply m <= Bind m where
  bind :: forall a b. m    a -> (a -> m    b) -> m    b

instance Bind Box1 where
  bind :: forall a b. Box1 a -> (a -> Box1 b) -> Box1 b
  bind               (Box1 a)   f              = f a
instance Bind Box2 where
  bind :: forall a b. Box2 a -> (a -> Box2 b) -> Box2 b
  bind               (Box2 a)   f              = f a
```
Recall that `do notation` desugars into multiple `bind` calls:
```haskell
example :: Box1 int
example = do
  u <- Box unit
  five <- Box 5
  pure (five + 1)

-- desugars to
example =
  bind (Box unit) \u ->
    bind (Box 5) \five ->
      pure (five + 1)
```

The below `Box1` computation compiles fine.
```haskell
box1Computation :: Box1 Unit
box1Computation = Box1 unit
```
The below `Box2` computation compiles fine:
```haskell
box2Computation :: Box2 Unit
box2Computation = Box2 unit
```
If I write the following code, which (if any) will compile?
```haskell
box1ThenBox2 :: Box2 Unit
box1ThenBox2 = do
  box1Computation
  box2Computation

box2ThenBox1 :: Box1 Unit
box2ThenBox1 = do
  box2Computation
  box1Computation
```

Neither will compile. In `box1ThenBox2`, the first computation is `box1Computation`. Thus, this computation should eventually output a value of the `Box1 someOutput` type. However, we attempt to run a computation that uses a different monad (i.e. `Box2`) within the `Box1` monadic context. Since `Box2` isn't `Box1`, we get a compiler error. This same error occurs when you attempt to compile `box2ThenBox1`.

## The First Workaround: Lifting One Monad into Another

Sometimes, this restriction actually helps us write safer code. Other times, this restriction is problematic and we need to get around it.

To help develop the necessary foundation for later understanding, we'll show a general approach to workaround this restriction. We use a type class that follows this idea:
```haskell
class LiftSourceIntoTargetMonad sourceMonad targetMonad where {-
  liftSourceMonad :: forall a. sourceMonad a -> targetMonad a -}
  liftSourceMonad ::           sourceMonad   ~> targetMonad

-- Note: instances of this idea might be more complicated than this one
instance LiftSourceIntoTargetMonad Box2 Box1 where {-
  liftSourceMonad :: forall a. Box2 a -> Box1 a                      -}
  liftSourceMonad ::           Box2   ~> Box1
  liftSourceMonad (Box2 a) = Box1 a
```
This enables something like the following. It can be pasted into the REPL and one can try it out by calling `bindAttempt`:
```haskell
import Prelude -- for the (+) and (~>) function aliases

data Box1 a = Box1 a
data Box2 a = Box2 a

class LiftSourceIntoTargetMonad sourceMonad targetMonad where                 {-
  liftSourceMonad :: forall a. sourceMonad a -> targetMonad a                 -}
  liftSourceMonad ::           sourceMonad   ~> targetMonad

instance LiftSourceIntoTargetMonad Box2 Box1 where
  liftSourceMonad :: Box2 ~> Box1
  liftSourceMonad (Box2 a) = Box1 a

bindAttempt :: Box1 Int
bindAttempt = do
  four <- Box1 4
  six <- liftSourceMonad $ Box2 6
  pure $ four + six

-- type class instances for Monad hierarchy

instance Functor Box1 where
  map :: forall a b. (a -> b) -> Box1 a -> Box1  b
  map f (Box1 a) = Box1 (f a)

instance Apply Box1 where
  apply :: forall a b. Box1 (a -> b) -> Box1 a -> Box1  b
  apply (Box1 f) (Box1 a) = Box1 (f a)

instance Bind Box1 where
  bind :: forall a b. Box1 a -> (a -> Box1 b) -> Box1 b
  bind (Box1 a) f = f a

instance Applicative Box1 where
  pure :: forall a. a -> Box1 a
  pure a =  Box1 a

instance Monad Box1

-- Needed to print the result to the console in the REPL session

instance (Show a) => Show (Box1 a) where
  show (Box1 a) = show a
```
