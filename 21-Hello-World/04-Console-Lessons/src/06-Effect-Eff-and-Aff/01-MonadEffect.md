# MonadEffect

Previously, we mentioned the idea of `LiftSourceIntoTargetMonad`
```purescript
data Box1 a = Box1 a
data Box2 a = Box2 a

class LiftSourceIntoTargetMonad sourceMonad targetMonad where
  liftSourceMonad :: sourceMonad ~> targetMonad

-- some implementations may much be harder than this example
instance box2_to_box1 :: LiftSourceIntoTargetMonad Box2 Box1 where
  liftSourceMonad :: Box2 ~> Box1
  liftSourceMonad (Box2 a) = Box1 a
```

When the source monad is `Effect`, we have a type class specific to this called [MonadEffect](https://pursuit.purescript.org/packages/purescript-effect/2.0.0/docs/Effect.Class#v:liftEffect):

```purescript
class (Monad m) <= MonadEffect m where
  liftEffect :: Effect ~> m
```
