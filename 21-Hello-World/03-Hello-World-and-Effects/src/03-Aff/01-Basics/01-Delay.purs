module AffBasics.Delay where

import Prelude

import Effect (Effect)
import Effect.Aff (Milliseconds(..), delay, launchAff_)
import SpecialLog (specialLog)

main :: Effect Unit
main = launchAff_ do
  specialLog "Let's print something to the console and then \
             \wait 1 second before printing another thing."

  delay $ Milliseconds 1000.0 -- 1 second

  specialLog "1 second has passed."
  specialLog "Program finished."
