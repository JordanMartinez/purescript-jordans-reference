module TimeoutAndInterval where

import Prelude
import Effect (Effect)
import Effect.Console (log, logShow)

-- new import
import Effect.Timer as T

main :: Effect Unit
main = do
  timeoutID <- T.setTimeout 1000 (log "This will run after 1 second")
  intervalID <- T.setInterval 10 (log "Interval ran!")
  log "Doing some other things...."
  log (evaluate 10 20)
  log "... Finished."
  log "Now cancelling interval"
  T.clearInterval intervalID
  log "Now cancelling timeout"
  T.clearTimeout timeoutID
  log "Program is done!"

evaluate :: Int -> Int -> String
evaluate x y | x < y = show x <> " is less than " <> show y
             | x > y = show x <> " is greater than " <> show y
             | otherwise = show x <> " is equal to " <> show y
