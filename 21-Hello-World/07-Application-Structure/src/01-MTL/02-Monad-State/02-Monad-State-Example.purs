module ComputingWithMonads.MonadState where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Data.Tuple (Tuple(..))
import Data.String.CodePoints (length)
import Control.Monad.State.Class (state, get, gets, put, modify, modify_)
import Control.Monad.State (State, runState)

main :: Effect Unit
main =
  case (runState sideBySideComparison 0) of
    Tuple s i -> do
      log $ "s was: " <> s
      log $ "i was: " <> show i

      case (runState crazyFunction 0) of
        Tuple theString theInt -> do
          log $ "theString was: " <> theString  -- "2"
          log $ "theInt was: " <> show theInt   --  2

crazyFunction :: State Int String
crazyFunction = do
  value1 <- modify (_ + 1)
  modify_ (_ + (length $ show value1))
  gets show

sideBySideComparison :: State Int String
sideBySideComparison = do
  state1  <- state (\s -> Tuple s s)
  state2  <- get

  shownI1 <- state (\s -> Tuple (show s) s)
  shownI2 <- gets show

  state (\s -> Tuple unit 5)
  put 5

  added1A <- state (\s -> let s' = s + 1 in Tuple s' s')
  added1B <- modify (_ + 1)

  state (\s -> Tuple unit (s + 1))
  modify_ (_ + 1)

  -- to satisfy the type requirements
  -- in that the function ultimately returns a `String`
  pure "string"
