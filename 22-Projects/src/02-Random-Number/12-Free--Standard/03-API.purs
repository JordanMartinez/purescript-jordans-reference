module Games.RandomNumber.Free.Standard.API (runDomain) where

import Prelude

import Control.Monad.Free (foldFree)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Random (randomInt)
import Games.RandomNumber.Core (unBounds)

import Games.RandomNumber.Free.Standard.Domain (API_F(..), Game)

-- API to Infrastructure
runDomain :: (String -> Aff String) -> Game ~> Aff
runDomain getInput = foldFree go

  where
  go :: API_F ~> Aff
  go = case _ of
    Log msg next -> do
      liftEffect $ log msg
      pure next
    GetUserInput prompt reply -> do
      answer <- getInput prompt

      pure (reply answer)
    GenRandomInt bounds reply -> do
      random <- unBounds bounds (\l u -> liftEffect $ randomInt l u)

      pure (reply random)
