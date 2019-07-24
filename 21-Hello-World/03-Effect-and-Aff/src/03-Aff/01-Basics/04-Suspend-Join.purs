module AffBasics.SuspendJoin where

import Prelude

import Effect (Effect)
import Effect.Aff (Milliseconds(..), delay, joinFiber, launchAff_, suspendAff)
import SpecialLog (specialLog)

main :: Effect Unit
main = launchAff_ do
  let
    fiber1 = "Fiber 1"
    fiber2 = "Fiber 2"
    fiber3 = "Fiber 3"

  specialLog "Let's setup multiple computations. Then, we'll use \
             \`joinFiber` to actually run the computations for the first time. \
             \When they run, they will block until finished.\n"

  specialLog "Setting up the first fiber, but not yet running its computation."
  firstFiber <- suspendAff do
    specialLog $ fiber1 <> ": Waiting for 1 second until completion."
    delay $ Milliseconds 1000.0
    specialLog $ fiber1 <> ": Finished computation."

  specialLog "Setting up the second fiber, but not yet running its computation."
  secondFiber <- suspendAff do
    specialLog $ fiber2 <> ": Computation 1 (takes 300 ms)."
    delay $ Milliseconds 300.0

    specialLog $ fiber2 <> ": Computation 2 (takes 300 ms)."
    delay $ Milliseconds 300.0

    specialLog $ fiber2 <> ": Computation 3 (takes 500 ms)."
    delay $ Milliseconds 500.0
    specialLog $ fiber2 <> ": Finished computation."

  specialLog "Setting up the third fiber, but not yet running its computation."
  thirdFiber <- suspendAff do
    specialLog $ fiber3 <> ": Nothing to do. Just return immediately."
    specialLog $ fiber3 <> ": Finished computation."

  delay $ Milliseconds 1000.0

  specialLog "Now running the first fiber's computation and blocking \
             \until it finishes."
  joinFiber firstFiber

  specialLog "Now running the second fiber's computation and blocking \
             \until it finishes."
  joinFiber secondFiber

  specialLog "Now running the third fiber's computation and blocking \
             \until it finishes."
  joinFiber thirdFiber

  specialLog $ "All fibers have finished their computation."

  specialLog "Program finished."
