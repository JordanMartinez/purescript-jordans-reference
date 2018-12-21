module Games.RandomNumber.Run.Layered.Infrastructure.Halogen.Web where

import Prelude

import Data.Functor.Variant (VariantF, on)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Random (randomInt)
import Games.RandomNumber.Core (unBounds, GameResult)
import Games.RandomNumber.Run.Layered.Domain (game, NOTIFY_USER)
import Games.RandomNumber.Run.Layered.API (
  runDomain
, GET_USER_INPUT
, CreateRandomIntF(..), _createRandomInt, CREATE_RANDOM_INT
)
import Games.RandomNumber.Run.Layered.Infrastructure.Halogen.Terminal (terminal)
import Halogen (liftEffect)
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import Run (Run, interpret)
import Type.Row (type (+))

main :: Effect Unit
main = do
  HA.runHalogenAff do
    body <- HA.awaitBody
    io <- runUI terminal unit body

    runInfrastructure io.query

-- | (io :: HalogenIO).query
type QueryRoot = VariantF (NOTIFY_USER + GET_USER_INPUT + ()) ~> Aff

-- Algebras

-- the algebras that use the UI are defined
-- in the root component's eval function

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
  runAPI query (runDomain game)
