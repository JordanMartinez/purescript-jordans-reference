module ComputingWithMonads.MonadError where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Data.Identity (Identity(..))
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Control.Monad.Error.Class (catchError, catchJust, try, withResource)
import Control.Monad.Except (Except, runExcept)
import Control.Monad.Except.Trans (ExceptT(..))

main :: Effect Unit
main = do
  runMainFunction
  log "=== Derived Functions ==="
  example_catchJust
  example_try
  example_withResource

computationThatFailsWith :: forall e. e -> Except e Int
computationThatFailsWith error = ExceptT (
    -- A computation
    Identity (
      -- that failed and produced an error
      Left error
    )
  )

computationThatSucceedsWith :: forall e a. a -> Except e a
computationThatSucceedsWith a = ExceptT (
    -- A computation
    Identity (
      -- that succeeded and produced the output
      Right a
    )
  )

compute :: forall e a. Show e => Show a => Except e a -> Effect Unit
compute theComputation =
  case runExcept theComputation of
    Left error   -> log $ "Failed computation! Error was:  " <> show error
    Right output -> log $ "Successful computation! Output: " <> show output

runMainFunction :: Effect Unit
runMainFunction = do
  log "catchError:"
  compute (
    catchError
      (computationThatFailsWith "An error string")

      -- and a function that successfully handles the error
      (\errorString -> ExceptT (pure $ Right 5))
  )

  compute (
    catchError
      (computationThatFailsWith "An error string")

      -- and a function that cannot handle the error successfully
      (\errorString -> ExceptT (pure $ Left errorString))
  )

-------------------

data ErrorType
  = FailedCompletely
  | CanHandle TheseErrors

data TheseErrors
  = Error1
  | Error2

example_catchJust :: Effect Unit
example_catchJust = do
  log "catchJust:"
  -- fail with an error that we ARE NOT catching...
  compute
    (catchJust
      ignore_FailedCompletely
      (computationThatFailsWith FailedCompletely)

      -- this function is never run because
      -- we ignore the "FailedCompletely" error instance
      handleError
    )

  -- fail with an error that we ARE catching...
  compute
    (catchJust
      ignore_FailedCompletely
      (computationThatFailsWith (CanHandle Error1))

      -- this function is run because we accept the
      -- error instance. It would also work if we threw `Error2`
      handleError
    )


ignore_FailedCompletely :: ErrorType -> Maybe TheseErrors
ignore_FailedCompletely FailedCompletely  = Nothing
ignore_FailedCompletely (CanHandle error) = Just error

handleError :: TheseErrors -> Except ErrorType Int
handleError Error1 = ExceptT (pure $ Right 5)
handleError Error2 = ExceptT (pure $ Right 6)

instance s1 :: Show ErrorType where
  show FailedCompletely  = "FailedCompletely"
  show (CanHandle error) = "CanHandle2 (" <> show error <> ")"

instance s2 :: Show TheseErrors where
  show Error1 = "Error1"
  show Error2 = "Error2"

-------------------

example_try :: Effect Unit
example_try = do
  log "try: "
  compute' (try $ computationThatSucceedsWith 5)
  compute' (try $ computationThatFailsWith "an error occurred!")

-- In `try`, both the error and output isntance is returned,
-- thereby exposing it for usage in the do notation. To account for this,
-- we've modified `compute` slightly below.
-- Also, since we only specify either the error type or the output type above,
-- type inference can't figure out what the other type is. So,
-- it thinks that the unknown type doesn't have a "Show" instance
-- and the compilation fails.
-- Thus, we also specify both types below to avoid this problem.
compute' :: Except String (Either String Int) -> Effect Unit
compute' theComputation =
  case runExcept theComputation of
    Left error   -> log $ "Failed computation! Error was:  " <> show error
    Right e_or_a -> case e_or_a of
      Left e  -> log $ "Exposed error instance in do notation: "  <> show e
      Right a -> log $ "Exposed output instance in do notation: " <> show a

-------------------

data Resource = Resource
instance showResource :: Show Resource where
  show x = "Resource"

example_withResource :: Effect Unit
example_withResource = do
  log "withResource: "
  compute (
    withResource
      getResource
      cleanupResource
      computationThatUseResource
  )

getResource :: Except String Resource
getResource = computationThatSucceedsWith Resource

cleanupResource :: Resource -> Except String Unit
cleanupResource r =
  -- resource is cleaned up here
  -- and when finished, we return unit
  ExceptT (pure $ Right unit)

computationThatUseResource :: Resource -> Except String Int
computationThatUseResource r = -- do
  -- use resource here to compute some value
  ExceptT (pure $ Right 5)
