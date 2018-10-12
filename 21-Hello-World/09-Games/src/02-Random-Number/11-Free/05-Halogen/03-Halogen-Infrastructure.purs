module Games.RandomNumber.Free.Halogen.Infrastructure where

import Prelude

import Games.RandomNumber.Free.Core (game)
import Games.RandomNumber.Free.Domain (runCore)
import Games.RandomNumber.Free.API (API_F(..), API, runDomain)
import Control.Monad.Free (foldFree)
import Effect (Effect)
import Effect.Aff (Aff)
import Halogen as H
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)

import Games.RandomNumber.Free.Halogen.Terminal (terminal)

main :: Effect Unit
main = do
  HA.runHalogenAff do
    body <- HA.awaitBody
    io <- runUI terminal unit body

    gameResult <- runAPI io.query (runDomain (runCore game))
    io.query $ H.action $ Log $ "Game result was: " <> show gameResult

-- | (io :: HalogenIO).query
type QueryRoot = API_F ~> Aff

runAPI :: QueryRoot -> API ~> Aff
runAPI query = foldFree query
