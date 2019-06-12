module RandomNumber.ReaderT.Standard.Main.Halogen where

import Prelude

import Data.Maybe (Maybe)
import Effect (Effect)
import Effect.Aff (Aff, forkAff)
import Effect.Aff.AVar as AVar
import Effect.Random (randomInt)
import RandomNumber.ReaderT.Standard.Domain (game)
import RandomNumber.ReaderT.Standard.API (AppM, runAppM)
import RandomNumber.Infrastructure.Halogen.Terminal (terminal, Query(..))
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
-- type QueryRoot a = Query a -> Aff (Maybe a)

runAPI :: (Query Unit -> Aff (Maybe Unit)) -> AppM ~> Aff
runAPI query =
  runAppM { notifyUser: (\msg -> void $ query $ H.tell $ NotifyUserF msg)
          , getUserInput
          , createRandomInt: (\l u -> liftEffect $ randomInt l u)
          }

  where
    getUserInput :: String -> Aff String
    getUserInput prompt = do
      -- Due to Halogen 5's API change a request-style query
      -- now returns `Maybe a` instead of just `a` (Halogen v4)
      -- This example is actually an anti-pattern. I would not recommend
      -- using it in real production code.
      -- However, to make this example still work, I'm including it here.
      avar <- AVar.empty
      void $ forkAff do
        void $ query $ H.tell $ GetUserInputF prompt avar
      AVar.take avar
