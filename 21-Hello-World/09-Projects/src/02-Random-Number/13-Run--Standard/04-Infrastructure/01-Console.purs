module Games.RandomNumber.Run.Standard.Infrastructure.Console
  ( main
  , question
  ) where

import Prelude
import Type.Row (type (+))
import Data.Functor.Variant (on)
import Run (Run, interpret, case_, runBaseAff)
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
import Games.RandomNumber.Run.Standard.Domain (
  game
, NotifyUserF(..), _notifyUser, NOTIFY_USER
, GetUserInputF(..), _getUserInput, GET_USER_INPUT
, CreateRandomIntF(..), _createRandomInt, CREATE_RANDOM_INT
)
import Games.RandomNumber.Run.Standard.API (
  runDomain
)

-- Code

question :: String -> Interface -> Aff String
question message interface = do
  makeAff go
  where
    go handler = NR.question message (handler <<< Right) interface $> mempty

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion

  runAff_
    (\_ -> close interface)
    (runDomain (\prompt -> question prompt interface) game)
