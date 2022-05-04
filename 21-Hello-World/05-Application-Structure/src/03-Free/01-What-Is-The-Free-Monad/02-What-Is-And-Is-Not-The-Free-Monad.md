# What Is and Is Not The Free Monad

Since `List` was the free monoid type, what would be the free monad type?
```haskell
-- monad class fully expanded...
class Monad f where
  map   :: forall a. (a -> b) -> f a -> f b
  apply :: forall a. f (a -> b) -> f a -> f b
  bind  :: forall a. f a -> (a -> f b) -> f b
  pure  :: forall a. a -> f a
```
Using our previous instructions...
> In short, to create a "free" `SomeTypeClass`, we do 3 things:
> 1. Translate the type class into a higher-kinded type
> 2. Do the following for each of the type class' functions, starting with the easiest function:
>     - Translate one type class' function into a constructor for the new type
>     - Try to implement all required instances using the constructor
>     - Fix problems that arise

We'll start with the simplest function, `pure`:
```haskell
data FreeMonad a
  = Pure a

instance Applicative FreeMonad where
  pure a = Pure a

instance Functor FreeMonad where
  map f (Pure a) = Pure (f a)

instance Apply FreeMonad where
  apply (Pure f) (Pure a) = Pure (f a)

instance Bind FreeMonad where
  bind (Pure a) f = f a
```
Well, that was easy... Wasn't this the same implementation as `Identity` from before? You are correct.
```haskell
data Identity a = Identity a

instance Applicative Identity where
  pure a = Identity a

instance Functor Identity where
  map f (Identity a) = Identity (f a)

instance Apply Identity where
  apply (Identity f) (Identity a) = Identity (f a)

instance Bind Identity where
  bind (Identity a) f = f a
```
We can see here that `Identity` is a free `Functor`, `Apply`, `Applicative`, `Bind`, and therefore `Monad` for any type with kind `Type`.

However, that's not what others mean when they talk about **the** free `Monad` type. The `Free` monad makes any `Functor` (i.e. type with kind `Type -> Type`) a monad.

There are other "free" type classes (mentioned below). AFAIK, these types were not discovered at the same time by the same people. Rather, they were discovered over time as solutions to specific problems. See below for these types:
- Coyoneda - [docs](https://pursuit.purescript.org/packages/purescript-free/5.2.0/docs/Data.Coyoneda#t:Coyoneda) & [source code](https://github.com/purescript/purescript-free/blob/v5.1.0/src/Data/Coyoneda.purs#L32) - a free `Functor` for any type of kind `Type -> Type`.
- FreeAp - [docs](https://pursuit.purescript.org/packages/purescript-freeap/5.0.1/docs/Control.Applicative.Free) & [source code](https://github.com/ethul/purescript-freeap/blob/v5.0.1/src/Control/Applicative/Free.purs#L22-L25) - a free `Applicative` for any type of kind `Type -> Type`. Here's the [related paper](https://arxiv.org/pdf/1403.0749.pdf), which will likely make more sense once we explain how the `Free` monad works.
- Free (the original version) - a free `Monad` for any `Functor`. Its implementation suffers from big performance problems when run.
- Free (reflection without remorse) - [docs](https://pursuit.purescript.org/packages/purescript-free/5.2.0/docs/Control.Monad.Free#t:Free) & [source code](https://github.com/purescript/purescript-free/blob/v5.1.0/src/Control/Monad/Free.purs#L37-L37) - a free `Monad` for any `Functor`. Its implementation removes the performance penalties of the original version and includes all of the optimizations discovered by Oleg Kiselyov (as stated by someone in PureScript's chatroom).

At this time, `Coyoneda` and `FreeAp` will not be discussed in this folder. Rather, the upcoming files will focus entirely on the `Free` monad.
