module SpecialLog (specialLog) where

specialLog :: String -> Aff Unit
specialLog msg = liftEffect $ log msg
