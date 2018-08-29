module ConsoleLessons.OverviewAPI where

import Prelude
import Effect (Effect)

-- new imports
import Node.ReadLine.CleanerInterface (
    -- handles all the code you don't understand yet
    -- so that you can read from and write to the console
      createUseCloseInterface

    -- displays a message and waits for user input, which can be obtained via
    -- "response <- question 'message' interface"
    , question

    -- logs the String to the console
    , log
    )

-- Interface is the type of "interface"
import Node.ReadLine (Interface)

-- Think of "Aff" as a more powerful "Effect".
-- It stands for "asychronous effect." We'll explain it more later.
import Effect.Aff (Aff)

main :: Effect Unit
main = createUseCloseInterface (\interface -> do
    log "Outputs this message to the console and continues"
    answer <- question "Outputs this message and wait for a response" interface
    log $ "You said: '" <> answer <> "'"

    whereFunction interface
  )
  where
  -- defining functions in a where block will likely have this type signature
  whereFunction :: Interface -> Aff Unit  -- or potentially "Aff String"
  whereFunction interface = do
    log "More examples!"
    answer <- question "What is your favorite color?" interface
    log $ "You said: '" <> answer <> "'"
