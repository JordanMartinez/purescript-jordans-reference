# MonadEffect

In the previous folder, we saw that we could print content to the console using `specialLog`. Underneath, we're using `log`, the function with the type, `String -> Effect Unit`. Since "monads don't compose," how was this possible?

In this file, we'll show one way to workaround this limitation. This solution will be used frequently in real code wherever the `Effect` monad is used. However, _this solution doesn't necessarily work for other monads_. Still, it is conceptually easy to understand and creates scaffolding. That scaffoldingwill make it easier to understand other solutions to this problem that we'll discuss in the `Application Structure` folder.

## Lifting one Monad into another

When overviewing the `Prelude` library, we covered `NaturalTransformation`s briefly. At that time, we described it as "taking a value out of `Box1` and putting that value into `Box2`." To run `Effect`-based computations in other monadic contexts, we employ a similar technique. Why this technique even works will become clearer in the `Application Structure` folder.

In short, we use a type class that follows this idea:
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

-- To prevent a naming clash with the real Bind type class.
class Bind_ m where
  doBind :: forall a b. m a -> (a -> m b) -> m b

instance bb :: Bind_ Box1 where
  doBind (Box1 a) f = f a

instance bs :: (Show a) => Show (Box1 a) where
  show (Box1 a) = show a

bindAttempt :: Box1 Int
bindAttempt =
  doBind (Box1 4) (\four ->
    let
      liftedIntoBox1 = liftSourceMonad (Box2 6)
    in
      doBind liftedIntoBox1 (\six ->
        Box1 (four + six)
      )
  )
```

## MonadEffect

When we have an `Effect`-based computation that we want to run in some other monadic context, we can use `liftEffect` from [MonadEffect](https://pursuit.purescript.org/packages/purescript-effect/2.0.0/docs/Effect.Class#v:liftEffect) **if the target monad has an instance for `MonadEffect`**:

```purescript
class (Monad m) <= MonadEffect m where
  liftEffect :: Effect ~> m
```

`Aff` has an instance for `MonadEffect`, so we can lift `Effect`-based computations into an `Aff` monadic context, so that we can run `Effect`-based computations in that `Aff` monadic context.

Below was how we defined `specialLog`. You can see it in the next file:
```purescript
specialLog :: String -> Aff Unit
specialLog message = liftEffect $ log message
```

Referring back to our previous "local state" example, the `ST` monad does not have an instance for `MonadEffect`. This decision is intentional: state manipulation of that kind should be pure and not have any side-effects. That's why it exists inside of its own monadic context: to ensure that those who attempt to do so get compiler errors. This is a safety precaution, not a "we wanted to be jerks who frustrate you" decision.
