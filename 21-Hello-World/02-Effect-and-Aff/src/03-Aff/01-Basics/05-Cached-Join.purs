module AffBasics.CachedJoin where

import Prelude

import Effect (Effect)
import Effect.Aff (Milliseconds(..), delay, forkAff, joinFiber, launchAff_, suspendAff)
import SpecialLog (specialLog)

main :: Effect Unit
main = launchAff_ do
  let
    fiber1 = "Fiber 1"
    fiber2 = "Fiber 2"

  specialLog "Let's compute multiple computations. Then, we'll refer to the \
             \value they produced multiple times to see that the result is \
             \cached.\n"

  firstFiber <- forkAff do
    specialLog $ fiber1 <> ": You will only see this message once!"
    delay $ Milliseconds 1000.0
    pure 10

  secondFiber <- suspendAff do
    specialLog $ fiber2 <> ": You will only see this message once!"
    delay $ Milliseconds 1000.0
    pure 50

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

  specialLog "Program finished."
