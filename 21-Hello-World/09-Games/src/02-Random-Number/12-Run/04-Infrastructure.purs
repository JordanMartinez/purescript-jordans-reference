module Games.RandomNumber.Run.Infrastructure
  ( notifyUserToInfrastructure
  , getUserInputToInfrastructure
  , createRandomIntToInfrastructure
  , runAPI

  , main
  ) where

import Prelude
import Type.Row (type (+))
import Data.Functor.Variant (on)
import Run (Run, interpret, send, AFF, liftAff, runBaseAff)
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

import Games.RandomNumber.Core (unBounds, GameResult(..))
import Games.RandomNumber.Run.Core (game)
import Games.RandomNumber.Run.Domain (
  runCore
, NotifyUserF(..), _notifyUser, NOTIFY_USER
)
import Games.RandomNumber.Run.API (
  runDomain
, GetUserInputF(..), _getUserInput, GET_USER_INPUT
, CreateRandomIntF(..), _createRandomInt, CREATE_RANDOM_INT
)

-- Algebras

notifyUserToInfrastructure :: forall r. NotifyUserF ~> Run (aff :: AFF | r)
notifyUserToInfrastructure (NotifyUserF msg next) = do
  liftAff $ liftEffect $ log msg
  pure next

getUserInputToInfrastructure :: forall r. Interface -> GetUserInputF ~> Run (aff :: AFF | r)
getUserInputToInfrastructure iface (GetUserInputF prompt reply) = do
  answer <- liftAff $ question prompt iface
  pure (reply answer)

createRandomIntToInfrastructure :: forall r. CreateRandomIntF ~> Run (aff :: AFF | r)
createRandomIntToInfrastructure (CreateRandomIntF bounds reply) = do
  random <- unBounds bounds (\l u ->
    liftAff $ liftEffect $ randomInt l u)
  pure (reply random)

-- Code

question :: String -> Interface -> Aff String
question message interface = do
  makeAff go
  where
    go handler = NR.question message (handler <<< Right) interface $> mempty

runAPI :: forall r
        . Interface
       -> Run (aff :: AFF | NOTIFY_USER + GET_USER_INPUT + CREATE_RANDOM_INT + r)
       ~> Run (aff :: AFF | r)
runAPI iface = interpret (
  send
    # on _notifyUser notifyUserToInfrastructure
    # on _getUserInput (getUserInputToInfrastructure iface)
    # on _createRandomInt createRandomIntToInfrastructure
  )

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion

  runAff_
    (\_ -> close interface)
    (runBaseAff $ runAPI interface (runDomain (runCore game)))
