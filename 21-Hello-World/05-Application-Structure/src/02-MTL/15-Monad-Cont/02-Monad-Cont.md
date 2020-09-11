# MonadCont

`MonadCont`, the Continuation Monad, is used to handle callback hell among other things.

```haskell
           -- r      m     a
newtype ContT return monad input =
  ContT ((input -> monad return) -> monad return)

-- Pseudo-Syntax: combine class and instance into one block
-- and "n" represents ContT:
class (Monad m) <= MonadCont r (ContT r m) where
  callCC :: forall a. (forall b. (a -> n b) -> n a) -> n   a
  callCC :: forall a. (forall b. ContT b m a)       -> ContT r m a
```

## Derived Functions

None!

## Laws, Instances, and Miscellaneous Functions

There aren't any laws!

Instances:
- [Functor](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Cont/Trans.purs#L40)
- [Apply](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Cont/Trans.purs#L43)
- [Applicative](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Cont/Trans.purs#L46)
- [Bind](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Cont/Trans.purs#L49)

To handle/modify the output of a continuation computation:
- [Cont](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Cont#v:cont)
- [ContT](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Cont.Trans#v:runContT)
