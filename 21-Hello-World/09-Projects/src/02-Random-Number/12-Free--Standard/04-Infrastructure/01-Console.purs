module Games.RandomNumber.Free.Standard.Infrastructure.Console (main) where

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
import Games.RandomNumber.Free.Standard.Domain (game)
import Games.RandomNumber.Free.Standard.API (runDomain)

question :: String -> Interface -> Aff String
question message interface = do
  makeAff go
  where
    go handler = NR.question message (handler <<< Right) interface $> mempty

-- Level 0 / Machine Code
main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion

  runAff_
    (\_ -> close interface)
    (runDomain (\prompt -> question prompt interface) game)
