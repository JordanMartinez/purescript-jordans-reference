module Examples.HelloWorld.Free where

import Prelude
import Effect (Effect)
import Effect.Console as Console
import Control.Monad.Free (Free, liftF, foldFree)

-----------------------------------------
-- Core: Define any domain-specific concepts and their rules/relationships to
--         other domain-specific concepts

-- define any domain-specif concepts
newtype HardCodedInt = HardCodedInt Int

-- and their rules and relationships to other concepts via
--  - functions
--  - type classes

-- since there are no rules/relationships, we won't include anything here...

-----------------------------------------
-- Domain: define business logic and capabilities need to run it:

-- - define our business logic as one pure function (program)
--      that uses data types that have Functor instances
--      to define the effects our program requires to be run
program :: Free                       -- A program that...
            AllEffects                -- ... given an interpreter for each one of its 'effects'...
            Unit                      -- ... will produce no output.
                                      -- However, running it will produce side-effects
                                      -- that make this program useful
program = do
  -- use capability to log a message to the console
  logToScreen "Hello World!"

-- - define a type alias that defines what all our effects/capabilities are
type AllEffects =
    LogToScreen  -- we only have one, which enables logging to the screen

-- - declare what the capabilities/effects are as data types with
--     derived instances for `Functor` and write their smart constructors.
data LogToScreen a = LogToScreen String a
derive instance Functor LogToScreen

logToScreen :: String -> Free AllEffects Unit
logToScreen message = liftF $ LogToScreen message unit

-----------------------------------------
-- API: define how the pure domain concepts and logic above translate
--        into pure effects and impure effects via
--        "data type interpreters" (i.e. F-Algebras)

-- - an "interpreter" from each data type used above to the base monad, Effect
--    via a Natural Transformation
logToScreenToEffect :: LogToScreen ~> Effect
logToScreenToEffect (LogToScreen msg next) = do
  Console.log msg
  pure next

-- - an interpreter from the (Free AllEffects) type to the base monad, Effect,
--      using `foldFree` and the above interprters.
runProgram :: Free AllEffects ~> Effect
runProgram = foldFree go

  where
  -- - route each data type to its correct interpreter
  go :: AllEffects ~> Effect
  go = logToScreenToEffect

-----------------------------------------
-- Infrastructure: any other code (i.e. databases, frameworks, libraries)
--                   that provides effects that do not appear in `Effect.*` modules

-- We aren't using other libraries (Node.ReadLine, Halogen, etc.).
-- Thus, nothing needs to go here for right now


-----------------------------------------
-- Machine Code: set up everything we need and then run the program

main :: Effect Unit
main = do
  -- no global config to set up here

  -- run the program by passing in the final data type
  -- that includes all the instructions to run via their interpreters.
  runProgram program
