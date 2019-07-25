module HelloDoNotation where

import Prelude
import Effect (Effect)
import Effect.Console (log)

-- A refresher on 'do-notation'

-- This chain of functions via log
main' :: Effect Unit
main' = (log "This is outputted first") >>= (\_ ->
          (log "This is outputted second") >>= (\_ ->
            log "This is outputted third"
          )
        )

-- can become more readable using sugar syntax (do-notation):
main :: Effect Unit
main = do
  log "This is outputted first"
  log "This is outputted second"
  log "This is outputted third"
