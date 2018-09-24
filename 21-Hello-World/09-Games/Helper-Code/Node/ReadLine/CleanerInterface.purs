module Node.ReadLine.CleanerInterface
  ( createUseCloseInterface
  , question
  , log
  ) where

import Prelude
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Console as Console
import Effect.Aff (Aff, runAff_, makeAff)
import Data.Either (Either(Right))
import Node.ReadLine ( Interface
                     , createConsoleInterface, noCompletion
                     , close)
import Node.ReadLine as NR

createUseCloseInterface :: (Interface -> Aff Unit) -> Effect Unit
createUseCloseInterface useIF = do
  Console.log "\n\n" -- separate pulp output from program output

  interface <- createConsoleInterface noCompletion

  runAff_ (\_ -> close interface) (useIF interface)

question :: String -> Interface -> Aff String
question message interface = do
  makeAff go
  where
    go handler = NR.question message (handler <<< Right) interface $> mempty

log :: String -> Aff Unit
log message = liftEffect $ Console.log message
