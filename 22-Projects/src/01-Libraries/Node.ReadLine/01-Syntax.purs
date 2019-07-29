module Node.ReadLine.Aff where

import Prelude

import Data.Either (Either(..))
import Effect (Effect)
import Effect.Aff (Aff, bracket, launchAff_, makeAff, nonCanceler)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Node.ReadLine (Interface, createConsoleInterface, noCompletion, close)
import Node.ReadLine as RL

question :: String -> Interface -> Aff String
question message interface = makeAff \runAffFunction ->
  nonCanceler <$ RL.question message (runAffFunction <<< Right) interface

main :: Effect Unit
main = do
  log "\n\n" -- separate output from program

  launchAff_ $ bracketInterface \interface -> do
    answer <- interface # question "Type something here: "
    liftEffect $ log $ "You typed: '" <> answer <> "'\n"

  where
  bracketInterface :: (Interface -> Aff Unit) -> Aff Unit
  bracketInterface useInterface = do
    bracket
      (liftEffect $ createConsoleInterface noCompletion)
      (liftEffect <<< close)
      useInterface
