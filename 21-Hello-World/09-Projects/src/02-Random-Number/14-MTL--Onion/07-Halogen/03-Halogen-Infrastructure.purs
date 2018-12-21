module Games.RandomNumber.MTL.Halogen.Infrastructure where

import Prelude

import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Random (randomInt)
import Games.RandomNumber.MTL.Core (game)
import Games.RandomNumber.MTL.Infrastructure (AppM, runAppM)
import Games.RandomNumber.MTL.Halogen.Terminal (terminal, Query(..))
import Halogen (liftEffect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = do
  HA.runHalogenAff do
    body <- HA.awaitBody
    io <- runUI terminal unit body

    runInfrastructure io.query game

-- | (io :: HalogenIO).query
type QueryRoot = Query ~> Aff

runInfrastructure :: QueryRoot -> AppM ~> Aff
runInfrastructure query =
  runAppM { notifyUser: (\msg -> query $ H.action $ NotifyUserF msg)
          , getUserInput: (\prompt -> query $ H.request $ GetUserInputF prompt)
          , createRandomInt: (\l u -> liftEffect $ randomInt l u)
          }
