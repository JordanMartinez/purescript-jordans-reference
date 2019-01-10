module Games.RandomNumber.Free.Standard.Infrastructure.Console (main) where

import Prelude
import Data.Either (Either(..))
import Effect (Effect)
import Effect.Aff (Aff, runAff_, makeAff)
import Node.ReadLine ( Interface
                     , createConsoleInterface, noCompletion
                     , close
                     )
import Node.ReadLine as NR

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
