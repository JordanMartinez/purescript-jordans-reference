module Games.RandomNumber.Free.Layered.Infrastructure.Console (main) where

import Prelude
import Control.Monad.Free (foldFree)
import Effect.Random (randomInt)
import Effect.Class (liftEffect)
import Effect (Effect)
import Effect.Console (log)
import Effect.Aff (Aff, runAff_)
import Node.ReadLine ( Interface
                     , createConsoleInterface, noCompletion
                     , close
                     )

import Games.RandomNumber.Core (unBounds)
import Games.RandomNumber.Free.Layered.Domain (game)
import Games.RandomNumber.Free.Layered.API (API_F(..), API, runDomain)
import Games.RandomNumber.Infrastructure.ReadLineAff (question)

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
      answer <- question iface prompt

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
