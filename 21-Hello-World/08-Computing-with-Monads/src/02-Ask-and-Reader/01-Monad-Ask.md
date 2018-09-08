# Monad Reader

`MonadAsk` is used to expose a read-only value to a monadic context. It is very similar to and actually a bit simpler than `MonadState`:
```purescript
newtype StateT  s m a = StateT  (\s -> m (Tuple a s))
newtype ReaderT r m a = ReaderT (\r -> m        a   )

-- Since the classes are only implemented by one monad (a newtyped function)
-- we'll show the class and the related function's instance in the same block:
class (Monad m) <= MonadState s (StateT  s m) where
  state :: forall a. (s -> m Tuple a s) -> StateT  s m a

class (Monad m) <= MonadAsk   r (ReaderT r m) where
  ask   :: forall a.                       ReaderT r m a
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

Most of the time, we want a specific field from our settings object and not the entire thing. Thus, `ask` isn't too helpful in this regard. Fortunately, we have [`asks`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Reader.Class#v:asks), which uses a function to map our settings object to the field we actually want:
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

## MonadReader

`MonadReader` extends `MonadAsk` by allowing the read-only value to be modified first before being used in one computation.
```purescript
class MonadAsk r m <= MonadReader r m | m -> r where
  local :: forall a. (r -> r) -> m a -> m a
```

## Laws, Instances, and Miscellaneous Functions

For the laws, see
- [MonadAsk's docs](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Reader.Class)
- [MonadReader's docs]()

To see how `ReaderT` implements its instances
- [Functor instance](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Reader/Trans.purs#L50)
- [Apply instance](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Reader/Trans.purs#L53)
- [Applicative instance](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Reader/Trans.purs#L56)
- [Bind instance](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Reader/Trans.purs#L67)
- [MonadTell instance](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Reader/Trans.purs#L100), which is implemented using `pure` (Applicative)
- [MonadReader instance](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Reader/Trans.purs#L103), which is implemented using [`withReaderT` but where `r1` and `r2` are the same](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Reader/Trans.purs#L45)

Also see the functions in [ReaderT](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Reader.Trans#t:ReaderT)/[Reader](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Reader#t:Reader) for how to handle the output of a reader computation in various ways

The next file shows a working example.
