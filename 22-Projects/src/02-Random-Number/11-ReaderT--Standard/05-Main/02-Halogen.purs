module Games.RandomNumber.ReaderT.Standard.Main.Halogen where

import Prelude

import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Random (randomInt)
import Games.RandomNumber.ReaderT.Standard.Domain (game)
import Games.RandomNumber.ReaderT.Standard.API (AppM, runAppM)
import Games.RandomNumber.Infrastructure.Halogen.Terminal (terminal, Query(..))
import Halogen (liftEffect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = do
  HA.runHalogenAff do
    body <- HA.awaitBody
    io <- runUI terminal unit body

    runAPI io.query game

-- | (io :: HalogenIO).query
type QueryRoot = Query ~> Aff

runAPI :: QueryRoot -> AppM ~> Aff
runAPI query =
  runAppM { notifyUser: (\msg -> query $ H.action $ NotifyUserF msg)
          , getUserInput: (\prompt -> query $ H.request $ GetUserInputF prompt)
          , createRandomInt: (\l u -> liftEffect $ randomInt l u)
          }
