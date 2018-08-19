module LocalMutableState where

import Prelude
import Effect (Effect)
import Effect.Console (log)

-- new import
import Control.Monad.ST as ST
import Control.Monad.ST.Ref as STRef

main :: Effect Unit
main = do
  log "We will run some modifications on some local state\
      \ and then try to modify it out of scope."
  log $ show $ ST.run do
    -- only code inside of this block can modify `box`

    -- Note: since we're inside of a different monadic context
    --   we can't log values to the screen.
    --   bind :: forall m a b. m a -> (a -> m b) -> m b
    --    i.e. the monad type cannot change
    --   log = Effect monad; ST = ST monad; so bind doesn't work between them

    box <- STRef.new 0
    x0 <- STRef.read box
    -- log $ "x0 should be 0: " <> show x0

    _ <- STRef.write 5 box
    x1 <- STRef.read box
    -- log $ "x1 should be 5: " <> show x1

    -- log $ "STRef.modify_ doesn't exist; so skipping x2"

    newState <- STRef.modify (\oldState -> oldState + 1) box
    x3 <- STRef.read box
    -- log $ "x3 should be 7: " <> show x3 <> " | newState should be 7: " <> show newState

    value <- STRef.modify' (\oldState -> { state: oldState * 10, value: 30 }) box
    x4 <- STRef.read box
    -- log $ "value should be 30: " <> show value
    -- log $ "x4 should be 70: " <> show x4

    let loop 0 = STRef.read box
        loop n = do
          _ <- STRef.modify (_ + 1) box
          loop (n - 1)

    loop 20
  log "Attempting to access box here will result in a compiler error"
