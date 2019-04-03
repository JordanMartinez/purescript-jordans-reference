module Games.RandomNumber.Free.Standard.API (runDomainInConsole, runDomainInHalogen) where

import Prelude

import Control.Monad.Free (foldFree)
import Data.Functor.Coproduct (coproduct)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Random (randomInt)
import Games.RandomNumber.Core (unBounds)
import Games.RandomNumber.Free.Standard.Domain (API_F, BackendEffectsF(..), Game, GenRandomIntF(..))
import Games.RandomNumber.Infrastructure.ReadLineAff (question)
import Node.ReadLine (Interface)

-- Algebra used across both implementations
genRandomIntAlgebra :: GenRandomIntF ~> Aff
genRandomIntAlgebra (GenRandomInt bounds reply) = do
  random <- unBounds bounds (\l u -> liftEffect $ randomInt l u)

  pure (reply random)


-- API to Infrastructure
runDomainInConsole :: Interface -> Game ~> Aff
runDomainInConsole interface = foldFree go

  where
    go :: API_F ~> Aff
    go = coproduct backendAlgebra genRandomIntAlgebra

    backendAlgebra :: BackendEffectsF ~> Aff
    backendAlgebra = case _ of
      Log msg next -> do
        liftEffect $ log msg
        pure next
      GetUserInput prompt reply -> do
        answer <- question interface prompt

        pure (reply answer)

runDomainInHalogen :: (BackendEffectsF ~> Aff) -> Game ~> Aff
runDomainInHalogen halogenIO_query = foldFree go
  where
    go :: API_F ~> Aff
    go = coproduct halogenIO_query genRandomIntAlgebra
