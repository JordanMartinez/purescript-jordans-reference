module Games.RandomNumber.Free.Infrastructure.Console (main) where

import Prelude
import Control.Monad.Free (foldFree)
import Data.Either (Either(..))
import Effect.Random (randomInt)
import Effect.Class (liftEffect)
import Effect (Effect)
import Effect.Console (log)
import Effect.Aff (Aff, runAff_, makeAff)
import Node.ReadLine ( Interface
                     , createConsoleInterface, noCompletion
                     , close
                     )
import Node.ReadLine as NR

import Games.RandomNumber.Core (unBounds)
import Games.RandomNumber.Free.Domain (game)
import Games.RandomNumber.Free.API (API_F(..), API, runDomain)

question :: String -> Interface -> Aff String
question message interface = do
  makeAff go
  where
    go handler = NR.question message (handler <<< Right) interface $> mempty

-- API to Infrastructure
runAPI :: Interface -> API ~> Aff
runAPI iface_ = foldFree (go iface_)

  where
  go :: Interface -> API_F ~> Aff
  go iface = case _ of
    Log msg next -> do
      liftEffect $ log msg
      pure next
    GetUserInput prompt reply -> do
      answer <- question prompt iface

      pure (reply answer)
    GenRandomInt bounds reply -> do
      random <- unBounds bounds (\l u -> liftEffect $ randomInt l u)

      pure (reply random)

-- Level 0 / Machine Code
main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion

  runAff_
    (\_ -> close interface)
    (runAPI interface (runDomain game))
