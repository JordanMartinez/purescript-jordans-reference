module Examples.NumberComparison.Run where

import Prelude
import Effect (Effect)
import Effect.Console as Console
import Effect.Random (randomInt)
import Type.Row (type (+))
import Data.Functor.Variant (on)
import Run (Run, FProxy, lift, interpret, case_)
import Run.Reader (READER, runReader, ask)
import Data.Symbol (SProxy(..))

-----------------------------------------
-- Core: Define any domain-specific concepts and their rules/relationships to
--         other domain-specific concepts

-- define any domain-specif concepts
newtype HardCodedInt = HardCodedInt Int

-- and their rules and relationships to other concepts via
--  - functions
--  - type classes

-- Since there are no rules/relationships, we won't include anything here...

-----------------------------------------
-- Domain: define business logic and capabilities need to run it:

-- - define our business logic as one pure function (program)
--      that uses data types that have Functor instances
--      to define the effects our program requires to be run
program :: forall r.
           Run                     -- A program that, given an interpreter that...
            -- effects go first
            ( reader ::            --    can provide values/functions from the
                READER Environment --       global configuration type, Environment

            -- capabilities go second
            | LOG_TO_SCREEN        --    can enable logging to the screen
            + GENERATE_RANDOM_INT  --    can enable generating a random int
            + r                    --    and any other effects/capabilities
            )                      --       we may add later
            Unit                   -- ... will produce no output.
                                   -- However, running it will produce side-effects
                                   -- that make this program useful
program = do
  -- use capability to generate random int
  randomInt <- generateRandomInt

  -- use Reader effect to get the value
  -- (`purescript-run` does not include 'asks' for its Reader implementation,
  --    so this is the way to do the same thing)
  (HardCodedInt hardInt) <- ask <#> (\envRecord -> envRecord.hardCodedInt)

  -- use "let" syntax to do some intermediary pure computations:
  -- 1. do the comparison and convert the result into something more readable
  let comparisonResult = case compare hardInt randomInt of
          LT -> " < "
          GT -> " > "
          EQ -> " = "

  -- 2. create a message that clearly shows what the output will be
  let message = show hardInt <> comparisonResult <> show randomInt

  -- use capability to log comparison to console
  logToScreen message

-- - define an `Environment` record type alias that includes all things that are
--      available globally at all times. Note: This is only necessary because we're
--      using a ReaderT-like approach.
type Environment = { hardCodedInt :: HardCodedInt }

-- - declare what the capabilities/effects are as data types with
--     derived instances for `Functor`,
--   define their type-level Strings that act as their corresponding label in a row,
--   define a type alias that makes using the data type in rows easier
--   and write their smart constructors.
data LogToScreen a = LogToScreen String a
derive instance functorLogToScreen :: Functor LogToScreen

_logToScreen :: SProxy "logToScreen"
_logToScreen = SProxy

type LOG_TO_SCREEN r = (logToScreen :: FProxy LogToScreen | r)

logToScreen :: forall r. String -> Run (LOG_TO_SCREEN + r) Unit
logToScreen msg = lift _logToScreen $ LogToScreen msg unit
----
data GenerateRandomInt a = GenerateRandomInt (Int -> a)
derive instance functorGenerateRandomInt :: Functor GenerateRandomInt

_generateRandomInt :: SProxy "generateRandomInt"
_generateRandomInt = SProxy

type GENERATE_RANDOM_INT r = (generateRandomInt :: FProxy GenerateRandomInt | r)

generateRandomInt :: forall r. Run (GENERATE_RANDOM_INT + r) Int
generateRandomInt = lift _generateRandomInt $ GenerateRandomInt identity
----

-- we do not need to define Reader here since `purescript-run` already does so

-----------------------------------------
-- API: define how the pure domain concepts and logic above translate
--        into pure effects and impure effects via
--        "data type interpreters" (i.e. F-Algebras)

-- - an "interpreter" for each data type used above
logToScreenToEffect :: LogToScreen ~> Effect
logToScreenToEffect (LogToScreen msg next) = do
  Console.log msg
  pure next

generateRandomIntToEffect :: GenerateRandomInt ~> Effect
generateRandomIntToEffect (GenerateRandomInt reply) = do
  random <- randomInt bottom top
  pure $ reply random

-- Reader does not need to be done since `purescript-run` already defines
-- an interpreter via `runReader`

-- - an interpreter from the (Run <AllEffects>) type to the base monad, Effect.
--   Since we are not adding, any new effects/capabilities at this time,
--      we close the row kind using an empty row (i.e. "()")
--   Since we are using "open" row kinds, we need to use "case_" to insure that
--      all effects/capabilities are interpreted.
--   Any values or functions that are needed by Reader are passed in
--      from the outside (i.e. `envRecord`)
runProgram :: Environment ->
              Run ( reader :: READER Environment
                  | LOG_TO_SCREEN
                  + GENERATE_RANDOM_INT
                  + () -- closes the "open" row of "program"
                  )
              ~> Effect
runProgram envRecord p =
  p
    -- use "runX" for MTL effects
    # runReader envRecord

    -- use "interpret" and "case_" for capabilities
    # interpret (
        case_
          # on _logToScreen logToScreenToEffect
          # on _generateRandomInt generateRandomIntToEffect
      )

-----------------------------------------
-- Infrastructure: We aren't using other libraries (Node.ReadLine, Halogen, etc.)
-- so nothing needs to go here for right now

-----------------------------------------
-- Machine Code: set up everything we need and then run the program

main :: Effect Unit
main = do
  -- set up the environment
  let environment = { hardCodedInt: HardCodedInt 4 }

  -- run the program by passing in the environment and the final data type
  -- that includes all the instructions to run via their interpreters.
  runProgram environment program
