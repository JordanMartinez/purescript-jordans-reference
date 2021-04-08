-- Now that we understand how `Debug.Trace` works, let's show
-- what's going on in our previous local mutable state computation.
--
-- When you compile this file, it will output compiler warnings due to
-- usage of `Debug.Trace (traceM)`. If you wish to remove that noise,
-- comment out every usage of `traceM` in this file.
module Debugging.LocalState where

import Prelude

import Control.Monad.ST as ST
import Control.Monad.ST.Ref as STRef
import Debug (traceM)
import Effect (Effect)
import Effect.Console (log)

main :: Effect Unit
main = do
  log "We will run some modifications on some local state \
      \and then try to modify it out of scope."
  log $ show $ ST.run do
    box <- STRef.new 0
    x0 <- STRef.read box
    traceM $ "x0 should be 0: " <> show x0

    _ <- STRef.write 5 box
    x1 <- STRef.read box
    traceM $ "x1 should be 5: " <> show x1

    -- Note: `STRef.modify_` doesn't exist.

    newState <- STRef.modify (\oldState -> oldState + 1) box
    x2 <- STRef.read box
    traceM $ "x2 should be 6: " <> show x2 <> " | newState should be 6: " <> show newState

    value <- STRef.modify' (\oldState -> { state: oldState * 10, value: 30 }) box
    x3 <- STRef.read box
    traceM $ "value should be 30: " <> show value
    traceM $ "x3 should be 60: " <> show x3

    let loop 0 = STRef.read box
        loop n = do
          _ <- STRef.modify (_ + 1) box
          loop (n - 1)

    loop 20

  log "Attempting to access box here will result in a compiler error"
