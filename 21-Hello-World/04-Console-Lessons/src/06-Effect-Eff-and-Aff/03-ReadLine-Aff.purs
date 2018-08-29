  module ConsoleLessons.ReadLine.AffMonad where

import Prelude
import Effect (Effect)
import Effect.Console (log)

import Node.ReadLine ( Interface
  , createConsoleInterface, noCompletion
  , question, close)

import Data.Either (Either(..))

-- new imports
-- This will lift the `Effect` monad into another monad context (e.g. Aff),
-- enabling us to use `log` from Effect.
import Effect.Class (liftEffect)

import Effect.Aff (
  -- the Aff monad type
    Aff

  -- Indicates that asynchronous effect will not be cancelled.
  , nonCanceler

  -- To use Aff in our Effect context, we need to find a function
  -- that takes an `Aff` and returns an `Effect. runAff_ has
  -- the necessary type signature.`
  , runAff_

  -- Now we need a function that returns an `Aff`. makeAff has
  -- the necessary type signature
  , makeAff

  -- These two functions will be explained more below.
  )

-- simple Effect-based Node API to get our feet wet

createInterface :: Effect Interface
createInterface = do
  log "Creating interface..."
  interface <- createConsoleInterface noCompletion -- no tab completion
  log "Created!\n"

  pure interface

closeInterface :: Interface -> Effect Unit
closeInterface interface = do
  log "Now closing interface"
  close interface
  log "Finished!"

-- Once we have an interface, we want it to run asychronously
-- so that the output works as expected.
useInterface :: Interface -> Aff Unit
useInterface interface = do
  -- lifting `log`'s output into an Aff monad context
  liftEffect $ log $ "Requesting user input..."

  -- querying user for info and waiting until its inputted
  -- this type signature will be explained next
  answer <- question' "Type something here: " interface
  liftEffect $ log $ "You typed: '" <> answer <> "'\n"

-- This gets a bit complicated...
question' :: String -> Interface -> Aff String
question' message interface = do {-
  makeAff :: forall a.
             (
               (Either Error a -> Effect Unit)
               -> Effect Canceler
             )
             -> Aff a
  Read it as
    " Given a function (i.e. "replaceEffectInnardsWith")
        that can return `Effect Canceler`
        by using the function provided by 'runAff_' (i.e. "raF"),
    I can return an 'Aff'  " -}

  makeAff replaceEffectInnardsWith

  where
 -- So I don't have to import these types...

 {- passInputInto :: (Either Error a -> Effect Unit)
                  -> (String -> Effect Unit)                     -}
    passInputInto raF = (\userInput -> raF (Right userInput))
                     -- (raf <<< Right)


 -- askUser :: (Either Error a -> Effect Unit) -> Effect Unit
    askUser raF = question message (passInputInto raF) interface

 {- replaceEffectInnardsWith :: (Either Error a -> Effect Unit)
                             -> Effect Canceler -}
    replaceEffectInnardsWith raF = askUser raF $> nonCanceler

  {-
  voidLeft :: Functor f => f a -> b -> f b
  voidleft boxOfA b = (\_ -> b) <$> box

  infix_ _ voidLeft as $>
  -}


main :: Effect Unit
main = do
  log "\n\n" -- separate pulp output from program

  interface <- createInterface

  runProgram interface

runProgram :: Interface -> Effect Unit
runProgram interface = {-
  runAff_ :: forall a. (Either Error a -> Effect Unit) -> Aff a -> Effect Unit -}
  runAff_
    -- Ignore output of asynchronous computation and any errors it
    -- might raise and just close the interface once the computation
    -- is finished.
    (\_ -> closeInterface interface)
    -- The Aff to actually run and eventually convert into an Effect Unit
    (useInterface interface)
