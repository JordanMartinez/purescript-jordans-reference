module TimeoutAndInterval.Aff where

import Prelude

import Effect (Effect)
import Effect.Aff (Milliseconds(..), delay, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Effect.Timer as T

main :: Effect Unit
main = launchAff_ do
  timeoutID <- liftEffect $ T.setTimeout 1000 (log "This will run after 1 second")
  intervalID <- liftEffect $ T.setInterval 10 (log "Interval ran!")

  liftEffect do
    -- Since these three log calls use `bind` to sequence them into
    -- a single `Effect Unit` computation, we can reduce verbosity
    -- by lifting all of them using one `liftEffect`.
    log "Doing some other things...."
    log (evaluate 10 20)
    log "... Finished."

  liftEffect do
    log "Now cancelling interval"
    T.clearInterval intervalID

  -- Here, we'll delay the computation long enough to ensure the
  -- above timeout callback actually runs.
  delay (Milliseconds 1300.0)
  liftEffect do
    log "Now cancelling timeout"
    T.clearTimeout timeoutID

    log "Program is done!"

evaluate :: Int -> Int -> String
evaluate x y | x < y = show x <> " is less than " <> show y
             | x > y = show x <> " is greater than " <> show y
             | otherwise = show x <> " is equal to " <> show y
