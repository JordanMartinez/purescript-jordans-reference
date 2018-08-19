-- This is the infamous "Hello World" app in Purescript.
module HelloWorld where

import Prelude  -- imports Unit

-- new imports
import Effect (Effect)
import Effect.Console (log) -- log :: Effect Unit

-- | Describes but does not run a computation until RTS "calls unsafePerformEffect".
-- | Because the type signature of the last line's function`, `log`, is
-- | `Effect Unit`, it can be used as a main entry point into a program.
main :: Effect Unit
main = log "Hello world!"
