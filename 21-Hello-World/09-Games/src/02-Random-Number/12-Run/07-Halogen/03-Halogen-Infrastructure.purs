module Games.RandomNumber.Run.Halogen.Infrastructure where

import Prelude

import Games.RandomNumber.Core (unBounds, GameResult)
import Games.RandomNumber.Run.Core (game)
import Games.RandomNumber.Run.Domain (
  runCore
, NotifyUserF(..), _notifyUser, NOTIFY_USER
)
import Games.RandomNumber.Run.API (
  runDomain
, GET_USER_INPUT
, CreateRandomIntF(..), _createRandomInt, CREATE_RANDOM_INT
)
import Type.Row (type (+))
import Data.Functor.Variant (VariantF, on, inj)
import Run (Run, interpret)

import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Random (randomInt)
import Effect.Console (log)
import Halogen (liftEffect)
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)

import Games.RandomNumber.Run.Halogen.Terminal (terminal)

main :: Effect Unit
main = do
  HA.runHalogenAff do
    body <- HA.awaitBody
    io <- runUI terminal unit body

    gameResult <- runInfrastructure io.query
    io.query $ inj _notifyUser $ NotifyUserF ("Game result was: " <> show gameResult) unit

-- | (io :: HalogenIO).query
type QueryRoot = VariantF (NOTIFY_USER + GET_USER_INPUT + ()) ~> Aff

-- Algebras

-- the algebras that use the UI are defined in the eval function

createRandomIntToInfrastructure :: CreateRandomIntF ~> Aff
createRandomIntToInfrastructure (CreateRandomIntF bounds reply) = do
  random <- unBounds bounds (\l u ->
    liftEffect $ randomInt l u)
  pure (reply random)

-- | Translate API language into Aff
runAPI :: QueryRoot
       -> Run (NOTIFY_USER + GET_USER_INPUT + CREATE_RANDOM_INT + ())
       ~> Aff
runAPI query = interpret (
  query
    # on _createRandomInt createRandomIntToInfrastructure
  )

runInfrastructure :: QueryRoot -> Aff GameResult
runInfrastructure query =
  runAPI query (runDomain (runCore game))
