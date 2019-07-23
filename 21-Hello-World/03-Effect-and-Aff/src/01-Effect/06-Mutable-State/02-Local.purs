module MutableState.Local where

import Prelude

import Control.Monad.ST as ST
import Control.Monad.ST.Ref as STRef
import Effect (Effect)
import Effect.Console (log)

main :: Effect Unit
main = do
  log "We will run some modifications on some local state \
      \and then try to modify it out of scope."
  let result = ST.run do
        {-
        At this level of indentation, we are in the ST monadic context.
        Since `log` returns an `Effect a`, we can't use it here.

        At this point in our understanding, we don't currently have a way
        to print the values of the local state to the console.

        We'll explain why this is a good thing later on in the `Debugging` folder.
        -}

        box <- STRef.new 0
        x0 <- STRef.read box

        _ <- STRef.write 5 box
        x1 <- STRef.read box

        newState <- STRef.modify (\oldState -> oldState + 1) box
        x3 <- STRef.read box

        value <- STRef.modify' (\oldState -> { state: oldState * 10, value: 30 }) box
        x4 <- STRef.read box

        let loop 0 = STRef.read box
            loop n = do
              _ <- STRef.modify (_ + 1) box
              loop (n - 1)

        loop 20

  log $ "Result of computation that used local state was: " <> show result

  log "Attempting to access `box` in this monadic context will result \
      \in a compiler error."
