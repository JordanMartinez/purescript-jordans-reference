module MutableState.Global where

import Prelude
import Effect (Effect)
import Effect.Console (log)

-- new import
import Effect.Ref as Ref

main :: Effect Unit
main = do
  box <- Ref.new 0

  x0 <- Ref.read box
  log $ "x0 should be 0: " <> show x0

  Ref.write 5 box
  Ref.read box >>= (\x1 -> log $ "x1 should be 5: " <> show x1)

  Ref.modify_ (\oldState -> oldState + 1) box
  x2 <- Ref.read box
  log $ "x2 should be 6: " <> show x2

  newState <- Ref.modify (\oldState -> oldState + 1) box
  x3 <- Ref.read box
  log $ "x3 should be 7: " <> show x3 <> " | newState should be 7: " <> show newState

  value <- Ref.modify' (\oldState -> { state: oldState * 10, value: 30 }) box
  x4 <- Ref.read box
  log $ "value should be 30: " <> show value
  log $ "x4 should be 70: " <> show x4

  let loop 0 = Ref.read box
      loop n = do
        _ <- Ref.modify (_ + 1) box
        loop (n - 1)
  _ <- loop 20
  log "Finished"
