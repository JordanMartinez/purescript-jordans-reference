module Examples.HelloWorld.Run where

import Prelude
import Effect (Effect)
import Effect.Console as Console
import Type.Row (type (+))
import Type.Proxy (Proxy(..))
import Data.Functor.Variant (on)
import Run (Run, lift, interpret, case_)

-----------------------------------------
-- Core: Define any domain-specific concepts and their rules/relationships to
--         other domain-specific concepts

-- since there are no domain concepts or rules/relationships,
--    we won't include anything here...

-----------------------------------------
-- Domain: define business logic and capabilities need to run it:

-- - define our business logic as one pure function (program)
--      that uses data types that have Functor instances
--      to define the effects our program requires to be run
program :: forall r.
           Run                     -- A program that, given an interpreter that...
            ( LOG_TO_SCREEN        --    can enable logging to the screen
            + r                    --    and any other effects/capabilities
            )                      --       we may add later
            Unit                   -- ... will produce no output.
                                   -- However, running it will produce side-effects
                                   -- that make this program useful
program = do
  -- use capability to log a message to the console
  logToScreen "Hello World!"

-- - declare what the capabilities/effects are as data types with
--     derived instances for `Functor`,
--   define their type-level Strings that act as their corresponding label in a row,
--   define a type alias that makes using the data type in rows easier
--   and write their smart constructors.
data LogToScreen a = LogToScreen String a
derive instance functorLogToScreen :: Functor LogToScreen

_logToScreen :: Proxy "logToScreen"
_logToScreen = Proxy

type LOG_TO_SCREEN r = (logToScreen :: LogToScreen | r)

logToScreen :: forall r. String -> Run (LOG_TO_SCREEN + r) Unit
logToScreen msg = lift _logToScreen $ LogToScreen msg unit

-----------------------------------------
-- API: define how the pure domain concepts and logic above translate
--        into pure effects and impure effects via
--        "data type interpreters" (i.e. F-Algebras)

-- - an "interpreter" for each data type used above
logToScreenToEffect :: LogToScreen ~> Effect
logToScreenToEffect (LogToScreen msg next) = do
  Console.log msg
  pure next

-- Reader does not need to be done since `purescript-run` already defines
-- an interpreter via `runReader`

-- - an interpreter from the (Run <AllEffects>) type to the base monad, Effect.
--   Since we are not adding, any new effects/capabilities at this time,
--      we close the row kind using an empty row (i.e. "()")
--   Since we are using "open" row kinds, we need to use "case_" to insure that
--      all effects/capabilities are interpreted.
runProgram :: Run ( LOG_TO_SCREEN
                  + () -- closes the "open" row kinds of "program"
                  )
              ~> Effect
runProgram p =
  p
    -- use "interpret" and "case_" for capabilities
    # interpret (
        case_
          # on _logToScreen logToScreenToEffect
      )

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
