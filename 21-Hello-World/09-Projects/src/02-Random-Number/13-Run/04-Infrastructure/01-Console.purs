module Games.RandomNumber.Run.Infrastructure.Console
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
import Data.Either (Either(..))
import Effect.Random (randomInt)
import Effect.Class (liftEffect)
import Effect (Effect)
import Effect.Console (log)
import Effect.Aff (Aff, runAff_, makeAff)
import Node.ReadLine (
  Interface
, createConsoleInterface, noCompletion
, close
)
import Node.ReadLine as NR

import Games.RandomNumber.Core (unBounds)
import Games.RandomNumber.Run.Domain (
  game
, NotifyUserF(..), _notifyUser, NOTIFY_USER
)
import Games.RandomNumber.Run.API (
  runDomain
, GetUserInputF(..), _getUserInput, GET_USER_INPUT
, CreateRandomIntF(..), _createRandomInt, CREATE_RANDOM_INT
)

-- Algebras

notifyUserToInfrastructure :: NotifyUserF ~> Aff
notifyUserToInfrastructure (NotifyUserF msg next) = do
  liftEffect $ log msg
  pure next

getUserInputToInfrastructure :: Interface -> GetUserInputF ~> Aff
getUserInputToInfrastructure iface (GetUserInputF prompt reply) = do
  answer <- question prompt iface
  pure (reply answer)

createRandomIntToInfrastructure :: CreateRandomIntF ~> Aff
createRandomIntToInfrastructure (CreateRandomIntF bounds reply) = do
  random <- unBounds bounds (\l u ->
    liftEffect $ randomInt l u)
  pure (reply random)

-- Code

question :: String -> Interface -> Aff String
question message interface = do
  makeAff go
  where
    go handler = NR.question message (handler <<< Right) interface $> mempty

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
