-- This is the infamous "Hello World" app in Purescript.
module HelloWorld where

import Prelude  -- imports Unit

-- new imports
import Effect (Effect)
import Effect.Console (log) -- log :: String -> Effect Unit

-- | Describes but does not run a computation until RTS "calls unsafePerformEffect".
-- | The type signature of `log` is `String -> Effect Unit`. Thus, by applying
-- | a value of type `String` as an argument to `log`,
-- | `log "Hello World!"` has the type signature `Effect Unit`.
-- | Thus, it can be used as a main entry point into a program.
main :: Effect Unit
main = log "Hello world!"
