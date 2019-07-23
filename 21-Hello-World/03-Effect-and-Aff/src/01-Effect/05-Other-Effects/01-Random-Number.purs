module RandomNumber where

import Prelude
import Effect (Effect)
import Effect.Console (log)

-- new import
import Effect.Random (random)
-- random :: Effect Number

main :: Effect Unit
main = do
  n <- random
  log $ "A random number between 0.0 and 1.0: " <> show n

  -- The above two lines could also be combined into one
  --   if we resort to using bind-notation again:
  random >>= (\n2 -> log $ "Another random number: " <> show n2)

  -- The above line still works because `log` returns `Effect Unit`
