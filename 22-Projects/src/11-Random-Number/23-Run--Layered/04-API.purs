module RandomNumber.Run.Layered.API
  ( runLowLevelDomainInConsole
  , TerminalQuery
  , runLowLevelDomainInHalogen
  ) where

import Prelude

import Data.Functor.Variant (VariantF, on)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Random (randomInt)
import RandomNumber.Core (unBounds)
import RandomNumber.Infrastructure.ReadLineAff (question)
import RandomNumber.Run.Layered.HighLevelDomain (NotifyUserF(..), _notifyUser, NOTIFY_USER)
import RandomNumber.Run.Layered.LowLevelDomain (GetUserInputF(..), _getUserInput, GET_USER_INPUT, CreateRandomIntF(..), _createRandomInt, CREATE_RANDOM_INT)
import Node.ReadLine (Interface)
import Run (Run, interpret, case_)
import Type.Row (type (+))

-- Algebras

-- This algebra is used throughout both implementations. So, we'll define it
-- here once rather than twice in each function's "where" clause
createRandomIntAlgebra :: CreateRandomIntF ~> Aff
createRandomIntAlgebra (CreateRandomIntF bounds reply) = do
  random <- unBounds bounds (\l u ->
    liftEffect $ randomInt l u)
  pure (reply random)


runLowLevelDomainInConsole :: Interface
                           -> Run ( NOTIFY_USER
                                  + GET_USER_INPUT
                                  + CREATE_RANDOM_INT
                                  + ()
                                  )
                           ~> Aff
runLowLevelDomainInConsole interface = interpret (
  case_
    # on _notifyUser notifyUserAlgebra
    # on _getUserInput getUserInputAlgebra
    # on _createRandomInt createRandomIntAlgebra
  )

  where
    notifyUserAlgebra :: NotifyUserF ~> Aff
    notifyUserAlgebra (NotifyUserF msg next) = do
      liftEffect $ log msg
      pure next

    getUserInputAlgebra :: GetUserInputF ~> Aff
    getUserInputAlgebra (GetUserInputF prompt reply) = do
      answer <- question interface prompt
      pure (reply answer)

type TerminalQuery = VariantF (NOTIFY_USER + GET_USER_INPUT + ())

runLowLevelDomainInHalogen :: (TerminalQuery ~> Aff)
                           -> Run ( NOTIFY_USER
                                  + GET_USER_INPUT
                                  + CREATE_RANDOM_INT
                                  + ()
                                  )
                           ~> Aff
runLowLevelDomainInHalogen halogenIO_query = interpret (
    -- halogenIO_query will handle the NotifyUserF and GetUserInputF algebras
    halogenIO_query
      -- so we only need to account for the remaining case:
      --   random int generation
      # on _createRandomInt createRandomIntAlgebra
  )
