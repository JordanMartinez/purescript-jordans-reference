# Overview

## Monad Reader

`MonadAsk` is used to expose a read-only value to a monadic context. It's default implmentation is `ReaderT`:
```haskell
             -- r        m     a
newtype ReaderT readOnly monad finalOutput =
  ReaderT (\readOnly -> monad finalOutput)

-- Pseudo-syntax for combining the type class and ReaderT's instance together
class (Monad m) <= MonadAsk r (ReaderT r m) where
  ask   :: forall a. ReaderT r m a
  ask a = ReaderT (\_ -> pure a)
```

## Do Notation

When writing `StateT`'s do notation, we have a function called `get` that does not take any argument but still returns a value:
```haskell
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
```haskell
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

## MonadReader

`MonadReader` extends `MonadAsk` by allowing the read-only value to be modified first before being used in one computation.
```haskell
class MonadAsk r m <= MonadReader r m | m -> r where
  local :: forall a. (r -> r) -> m a -> m a
```

## Derived Functions

`MonadReader` does not have any derived functions.

`MonadAsk` has one derived function:
- `asks`: apply a function to the read-only value (useful for extracting something out of it, like a field in a settings object)

## Laws, Instances, and Miscellaneous Functions

For the laws, see
- [MonadAsk's docs](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Reader.Class)
- [MonadReader's docs](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Reader.Class#t:MonadReader)

To see how `ReaderT` implements its instances
- [Functor instance](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Reader/Trans.purs#L50)
- [Apply instance](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Reader/Trans.purs#L53)
- [Applicative instance](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Reader/Trans.purs#L56)
- [Bind instance](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Reader/Trans.purs#L67)
- [MonadTell instance](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Reader/Trans.purs#L100), which is implemented using `pure` (Applicative)
- [MonadReader instance](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Reader/Trans.purs#L103), which is implemented using [`withReaderT` but where `r1` and `r2` are the same](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Reader/Trans.purs#L45)

To handle/modify the output of a reader computation:
- [Reader](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Reader#v:runReader)
- [ReaderT](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Reader.Trans#v:runReaderT)
