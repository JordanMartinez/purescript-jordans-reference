# MonadEffect

In the previous folder, we saw that we could print content to the console using `specialLog`. Underneath, we're using `log`, the function with the type, `String -> Effect Unit`. Since "`bind` outputs the same box-like type it receives," how was this possible?

In this file, we'll show one way to workaround this limitation. This solution will be used frequently in real code wherever the `Effect` monad is used. However, _this solution doesn't necessarily work for other monads_. Still, it is conceptually easy to understand and creates scaffolding. That scaffolding will make it easier to understand other workarounds to this restriction that we'll discuss in the `Application Structure` folder.

## Reviewing a Previous Workaround: Lifting one Monad into another

When overviewing the ""`bind` outputs the same box-like type it receives" restriction, we described the previous workaround:
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

## MonadEffect

When we have an `Effect`-based computation that we want to run in some other monadic context, we can use `liftEffect` from [MonadEffect](https://pursuit.purescript.org/packages/purescript-effect/2.0.0/docs/Effect.Class#v:liftEffect) **if the target monad has an instance for `MonadEffect`**:

```haskell
class (Monad m) <= MonadEffect m where
  liftEffect :: Effect ~> m
```

`Aff` has an instance for `MonadEffect`, so we can lift `Effect`-based computations into an `Aff` monadic context. Below was how we defined `specialLog`. You can see it in the next file:
```haskell
specialLog :: String -> Aff Unit
specialLog message = liftEffect $ log message
```

Referring back to our previous "local state" example, the `ST` monad does not have an instance for `MonadEffect`. This decision is intentional: state manipulation of that kind should be pure and not have any side-effects. That's why it exists inside of its own monadic context: to ensure that those who attempt to do so get compiler errors. This is a safety precaution, not a "we wanted to be jerks who frustrate you" decision.

As we saw previously in the `Switching-Context.purs` file, running multiple `Aff` computations in an `Effect` monadic context doesn't always lead to a predictable output. However, running multiple `Effect`-based computations in an `Aff` monadic context is much more predictable.
