# MonadEffect

The return types of `Node.ReadLine` are `Effect a`, so how have we been executing them using the `Aff` monad? We need to return to a concept we introduced a few files ago.

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

`Aff` has an instance for `MonadEffect`, so we can lift `Effect` types into a `Aff` monadic context.

Previously, we also said that `ST`/`STRef` did not have such an instance. Thus, we were forced to use `Debug.Trace (traceM)` to output anything to the console.

The lack of such an instance made it harder for us when learning how to use it, but it's actually good that `ST`/`STRef` does not have such an intance. Why? Because it guarantees that the otherwise impure code there is kept within a specific scope.
