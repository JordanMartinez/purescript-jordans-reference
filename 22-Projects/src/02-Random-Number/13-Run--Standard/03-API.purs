module Games.RandomNumber.Run.Standard.API
  ( runDomainInConsole
  , runDomainInHalogen
  ) where

import Prelude

import Data.Functor.Variant (on)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Random (randomInt)
import Games.RandomNumber.Core (unBounds)
import Games.RandomNumber.Infrastructure.ReadLineAff (question)
import Games.RandomNumber.Run.Standard.Domain (NotifyUserF(..), _notifyUser, NOTIFY_USER, GetUserInputF(..), _getUserInput, GET_USER_INPUT, CreateRandomIntF(..), _createRandomInt, CREATE_RANDOM_INT)
import Games.RandomNumber.Run.Standard.Infrastructure.Halogen.Terminal (Query)
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


runDomainInConsole :: Interface ->
                      Run ( NOTIFY_USER
                          + GET_USER_INPUT
                          + CREATE_RANDOM_INT
                          + ()
                          )
                   ~> Aff
runDomainInConsole interface = interpret (
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

-- For the `Run` approach, we will not be reusing the `terminal` component
-- like we did in the ReaderT and Free approach. Because Run allows us to
-- break apart our language, unlike Free, we'll just specify it's Query type
-- to be a subset of our Run language.
-- Thus, the Query type for Run's version of the 'terminal' Halogen component
-- is this:
--     type Query = VariantF (NOTIFY_USER + GET_USER_INPUT + ())

-- We can 'interpret' these by using the HalogenIO value that gets returned
-- from `runUI`:
-- (io :: HalogenIO) <- runUI -- args...
-- runDomainInHalogen io.query
--
-- This type will be: `Query ~> Aff`

runDomainInHalogen :: (Query ~> Aff) ->
                      Run ( NOTIFY_USER
                          + GET_USER_INPUT
                          + CREATE_RANDOM_INT
                          + ()
                          )
                   ~> Aff
runDomainInHalogen halogenIO_query = interpret (
    -- halogenIO_query will handle the NotifyUserF and GetUserInputF algebras
    halogenIO_query
      -- so we only need to account for the remaining case:
      --   random int generation
      # on _createRandomInt createRandomIntAlgebra
  )
