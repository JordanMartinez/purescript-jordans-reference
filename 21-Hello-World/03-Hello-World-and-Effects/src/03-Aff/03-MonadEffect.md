# MonadEffect

The return types of `Node.ReadLine` are `Effect a`. Since "different monads don't compose," how can we run an `Effect` inside an `Aff`?

We already explained that "different monads don't compose." In this file, we'll show one way to workaround this limitation. This solution will be used frequently in real code wherever the `Effect` monad is used, but _this solution doesn't necessarily work for other monads_. However, it is conceptually easy to understand and provides the necessary scaffolding to make it easier to understand other solutions that other monadic types use to get around this limitation.

## Lifting one Monad into another

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

When `Effect` is the source monad being lifted into a target monad (i.e. we have an a computation of type, `Effect a`, that we want to run as an `Aff` computation), we can just use [MonadEffect](https://pursuit.purescript.org/packages/purescript-effect/2.0.0/docs/Effect.Class#v:liftEffect):

```purescript
class (Monad m) <= MonadEffect m where
  liftEffect :: Effect ~> m
```

`Aff` has an instance for `MonadEffect`, so we can lift `Effect`-based computations into an `Aff` monadic context, so that we can run `Effect`-based computations in that `Aff` monadic context.
