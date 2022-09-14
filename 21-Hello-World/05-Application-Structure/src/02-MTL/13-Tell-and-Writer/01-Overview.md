# Overview

## Monad Tell

`MonadTell` is used to return additional non-output data that is generated during a computation. For example, it can provide some sort of analysis of the computation we have just performed. It's default implementation is `WriterT`.

Since we can only return one object and we want to return something in addition to the output, we'll need to return a `Tuple` that wraps the output and additional data. In cases where we already have non-output data and need to "store" another value of non-output data, we'll need to combine the two together, which implies a `Semigroup`. Lastly, to implement `Applicative`, we will need an "empty" value of that data, which implies `Monoid`.

Putting this into code, we get this:
```haskell
             -- w               m     a
newtype WriterT non_output_data monad output =
  WriterT (monad (Tuple output non_output_data))

-- Pseudo-syntax: combines the type class and instance into one block
class (Monoid w, Monad m) <= MonadTell w (WriterT w m) where
  tell :: w -> m Unit
  tell w = WriterT (pure (Tuple unit w))
```

## Do Notation

Since `tell` returns an `m Unit`, which will be discarded in do notation, we'll only be writing:
```haskell
useReader :: Reader NonOuputData Output
useReader = do                                                          {-
  unit <- tell nonOuputData                                             -}
          tell nonOuputData
  -- without indentation
  tell nonOuputData
```

## Monad Writer

`MonadWriter` extends `MonadTell` by enabling a computation's non-output data to be
- appended via `tell` and then exposed in the do notation for later usage (`listen`)
- appended via `tell` **after** it is modified by a function (`pass`)

## Derived Functions

`MonadTell` does not have any derived functions.

`MonadWriter` has two:
- `listens`: same as `listen` but modifies the non-output data before exposing it to the do notation
- `censor`: modifies the non-output data returned by a computation before appending it via `tell`.

## Laws, Instances, and Miscellaneous Functions

For their laws, see
- [`MonadTell`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Writer.Class#t:MonadTell)
- [`MonadWriter`](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Writer.Class#t:MonadWriter)

For `WriterT`'s instances:
- [Functor](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Writer/Trans.purs#L49)
- [Apply](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Writer/Trans.purs#L52)
- [Applicative](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Writer/Trans.purs#L57)
- [Bind](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Writer/Trans.purs#L68)
- [MonadTell](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Writer/Trans.purs#L118)
- [MonadWriter](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Writer/Trans.purs#L121)

To handle/modify the output of a writer computation:
- [Writer](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Writer#v:writer)
- [WriterT](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Writer.Trans#v:runWriterT)
