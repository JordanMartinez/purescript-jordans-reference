module Free.RunBased.Value (main, value, example_value) where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Run (Run, extract)

value :: forall r. Int -> Run r Int
value i = pure i

example_value :: forall r. Run r Int
example_value = value 5

main :: Effect Unit
main = do
  log $ show $ extract example_value
