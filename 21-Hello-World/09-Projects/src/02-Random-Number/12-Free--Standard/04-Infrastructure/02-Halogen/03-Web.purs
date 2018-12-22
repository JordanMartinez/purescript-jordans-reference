module Games.RandomNumber.Free.Standard.Infrastructure.Halogen.Web where

import Prelude

import Control.Monad.Free (foldFree)
import Effect (Effect)
import Effect.Aff (Aff)
import Games.RandomNumber.Free.Standard.Domain (game, API_F, Game)
import Games.RandomNumber.Free.Standard.Infrastructure.Halogen.Terminal (terminal)
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = do
  HA.runHalogenAff do
    body <- HA.awaitBody
    io <- runUI terminal unit body

    runDomain io.query game

-- | (io :: HalogenIO).query
type QueryRoot = API_F ~> Aff

-- API to Infrastructure
runDomain :: QueryRoot -> Game ~> Aff
runDomain query = foldFree query
