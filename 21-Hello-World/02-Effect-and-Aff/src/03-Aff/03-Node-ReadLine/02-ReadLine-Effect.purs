module ConsoleLessons.ReadLine.Effect where

import Prelude
import Effect (Effect)
import Effect.Console (log)

{-
This file will demonstrate why using `Effect` to work with `Node.ReadLine`
creates the Pyramid of Doom.

Look through the code and then use the command in the folder's
ReadMe.md file to run it using Node (not Spago) to see what happens.
-}

-- new imports
import Node.ReadLine ( createConsoleInterface, noCompletion
                     , question, close)


type UseAnswer = (String -> Effect Unit)

main :: Effect Unit
main = do
  log "\n\n" -- separate output from program output

  log "Creating interface..."
  interface <- createConsoleInterface noCompletion
  log "Created!\n"

  log "Requesting user input..."
  interface # question "Type something here (1): " \answer1 -> do
    log $ "You typed: '" <> answer1 <> "'\n"
    interface # question "Type something here (2): " \answer2 -> do
      log $ "You typed: '" <> answer2 <> "'\n"
      interface # question "Type something here (3): " \answer3 -> do
        log $ "You typed: '" <> answer3 <> "'\n"
        interface # question "Type something here (4): " \answer4 -> do
          log $ "You typed: '" <> answer4 <> "'\n"
          interface # question "Type something here (5): " \answer5 -> do
            log $ "You typed: '" <> answer5 <> "'\n"

            log "Now closing interface"
            close interface
            log "Finished!"

          log "This will print as we wait for your 5th answer."
        log "This will print as we wait for your 4th answer."
      log "This will print as we wait for your 3rd answer."
    log "This will print as we wait for your 2nd answer."
  log "This will print as we wait for your 1st answer."
