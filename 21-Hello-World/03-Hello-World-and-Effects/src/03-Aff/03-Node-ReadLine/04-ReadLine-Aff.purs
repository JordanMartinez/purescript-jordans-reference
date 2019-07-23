module ConsoleLessons.ReadLine.Aff where

import Prelude

import Data.Either (Either(..))
import Effect (Effect)
import Effect.Aff (Aff, runAff_, makeAff, nonCanceler)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Node.ReadLine (Interface, createConsoleInterface, noCompletion, close)
import Node.ReadLine as ReadLine

createInterface :: Effect Interface
createInterface = do
  log "Creating interface..."
  interface <- createConsoleInterface noCompletion -- no tab completion
  log "Created!\n"

  pure interface

closeInterface :: Interface -> Effect Unit
closeInterface interface = do
  log "Now closing interface"
  close interface
  log "Finished!"

useInterface :: Interface -> Aff Unit
useInterface interface = do
  -- lifting `log`'s output into an Aff monad context
  liftEffect $ log $ "Requesting user input..."

  -- querying user for info and waiting until receive user input
  answer <- interface # question "Type something here: "
  liftEffect $ log $ "You typed: '" <> answer <> "'\n"

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

  interface <- createInterface                                                 {-
  runAff_ :: forall a. (Either Error a -> Effect Unit) -> Aff a -> Effect Unit -}
  runAff_
    -- Ignore any errors and output and just close the interface
    (\_ -> closeInterface interface)
    (useInterface interface)
