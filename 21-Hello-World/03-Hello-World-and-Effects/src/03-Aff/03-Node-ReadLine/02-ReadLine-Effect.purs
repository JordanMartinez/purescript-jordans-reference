module ConsoleLessons.ReadLine.Effect where

import Prelude
import Effect (Effect)
import Effect.Console (log)

{-
This file will demonstrate why we can't use `Effect` to
work with `Node.ReadLine`.

Look through the code and then run it to see what happens.
-}

-- new imports
import Node.ReadLine ( Interface
                     , createConsoleInterface, noCompletion
                     , question, close)


type UseAnswer = (String -> Effect Unit)

main :: Effect Unit
main = do
  log "\n\n" -- separate output from program output

  interface <- createInterface
  useInterface interface
  closeInterface interface

  where

  createInterface :: Effect Interface
  createInterface = do
    log "Creating interface..."
    interface <- createConsoleInterface noCompletion
    log "Created!\n"

    pure interface

  useInterface :: Interface -> Effect Unit
  useInterface interface = do
    log "Requesting user input..."
    interface # question "Type something here: "
        \answer -> log $ "You typed: '" <> answer <> "'\n"

  closeInterface :: Interface -> Effect Unit
  closeInterface interface = do
    log "Now closing interface"
    close interface
    log "Finished!"

{-
One might expect the last part of this program to output the following:

   ... create interface output ...

   Requesting user input...
   Type something here: [user types 'something']
   You typed: 'something'

   Now closing interface
   Finished!
   [Program exit]

In reality, it outputs this:

   ... create interface output ...

   Requesting user input...
   Type something here: Now closing interface
   Finished!
   [Program exit]

The user never has a chance to type anything. Why?
Because `question` adds a listener to the input stream
that will run an action when the user has inputted some
text and pressed Enter, and then continues evaluating
the next statement. The next expression closes the interface,
prevnting the user from ever inputting anything.

In other words, it doesn't wait for the user to type in anything
before continuing its evaluation.

Now it's time to see how we would write the same thing above
using Aff.
-}
