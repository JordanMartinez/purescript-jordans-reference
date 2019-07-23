module SpecialLog (specialLog) where

import Prelude

import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Console (log)

specialLog :: String -> Aff Unit
specialLog msg = liftEffect $ log msg
