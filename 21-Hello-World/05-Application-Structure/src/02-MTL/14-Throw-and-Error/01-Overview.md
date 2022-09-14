# Overview

## MonadThrow

`MonadThrow` is used to immediately stop `bind`'s sequential computation and return a value of its error type because of some unforeseeable error (e.g. error encountered when connecting to a database, file that was supposed to exist did not exist, etc).

It's default implmentation is `ExceptT`:
```haskell
             -- e     m     a
newtype ExceptT error monad output =
  ExceptT (monad (Either error output))

-- Pseudo-syntax: combines class and instancee together:
class (Monad m) => MonadThrow e (ExceptT e m) where
  throwError :: forall a. e -> ExceptT e m a
  throwError a = ExceptT (pure $ Left a)
```

### ExceptT: Before and After

Before using `ExceptT`, we would write this ugly verbose code:
```haskell
getBestCompany :: Industry -> Effect (Either Error Company)
getBoss :: Company -> Effect (Either Error Name)

main :: Effect Unit
main = do
  eitherCompany <- getBestCompany ComputerIndustry
  case eitherCompany of
    Left error -> log $ "Error: " <> show error
    Right bestCompany -> do
      eitherName <- getBoss bestCompany
      case eitherName of
        Left error -> log $ "Error: " <> show error
        Right name -> do
          log $ "The name of the best company is: " <> name
```

After using `ExceptT`, we would write this clear readable code:
```haskell
getBestCompany :: Industry -> Effect (Either Error Company)
getBoss :: Company -> Effect (Either Error Name)

main :: Effect Unit
main = do
  eitherResult <- runExceptT do
    bestCompany <- getBestCompany ComputerIndustry
    getBoss bestCompany
  case eitherResult of
    Left error -> log $ "Error: " <> show error
    Right name -> do
      log $ "The name of the best company is: " <> name
```

## MonadError

`MonadError` extends `MonadThrow` by enabling a monad to catch the thrown error, attempt to handle it (by changing the error type to an output type), and then continue `bind`'s sequential computation. If `catchError` can't handle the error, `bind`'s sequential computation will still stop at that point and return the value of the error type.

```haskell
newtype ExceptT e m a = ExceptT (m (Either e a))

class (Monad m) => MonadError e (ExceptT e m) where
  catchError :: forall a. ExceptT e m a -> (e -> ExceptT e m a) -> ExceptT e m a
  catchError (ExceptT m) handleError =
    ExceptT (m >>= (\either_E_or_A -> case either_E_or_A of
      Left e -> case handleError e of ExceptT b -> b
      Right a -> pure $ Right a))
```

For example,
```haskell
getFileContents :: forall m.
                   MonadError m =>
                   String ->
                   m String
getFileContents pathToFile = do
  readFileContents pathToFile `catchError` \fileNotFound ->
    pure defaultValue

  where
    defaultValue = "foo"
```

## Derived Functions

`MonadThrow` does not have any derived functions.

`MonadError` has 3 functions:
- `catchJust`: catch only the errors you want to try to handle and ignore the others
- `try`: expose the error value (if computation fails) for usage in the do notation
- `withResource`: whether a computation fails or succeeds, clean up resources after it is done

## Do Notation

Since MonadThrow/MonadError are error-related, we'll show the do notation in meta-language here since it will be harder to do so in the code examples:
```haskell
-- MonadThrow
stopped <- throwError e
value1 <- otherComputation stopped
value2 <- otherComputation value1

-- MonadError
mightRun <- computationThatMayFail `catchError` computationWhenPreviousFailed

left_Error   <- try computationThatFails
right_Output <- try computationThatSucceeds

output <- withResource getResource cleanup computationThatUsesResource
```

## Laws, Instances, and Miscellaneous Functions

For its laws, see
- [MonadThrow](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Error.Class#t:MonadThrow)
- [MonadError](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Error.Class#t:MonadError)

For `ExceptT`'s instances, see
- [Functor](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Except/Trans.purs#L55)
- [Apply](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Except/Trans.purs#L58)
- [Applicative](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Except/Trans.purs#L61)
- [Bind](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Except/Trans.purs#L64)
- [MonadThrow](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Except/Trans.purs#L111)
- [MonadError](https://github.com/purescript/purescript-transformers/blob/v4.1.0/src/Control/Monad/Except/Trans.purs#L114)

To handle/modify the output of an error computation:
- [Except](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Except#v:runExcept)
- [ExceptT](https://pursuit.purescript.org/packages/purescript-transformers/4.1.0/docs/Control.Monad.Except.Trans#v:runExceptT)
