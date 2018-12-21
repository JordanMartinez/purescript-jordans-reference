module Games.RandomNumber.Free.Layered.Infrastructure.Halogen.Web where

import Prelude

import Control.Monad.Free (foldFree)
import Effect (Effect)
import Effect.Aff (Aff)
import Games.RandomNumber.Free.Layered.Domain (game)
import Games.RandomNumber.Free.Layered.API (API_F, API, runDomain)
import Games.RandomNumber.Free.Layered.Infrastructure.Halogen.Terminal (terminal)
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = do
  HA.runHalogenAff do
    body <- HA.awaitBody
    io <- runUI terminal unit body

    runAPI io.query (runDomain game)

-- | (io :: HalogenIO).query
type QueryRoot = API_F ~> Aff

-- API to Infrastructure
runAPI :: QueryRoot -> API ~> Aff
runAPI query = foldFree query
