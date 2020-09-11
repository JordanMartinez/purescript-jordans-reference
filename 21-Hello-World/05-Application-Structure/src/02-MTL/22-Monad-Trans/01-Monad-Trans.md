# Monad Trans

`MonadTrans` enables one computational monad to run inside another, thereby exposing multiple type class' functions for usage in `bind`/`>>=` / do notation in the same function. It enables one to write an entire program via newtyped function monads (or functions with monadic syntax).

```haskell
class MonadTrans t where
  lift :: forall m a. m a -> t m a
```

## Laws

[See its docs](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Trans.Class#t:MonadTrans)

## Instances

- [StateT](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/State/Trans.purs#L95)
- [ReaderT](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Reader/Trans.purs#L83)
- [WriterT](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Writer/Trans.purs#L91)
- [ExceptT](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Except/Trans.purs#L99)
- [ContT](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Cont/Trans.purs#L54)
