# Monad Reader

`MonadReader` extends `MonadAsk` by allowing the settings instance to be adjusted for one computation.
```purescript
class MonadAsk r m <= MonadReader r m | m -> r where
  local :: forall a. (r -> r) -> m a -> m a
```
