module CurrentDateAndTime where

import Prelude
import Effect (Effect)
import Effect.Console (log, logShow)

-- new import
import Effect.Now as Now

main :: Effect Unit
main = do
  dateAndTime <- Now.nowDateTime
  logShow dateAndTime

  log "------------"

  -- To reduce the above to one line, we'll combine the two using bind-notation.
  -- Since `logShow` has the type signature `Effect Unit`, the do-notation
  -- still works.

  Now.nowDate >>= (\x -> logShow x)
  Now.nowTime >>= (\x -> logShow x)

  -- We could make the above even shorter by removing the 'x' argument
  Now.nowDate >>= logShow
  Now.nowTime >>= logShow
