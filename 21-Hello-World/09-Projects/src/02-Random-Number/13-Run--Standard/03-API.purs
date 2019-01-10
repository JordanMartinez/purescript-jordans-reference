module Games.RandomNumber.Run.Standard.API
  ( runDomain
  , notifyUserAlgebra, getUserInputAlgebra, createRandomIntAlgebra
  ) where

import Prelude
import Type.Row (type (+))
import Data.Functor.Variant (on)
import Run (Run, interpret, case_)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Random (randomInt)
import Games.RandomNumber.Core (unBounds)

import Games.RandomNumber.Run.Standard.Domain (
  NotifyUserF(..), _notifyUser, NOTIFY_USER
, GetUserInputF(..), _getUserInput, GET_USER_INPUT
, CreateRandomIntF(..), _createRandomInt, CREATE_RANDOM_INT
)

-- Algebras

notifyUserAlgebra :: NotifyUserF ~> Aff
notifyUserAlgebra (NotifyUserF msg next) = do
  liftEffect $ log msg
  pure next

getUserInputAlgebra :: (String -> Aff String) -> GetUserInputF ~> Aff
getUserInputAlgebra getInput (GetUserInputF prompt reply) = do
  answer <- getInput prompt
  pure (reply answer)

createRandomIntAlgebra :: CreateRandomIntF ~> Aff
createRandomIntAlgebra (CreateRandomIntF bounds reply) = do
  random <- unBounds bounds (\l u ->
    liftEffect $ randomInt l u)
  pure (reply random)


runDomain :: (String -> Aff String) ->
             Run ( NOTIFY_USER
                 + GET_USER_INPUT
                 + CREATE_RANDOM_INT
                 + ()
                 )
          ~> Aff
runDomain getInput = interpret (
  case_
    # on _notifyUser notifyUserAlgebra
    # on _getUserInput (getUserInputAlgebra getInput)
    # on _createRandomInt createRandomIntAlgebra
  )
