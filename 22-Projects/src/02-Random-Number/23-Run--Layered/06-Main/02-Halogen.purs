module RandomNumber.Run.Layered.Infrastructure.Halogen.Web where

import Prelude

import Effect (Effect)
import RandomNumber.Run.Layered.HighLevelDomain (game)
import RandomNumber.Run.Layered.LowLevelDomain (runHighLevelDomain)
import RandomNumber.Run.Layered.API (runLowLevelDomainInHalogen)
import RandomNumber.Run.Layered.Infrastructure.Halogen.Terminal (terminal)
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = do
  HA.runHalogenAff do
    body <- HA.awaitBody
    io <- runUI terminal unit body

    runLowLevelDomainInHalogen io.query (runHighLevelDomain game)
