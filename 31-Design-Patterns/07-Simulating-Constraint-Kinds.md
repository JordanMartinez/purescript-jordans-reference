# Simulating Constraint Kinds

(The following 'trick' came from Chell Rattman on the PureScript FP Slack channel: `#purescript`)

Sometimes, one might write the following code that just appears too verbose:
```purescript
f :: forall m a.
     MonadAff m =>
     ConsoleIO m =>
     OtherTypeClass1 m =>
     OtherTypeClass2 m =>
     OtherTypeClass3 m =>
     OtherTypeClass4 m =>
     OtherTypeClass5 m =>
     Int -> m a
f = -- implementation
```
It would be easier if we could use a type alias to indicate all four of the above type class constraints like so:
```purescript
-- This is how Haskell does it
type MyMonad m =
  ( MonadAff m
  , ConsoleIO m
  , OtherTypeClass1 m
  , OtherTypeClass2 m
  , OtherTypeClass3 m
  , OtherTypeClass4 m
  , OtherTypeClass5 m
  )
f :: forall m a. MyMonad m => Int -> m a
```
However, the above will not compile because PureScript does not yet have "Constraint kinds." However, we can get around this by defining the type alias this way:
```purescript
-- PureScript with CPS
type WithMyMonad m a =
  ( MonadAff m
  , ConsoleIO m
  , OtherTypeClass1 m
  , OtherTypeClass2 m
  , OtherTypeClass3 m
  , OtherTypeClass4 m
  , OtherTypeClass5 m
  ) => a

-- Then our function's type signature looks like this:
f :: forall m a. MyMonad m (Int -> m a)

-- It seems like in situations where we don't have an argument,
-- we can write it like this:
g :: forall m a. MyMonad m (m a)
```
