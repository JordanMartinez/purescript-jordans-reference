module TimeoutAndInterval where

import Prelude
import Effect (Effect)
import Effect.Console (log)

-- new import
import Effect.Timer as T

-- Unfortunately, the code below won't work as expected because
-- the callbacks never run. Not enough time passes before they get triggered.
-- We'll see how to fix this using the `Aff` monad later in this folder.
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
