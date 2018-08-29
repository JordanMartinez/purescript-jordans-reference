module ConsoleLessons.ReadLine.Effect where

import Prelude
import Effect (Effect)
import Effect.Console (log)

{-
This file will demonstrate why we have not been using Effect to
teach our console-based lessons.

Look through the code and then run it to see what happens.
-}

-- new imports
import Node.ReadLine ( Interface
                     , createConsoleInterface, noCompletion
                     , question, close)


type UseAnswer = (String -> Effect Unit)
-- | This function moves `question`'s last arg to the front to make it
-- | easier to read. Otherwise, `interface` appears awkwardly at the end:
-- |    `question message (\answer ->
-- |      -- do something with answer
-- |      ) interface`
question' :: Interface -> String -> UseAnswer -> Effect Unit
question' iface message useAnswer = question message useAnswer iface

main :: Effect Unit
main = do
  log "\n\n" -- separate pulp output from program output

  interface <- createAndConfigureInterface
  useInterface interface
  closeInterface interface

  where

  createAndConfigureInterface :: Effect Interface
  createAndConfigureInterface = do
    log "Creating interface..."
    interface <- createConsoleInterface noCompletion
    log "Created!\n"

    pure interface

  useInterface :: Interface -> Effect Unit
  useInterface interface = do
    log "Requesting user input..."
    question' interface "Type something here: "
        (\answer -> log $ "You typed: '" <> answer <> "'\n")

  closeInterface :: Interface -> Effect Unit
  closeInterface interface = do
    log "Now closing interface"
    close interface
    log "Finished!"

{-
One might expect the last part of this program to output the following:

   ... create and configure interface output ...

   Requesting user input...
   Type something here: [user types 'something']
   You typed: 'something'

   Now closing interface
   Finished!
   [Program exit]

In reality, it outputs this:

   ... create and configure interface output ...

   Requesting user input...
   Type something here: Now closing interface
   Finished!
   [Program exit]

The user never has a chance to type anything. Why?
Because `question'`, and its underlying `question` function,
adds a listener to the input stream that will run an action
when the user has inputted some text and pressed Enter,
and then continues evaluating the next statement.
The next expression closes the interface,
prevnting the user from ever inputting anything.

In other words, it doesn't wait for the user to type in anything
before continuing its evaluation.

We got around this problem using the asychronous effect monad, Aff.
Now it's time to see how we would write the same thing above
using Aff.
-}
