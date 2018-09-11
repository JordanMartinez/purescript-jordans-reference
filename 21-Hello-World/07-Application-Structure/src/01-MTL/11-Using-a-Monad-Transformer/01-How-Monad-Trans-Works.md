# How MonadTrans Works

Thus far, we've overviewed individual Monad Transformers. However, we have not yet combined them into a stack that allows us to write anything useful. It's now time to reveal this. It will look similar to something we've seen before:
```purescript
class LiftSourceIntoTargetMonad sourceMonad targetMonad where {-
  liftSourceMonad :: forall a. sourceMonad a -> targetMonad a -}
  liftSourceMonad ::           sourceMonad   ~> targetMonad

instance box2_into_box1 :: LiftSourceIntoTargetMonad Box2 Box1 where {-
  liftSourceMonad :: forall a. Box2 a -> Box1 a                      -}
  liftSourceMonad ::           Box2   ~> Box1
  liftSourceMonad (Box2 a) = Box1 a
```
When we introduced `LiftSourceIntoTargetMonad`, we mentioned that implementing this idea for two monads might be much more complicated than the above implementation. Why? Because we were referring to the newtyped function monads we explained in this folder (not exactly something you want to introduce to a new learner immediately).

We stated beforehand that `MonadState` is only implemented by `StateT`. Because of `bind`'s type requirements, if we want to write a program that uses `MonadState` and another type class introduced in this folder (e.g. `MonadReader`), we'll need to define a way to run/lift the latter monad into the former. However, the direction should go both ways (former lifted into latter and latter lifted into former). Moreover, it would be best to define only one way to lift a number of different monads into the same target monad. Thus, this notion is abstracted into the type class, `MonadTrans`:
```purescript
class MonadTrans t where
  lift :: forall m a. Monad m => m a -> t m a

class LiftSIntoT s t where
  liftSource :: forall a. s ~> t
```

# How MonadTrans works

1. Define a type class (e.g. `MonadState`) that is only implemented by one monad (e.g. `StateT`)
2. Define a type class (e.g. `MonadTrans`) that enables one monad to be lifted into another monad
3. To enable multiples monads to run in one monad (e.g. `StateT`), implement `MonadTrans` for that monad (e.g. [StateT's instance](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/State/Trans.purs#L95))
4. To grant multiple monads the capabilities of one monad (e.g. `StateT`), make those other monads implement the one monad's type class (e.g. `MonadState`) in a special way (see below for a pattern):
    - [ReaderT's MonadState Implementation](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Reader/Trans.purs#L106)
    - [WriterT's MonadState Implementation](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Writer/Trans.purs#L115)
    - [ExceptT's MonadState Implementation](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Except/Trans.purs#L124)
    - [ContT's MonadState Implementation](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Cont/Trans.purs#L68)

Looking at those implementations above, we can see a general pattern (there are some exceptions to this due to how the types need to be handled, but this is generally true):
- Require one of the types in the instance to be an instance of `MonadState`
- Implement it by lifting that instance into the monad and delegate its implementation to that instance

Since only `StateT` actually implements `MonadState`, all other monads merely "transform" the `StateT` monad into some other target monad that is closer to the top of the stack. Likwise, since only `[Word]T` actually implements `Monad[Word]`, everything else is just lifting `[Word]T` into another monad that's closer to the top of the stack.

In short, this type class enables us to use all of the functions from each type class explained in this folder
