module Games.RandomNumber.Free.Standard.API (runDomain) where

import Prelude

import Control.Monad.Free (Free, foldFree)
import Data.Int (fromString)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Random (randomInt)
import Games.RandomNumber.Core ( Bounds, unBounds, mkBounds, mkGuess, mkRandomInt
                               , mkRemainingGuesses, totalPossibleGuesses
                               )

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
