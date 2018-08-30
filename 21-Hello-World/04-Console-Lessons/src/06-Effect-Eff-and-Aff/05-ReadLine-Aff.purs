  module ConsoleLessons.ReadLine.AffMonad where

import Prelude
import Effect (Effect)
import Effect.Console (log)

import Node.ReadLine ( Interface
  , createConsoleInterface, noCompletion
  , question, close)

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
  answer <- question' "Type something here: " interface
  liftEffect $ log $ "You typed: '" <> answer <> "'\n"

question' :: String -> Interface -> Aff String
question' message interface = makeAff go
  where
    -- Type signatures are commented out,
    --    so that I don't have to import these types

    -- go :: (Either Error a -> Effect Unit) -> Effect Canceler
    go runAffFunction = (effectBox runAffFunction) $> nonCanceler

    -- effectBox :: (Either Error a -> Effect Unit) -> Effect Unit
    effectBox raRF = question message (raRF <<< Right) interface


main :: Effect Unit
main = do
  log "\n\n" -- separate pulp output from program

  interface <- createInterface

  runProgram interface

runProgram :: Interface -> Effect Unit
runProgram interface = {-
  runAff_ :: forall a. (Either Error a -> Effect Unit) -> Aff a -> Effect Unit -}
  runAff_
    -- whether an error occurred or we got the output,
    -- just close the interface
    (\_ -> closeInterface interface)
    (useInterface interface)
