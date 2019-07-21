  module ConsoleLessons.ReadLine.AffMonad where

import Prelude
import Effect (Effect)
import Effect.Console (log)

import Node.ReadLine ( Interface
  , createConsoleInterface, noCompletion
  , question, close)
import Node.ReadLine as ReadLine

import Data.Either (Either(..))

-- new imports
-- This will lift the `Effect` monad into another monad context (i.e. Aff),
-- enabling us to use `log` from Effect in an `Aff` monad context.
import Effect.Class (liftEffect)

import Effect.Aff (Aff, runAff_, makeAff, nonCanceler)

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

-- This is `affQuestion` from earlier
question :: Interface -> String -> Aff String
question interface = makeAff go
  where
    -- go :: (Either Error a -> Effect Unit) -> Effect Canceler
    go raRF = ReadLine.question message (raRF <<< Right) interface $> nonCanceler


main :: Effect Unit
main = do
  log "\n\n" -- separate output from program

  interface <- createInterface

  runProgram interface

runProgram :: Interface -> Effect Unit
runProgram interface = {-
  runAff_ :: forall a. (Either Error a -> Effect Unit) -> Aff a -> Effect Unit -}
  runAff_
    -- Ignore any errors and output and just close the interface
    (\_ -> closeInterface interface)
    (useInterface interface)
