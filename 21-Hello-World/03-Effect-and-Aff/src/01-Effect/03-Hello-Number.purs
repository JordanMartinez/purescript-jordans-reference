module HelloNumber where

import Prelude
import Effect (Effect)

-- new imports

-- logShow :: forall a. Show a => a -> Effect Unit
-- logShow arg = log $ show arg
import Effect.Console (logShow)

main :: Effect Unit
main = logShow 5
