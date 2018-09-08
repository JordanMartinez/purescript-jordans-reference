# Monad Reader

`MonadAsk` is used to expose a read-only value to a monadic context. It is very similar to and actually a bit simpler than `MonadState` in that a newtyped function is the Monad we use to make all other Monads implement `MonadAsk`. Let's compare the newtyped functions and type classes:
```purescript
newtype StateT  s m a = StateT  (\s -> m (Tuple a s))
newtype ReaderT r m a = ReaderT (\r -> m        a   )

class (Monad m) <= MonadState s (StateT  s m) where
  state :: forall a. (s -> m Tuple a s) -> m a

class (Monad m) <= MonadAsk   r (ReaderT s m) where
  ask   :: forall a.                       m a
```

## Do Notation

When writing `StateT`'s do notation, we have a function called `get` that does not take any argument but still returns a value:
```purescript
stateManipulation :: State Int Int
stateManipulation =
  get
-- which reduces to
  state (\s -> Tuple s s)
-- which reduces to
  StateT (\s -> Identity (Tuple s s))

-- When we run `stateManipulation` with `runState`...
  runState (StateT (\s -> Identity (Tuple s s))) 0
-- it reduces to...
  unboxIdentity $ (\s -> Identity (Tuple s s)) 0
-- which reduces to
  unboxIdentity (Identity (Tuple 0 0))
-- and finally outputs
  Tuple 0 0
```

`MonadAsk`'s function works similarly:
```purescript
type Settings = { editable :: Boolean, fontSize :: Int }
useSettings :: Reader Settings Settings
useSettings = ask
-- which reduces to...
  ReaderT (\r -> Identity r)

-- When we run `useSettings` with `runReader`
  runReader useSettings { editable: true, fontSize: 12 }
-- it reduces to
  unwrapIdentity $ (\r -> Identity r) { editable: true, fontSize: 12 }
-- which reduces to
  unwrapIdentity (Identity { editable: true, fontSize: 12 })
-- which reduces to
  { editable: true, fontSize: 12 }
```

## Derived Functions

Most of the time, we want a specific field from our settings object and nto the entire thing. Thus, `ask` isn't too helpful in this regard. However, that's why we have [`asks`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Reader.Class#v:asks), which takes a function from our settings object to the field we actually want:
```purescript
type Settings = { editable :: Boolean, fontSize :: Int }

main :: Effect Unit
main = log $ runReader useSettings { editable: true, fontSize: 12 }

                  --   r                 a
            -- ReaderT Settings Identity String
useSettings :: Reader  Settings          String
useSettings = do
  entireSettingsObject <- ask
  specificField <- asks (_.fontSize)

  pure ("Entire Settings Object: " <> show entireSettingsObject <> "\n\
        \Specific Field: " <> show specificField)
```

## Laws and Miscellaneous Functions

For the laws, see [MonadAsk's docs](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Reader.Class)

Also see [ReaderT](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Reader.Trans#t:ReaderT)/[Reader](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Reader#t:Reader)'s functions for how to handle its output in various ways

The next file shows a working example.
