module AffBasics.LaunchAff where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff, launchAff_)
import Effect.Console (log)
import SpecialLog (specialLog)

main :: Effect Unit
main = do
  log "This is an Effect computation (Effect monadic context).\n"

  void $ launchAff do
    specialLog "This is an Aff computation (Aff monadic context)."

    specialLog "Aff provides the `launchAff` function that enables an \
               \Aff computation to run inside an Effect monadic context.\n"

  launchAff_ do
    specialLog "`launchAff_` is just `void $ launchAff`.\n"

  log "Program finished."
