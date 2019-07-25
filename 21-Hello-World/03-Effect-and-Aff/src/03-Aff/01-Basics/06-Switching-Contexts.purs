module AffBasics.SwitchingContexts where

import Prelude

import Effect (Effect)
import Effect.Aff (Milliseconds(..), delay, joinFiber, launchAff, launchAff_, launchSuspendedAff)
import Effect.Console (log)
import SpecialLog (specialLog)

-- This example was created to show what happens when `launchSuspendedAff`
-- is used and its requirement to be run in another Aff computation later.
--
-- It also shows the unpredictability of switching
-- between the synchronous Effect and asychronous Aff in this way.
main :: Effect Unit
main = do
  let
    fiber1 = "Fiber 1"
    fiber2 = "Fiber 2"

  log "This is an Effect computation (Effect monadic context).\n"

  -- Runs an Aff computation and returns the fiber that, when joined,
  -- will produce the computed value. It must be joined in a new
  -- `Aff` computation.
  firstFiber <- launchAff do
    specialLog $ fiber1 <> ": You will only see this message once!"
    delay $ Milliseconds 1000.0
    pure 10

  -- Creates an Aff computation, but does not run it. Rather, returns
  -- the fiber that, when joined, will start and finish the computation,
  -- returning the computed value when done. It must be joined in a new
  -- `Aff` computation.
  secondFiber <- launchSuspendedAff do
    specialLog $ fiber2 <> ": You will only see this message once!"
    delay $ Milliseconds 1000.0
    pure 50

  log "\nJust some other stuff we need to do in the Effect monadic context...\n"

  launchAff_ do
    specialLog "Back inside an Aff monadic context. Let's see what those \
               \fibers did!\n"

    result1 <- joinFiber firstFiber
    result2 <- joinFiber secondFiber

    specialLog "Finished joining fibers. After small pause, will join again \
               \to see whether their computations are rerun."
    delay $ Milliseconds 2000.0

    specialLog "Rejoining fibers!"
    result1_again <- joinFiber firstFiber
    result2_again <- joinFiber secondFiber
    specialLog "Finished joining fibers again."

    specialLog $ "Result 1 is the same? " <> show (result1 == result1_again)
    specialLog $ "Result 2 is the same? " <> show (result2 == result2_again)

  log "Back outside. Now in the Effect monadic context."
  log "=======================\n\
      \The end of our code, but not the end of our program.\n\
      \=======================\n"
