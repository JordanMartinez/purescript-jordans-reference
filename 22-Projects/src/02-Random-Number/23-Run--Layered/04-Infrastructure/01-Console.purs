module Games.RandomNumber.Run.Layered.Infrastructure.Console
  ( notifyUserToInfrastructure
  , getUserInputToInfrastructure
  , createRandomIntToInfrastructure
  , runAPI

  , main
  ) where

import Prelude
import Type.Row (type (+))
import Data.Functor.Variant (on)
import Run (Run, interpret, case_)
import Effect.Random (randomInt)
import Effect.Class (liftEffect)
import Effect (Effect)
import Effect.Console (log)
import Effect.Aff (Aff, runAff_)
import Node.ReadLine (
  Interface
, createConsoleInterface, noCompletion
, close
)

import Games.RandomNumber.Core (unBounds)
import Games.RandomNumber.Run.Layered.Domain (
  game
, NotifyUserF(..), _notifyUser, NOTIFY_USER
)
import Games.RandomNumber.Run.Layered.API (
  runDomain
, GetUserInputF(..), _getUserInput, GET_USER_INPUT
, CreateRandomIntF(..), _createRandomInt, CREATE_RANDOM_INT
)
import Games.RandomNumber.Infrastructure.ReadLineAff (question)

-- Algebras

notifyUserToInfrastructure :: NotifyUserF ~> Aff
notifyUserToInfrastructure (NotifyUserF msg next) = do
  liftEffect $ log msg
  pure next

getUserInputToInfrastructure :: Interface -> GetUserInputF ~> Aff
getUserInputToInfrastructure iface (GetUserInputF prompt reply) = do
  answer <- question iface prompt
  pure (reply answer)

createRandomIntToInfrastructure :: CreateRandomIntF ~> Aff
createRandomIntToInfrastructure (CreateRandomIntF bounds reply) = do
  random <- unBounds bounds (\l u ->
    liftEffect $ randomInt l u)
  pure (reply random)

-- Code

runAPI :: Interface
       -> Run (NOTIFY_USER + GET_USER_INPUT + CREATE_RANDOM_INT + ())
       ~> Aff
runAPI iface = interpret (
  case_
    # on _notifyUser notifyUserToInfrastructure
    # on _getUserInput (getUserInputToInfrastructure iface)
    # on _createRandomInt createRandomIntToInfrastructure
  )

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion

  runAff_
    (\_ -> close interface)
    (runAPI interface (runDomain game))
