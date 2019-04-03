module RandomNumber.Free.Layered.API (runLowLevelDomainInConsole, runLowLevelDomainInHalogen) where

import Prelude

import Control.Monad.Free (foldFree)
import Data.Functor.Coproduct (coproduct)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Random (randomInt)
import RandomNumber.Core (unBounds)
import RandomNumber.Free.Layered.LowLevelDomain (API, API_F, BackendEffectsF(..), GenRandomIntF(..))
import RandomNumber.Infrastructure.ReadLineAff (question)
import Node.ReadLine (Interface)

-- Algebra used across both implementations
genRandomIntAlgebra :: GenRandomIntF ~> Aff
genRandomIntAlgebra (GenRandomInt bounds reply) = do
  random <- unBounds bounds (\l u -> liftEffect $ randomInt l u)

  pure (reply random)

-- Low-Level Domain to Infrastructure algebras
runLowLevelDomainInConsole :: Interface -> API ~> Aff
runLowLevelDomainInConsole interface = foldFree go

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

runLowLevelDomainInHalogen :: (BackendEffectsF ~> Aff) -> API ~> Aff
runLowLevelDomainInHalogen halogenIO_query = foldFree go
  where
    go :: API_F ~> Aff
    go = coproduct halogenIO_query genRandomIntAlgebra
