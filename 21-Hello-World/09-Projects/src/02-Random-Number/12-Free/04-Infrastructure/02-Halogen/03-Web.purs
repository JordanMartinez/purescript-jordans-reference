module Games.RandomNumber.Free.Infrastructure.Halogen.Web where

import Prelude

import Control.Monad.Free (foldFree)
import Effect (Effect)
import Effect.Aff (Aff)
import Games.RandomNumber.Free.Core (game)
import Games.RandomNumber.Free.Domain (runCore)
import Games.RandomNumber.Free.API (API_F(..), API, runDomain)
import Games.RandomNumber.Free.Halogen.Terminal (terminal)
import Halogen as H
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = do
  HA.runHalogenAff do
    body <- HA.awaitBody
    io <- runUI terminal unit body

    runAPI io.query (runDomain (runCore game))

-- | (io :: HalogenIO).query
type QueryRoot = API_F ~> Aff

runAPI :: QueryRoot -> API ~> Aff
runAPI query = foldFree query
