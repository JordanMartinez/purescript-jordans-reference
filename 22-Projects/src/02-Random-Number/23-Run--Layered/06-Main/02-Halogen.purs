module Games.RandomNumber.Run.Layered.Infrastructure.Halogen.Web where

import Prelude

import Effect (Effect)
import Games.RandomNumber.Run.Layered.HighLevelDomain (game)
import Games.RandomNumber.Run.Layered.LowLevelDomain (runHighLevelDomain)
import Games.RandomNumber.Run.Layered.API (runLowLevelDomainInHalogen)
import Games.RandomNumber.Run.Layered.Infrastructure.Halogen.Terminal (terminal)
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = do
  HA.runHalogenAff do
    body <- HA.awaitBody
    io <- runUI terminal unit body

    runLowLevelDomainInHalogen io.query (runHighLevelDomain game)
