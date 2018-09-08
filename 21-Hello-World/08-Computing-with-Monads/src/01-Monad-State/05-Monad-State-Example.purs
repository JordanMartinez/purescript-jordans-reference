module ComputingWithMonads.Example.MonadState where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Data.Tuple (Tuple(..))
import Data.String.CodePoints (length)
import Control.Monad.State.Class (modify, modify_, gets)
import Control.Monad.State (State, runState)

crazyFunction :: State Int String
crazyFunction = do
  value1 <- modify (_ + 1)
  modify_ (_ + (length $ show value1))
  gets show

main :: Effect Unit
main =
  case (runState crazyFunction 0) of
    Tuple theString theInt -> do
      log $ "theString was: " <> theString  -- "2"
      log $ "theInt was: " <> show theInt   --  2
