-- When you compile this file, it will output compiler warnings due to
-- usage of `Debug.Trace (traceM)`. If you wish to remove that noise,
-- comment out every usage of `traceM` in this file.
module MutableState.Local where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Debug.Trace (traceM)

-- new import
import Control.Monad.ST as ST
import Control.Monad.ST.Ref as STRef

main :: Effect Unit
main = do
  log "We will run some modifications on some local state\
      \ and then try to modify it out of scope."
  log $ show $ ST.run do
    -- only code inside of this block can access and modify `box`

    -- Note: since we're inside of a different monadic context
    --   we can't log values to the screen using `log` like normal.
    -- Furthermore, `ST/STRef` does not have an instance for
    -- MonadEffect (covered later).
    -- Thus, we'll use `traceM` instead for its debugging purposes

    box <- STRef.new 0
    x0 <- STRef.read box
    traceM $ "x0 should be 0: " <> show x0

    _ <- STRef.write 5 box
    x1 <- STRef.read box
    traceM $ "x1 should be 5: " <> show x1

    traceM $ "STRef.modify_ doesn't exist; so skipping x2"

    newState <- STRef.modify (\oldState -> oldState + 1) box
    x3 <- STRef.read box
    traceM $ "x3 should be 7: " <> show x3 <> " | newState should be 7: " <> show newState

    value <- STRef.modify' (\oldState -> { state: oldState * 10, value: 30 }) box
    x4 <- STRef.read box
    traceM $ "value should be 30: " <> show value
    traceM $ "x4 should be 70: " <> show x4

    let loop 0 = STRef.read box
        loop n = do
          _ <- STRef.modify (_ + 1) box
          loop (n - 1)

    loop 20

  log "Attempting to access box here will result in a compiler error"
