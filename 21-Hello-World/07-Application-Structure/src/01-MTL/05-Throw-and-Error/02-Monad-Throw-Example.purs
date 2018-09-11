module ComputingWithMonads.MonadThrow where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Data.Identity (Identity(..))
import Data.Either (Either(..))
import Control.Monad.Error.Class (throwError)
import Control.Monad.Except (Except, runExcept)
import Control.Monad.Except.Trans (ExceptT(..))

compute :: Except String Int -> Effect Unit
compute theComputation =
  case runExcept theComputation of
    Left error   -> log $ "Failed computation! Error was:  " <> error
    Right output -> log $ "Successful computation! Output: " <> show output

main :: Effect Unit
main = do
  compute $ ExceptT (
    -- A computation
    Identity (
      -- that was successful and produced output
      Right 5
    )
  )

  compute $ ExceptT (
    -- A computation
    Identity (
      -- that failed and produced an error
      Left "Example error!"
    )
  )

  compute (
    -- a successful computation
    (ExceptT (Identity (Right 5))) >>= (\right_five ->
      (throwError "the next bind will never run!") >>= (\leftE_or_RightA ->
        case leftE_or_RightA of
          Left e -> ExceptT (pure $ Left "This is a different error message!")
          Right a -> ExceptT (pure $ Right $ a + 5)
      )
    )
  )
