module RandomNumber.Free.Standard.Infrastructure.Halogen.Web where

import Prelude

import Effect (Effect)
import RandomNumber.Free.Standard.Domain (game)
import RandomNumber.Free.Standard.API (runDomainInHalogen)
import RandomNumber.Free.Standard.Infrastructure.Halogen.Terminal (terminal)
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = do
  HA.runHalogenAff do
    body <- HA.awaitBody
    io <- runUI terminal unit body

    runDomainInHalogen io.query game
