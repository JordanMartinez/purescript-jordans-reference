module RandomNumber.Free.Layered.Main.Halogen where

import Prelude

import Effect (Effect)
import RandomNumber.Free.Layered.HighLevelDomain (game)
import RandomNumber.Free.Layered.LowLevelDomain (runHighLevelDomain)
import RandomNumber.Free.Layered.API (runLowLevelDomainInHalogen)
import RandomNumber.Free.Layered.Infrastructure.Halogen.Terminal (terminal)
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = do
  HA.runHalogenAff do
    body <- HA.awaitBody
    io <- runUI terminal unit body

    runLowLevelDomainInHalogen io.query (runHighLevelDomain game)
