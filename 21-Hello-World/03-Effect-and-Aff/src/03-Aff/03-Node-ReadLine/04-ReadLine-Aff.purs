module ConsoleLessons.ReadLine.Aff where

import Prelude

import Data.Either (Either(..))
import Effect (Effect)
import Effect.Aff (Aff, runAff_, makeAff, nonCanceler)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Node.ReadLine (Interface, createConsoleInterface, noCompletion, close)
import Node.ReadLine as ReadLine

-- This is `affQuestion` from the previous file
question :: String -> Interface -> Aff String
question message interface = makeAff go
  where
    -- go :: (Either Error a -> Effect Unit) -> Effect Canceler
    go runAffFunction = nonCanceler <$
      ReadLine.question message (runAffFunction <<< Right) interface

main :: Effect Unit
main = do
  log "\n\n" -- separate output from program

  log "Creating interface..."
  interface <- createConsoleInterface noCompletion
  log "Created!\n"
                                                                               {-
  runAff_ :: forall a. (Either Error a -> Effect Unit) -> Aff a -> Effect Unit -}
  runAff_
    -- Ignore any errors and output and just close the interface
    (\_ -> closeInterface interface)
    (useInterface interface)
  where
    closeInterface :: Interface -> Effect Unit
    closeInterface interface = do
      log "Now closing interface"
      close interface
      log "Finished!"

    -- Same code as before, but without the Pyramid of Doom!
    useInterface :: Interface -> Aff Unit
    useInterface interface = do
      liftEffect $ log "Requesting user input..."

      answer1 <- interface # question "Type something here (1): "
      liftEffect $ log $ "You typed: '" <> answer1 <> "'\n"

      answer2 <- interface # question "Type something here (2): "
      liftEffect $ log $ "You typed: '" <> answer2 <> "'\n"

      answer3 <- interface # question "Type something here (3): "
      liftEffect $ log $ "You typed: '" <> answer3 <> "'\n"

      answer4 <- interface # question "Type something here (4): "
      liftEffect $ log $ "You typed: '" <> answer4 <> "'\n"

      answer5 <- interface # question "Type something here (5): "
      liftEffect $ log $ "You typed: '" <> answer5 <> "'\n"
