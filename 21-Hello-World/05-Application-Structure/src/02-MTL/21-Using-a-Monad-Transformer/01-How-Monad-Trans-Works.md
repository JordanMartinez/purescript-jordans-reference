# How MonadTrans Works

## Reviewing Old Ideas

Thus far, we've overviewed individual Monad Transformers. However, we have not yet combined them into a "stack" that allows us to write anything useful. It's now time to reveal this. It will look similar to something we've seen before:
```haskell
class LiftSourceIntoTargetMonad sourceMonad targetMonad where {-
  liftSourceMonad :: forall a. sourceMonad a -> targetMonad a -}
  liftSourceMonad ::           sourceMonad   ~> targetMonad

instance LiftSourceIntoTargetMonad Box2 Box1 where {-
  liftSourceMonad :: forall a. Box2 a -> Box1 a                      -}
  liftSourceMonad ::           Box2   ~> Box1
  liftSourceMonad (Box2 a) = Box1 a
```
When we introduced `LiftSourceIntoTargetMonad`, we mentioned that implementing this idea for two monads might be much more complicated than the above implementation. Why? Because we were referring to the newtyped function monads we explained in this folder (not exactly something you want to introduce to a new learner immediately).

We stated beforehand that `MonadState`'s default implmenetation is `StateT`. `bind` only returns the same monad type it originally received. Thus, we have a problem if we want to use two effects at once. For example, if we to write a program that uses state manipulation effects (i.e. uses  `MonadState`) and some other effects in the same computation (i.e. another type class introduced in this folder like `MonadReader`).

However, because our monadic newtyped functions serve only to "transform" the base monad by handling all the 'behind the scenes' stuff, it's actually possible to support all of these effects within the same monadic type. One monadic type is nested in another. This is where the "stack" idea comes from. In other words, we need to define a way to "lift" a monadic newtyped function into another. However, the direction should go both ways (former lifted into latter and latter lifted into former).

Since this idea is an abstraction that will repeat, will define it as a type class called, `MonadTrans`:
```haskell
class MonadTrans t where
  lift :: forall m a. Monad m => m a -> t m a

-- using clearer type names, one should read it as
class MonadTrans transformerCloserToBaseMonad where
  lift :: forall transformerFartherFromBaseMonad a.
          Monad transformerFartherFromBaseMonad =>
          transformerFartherFromBaseMonad a ->
          transformerCloserToBaseMonad transformerFartherFromBaseMonad a
```

## Explaining Its Process

1. Define a type class (e.g. `MonadState`) that has a default implementation via (e.g. `StateT`)
2. Define a type class (e.g. `MonadTrans`) that enables one monad to be lifted into another monad
3. To enable multiple monadic newtyped functions to run in another one (e.g. `StateT`), implement `MonadTrans` for that monad (e.g. [StateT's instance](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/State/Trans.purs#L95))
4. To grant multiple monadic newtyped functions the capabilities of one type class (e.g. `MonadState` via `StateT`), make those other monads implement the one monad's type class (e.g. `MonadState`) in a special way (see below for a pattern):
    - [ReaderT's MonadState Implementation](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Reader/Trans.purs#L106)
    - [WriterT's MonadState Implementation](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Writer/Trans.purs#L115)
    - [ExceptT's MonadState Implementation](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Except/Trans.purs#L124)
    - [ContT's MonadState Implementation](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Cont/Trans.purs#L68)

Looking at those implementations above, we can see a general pattern (there are some exceptions to this due to how the types need to be handled, but this is generally true):
- Require one of the types in the instance context to be an instance of `MonadState`
- Implement the type class by lifting the instance into the monad and delegate that monad's implementation to that instance. Again, the monadic newtyped functions are merely handling the "behind the scenes" stuff of the effects. At the end of the day, it's still the base monad that actually makes the whole thing work.

Thus, `[Word]T` provides a default implementation for `Monad[Word]` and makes it possible to grant the base monad its capability.

In short, this type class enables us to use all of the functions from each type class explained in this folder
