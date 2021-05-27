module Examples.NumberComparison.Free where

import Prelude
import Effect (Effect)
import Effect.Console as Console
import Effect.Random (randomInt)
import Control.Monad.Free (Free, liftF, foldFree)
import Data.Functor.Coproduct.Nested (Coproduct3, coproduct3)
import Data.Functor.Coproduct.Inject (inj)

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
  -- use capability to generate random int
  randomInt <- generateRandomInt

  -- use Reader effect to get value
  (HardCodedInt hardInt) <- asks \envRecord -> envRecord.hardCodedInt

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

-- - define a type alias that defines what all our effects/capabilities are
type AllEffects =
  Coproduct3              -- in total, we have 3 effects/capabilities
    LogToScreen           -- one of which enables logging to the screen
    GenerateRandomInt     -- one of which enables generating a random int
    (Reader Environment)  -- one which can get values/functions from the
                          --    global configuration type, Environment

-- - define an `Environment` record type alias that includes all things that are
--      available globally at all times. Note: This is only necessary because we're
--      using a ReaderT-like approach.
type Environment = { hardCodedInt :: HardCodedInt }

-- - declare what the capabilities/effects are as data types with
--     derived instances for `Functor` and write their smart constructors.
data LogToScreen a = LogToScreen String a
derive instance Functor LogToScreen

logToScreen :: String -> Free AllEffects Unit
logToScreen message = liftF $ inj $ LogToScreen message unit
-----
data GenerateRandomInt a = GenerateRandomInt (Int -> a)
derive instance Functor GenerateRandomInt

generateRandomInt :: Free AllEffects Int
generateRandomInt = liftF $ inj $ GenerateRandomInt identity
-----
newtype Reader e a = Reader (e -> a)
derive instance Functor (Reader e)

ask :: Free AllEffects Environment
ask = liftF $ inj $ Reader identity

asks :: forall a. (Environment -> a) -> Free AllEffects a
asks envToValue = liftF $ inj $ Reader envToValue

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

generateRandomIntToEffect :: GenerateRandomInt ~> Effect
generateRandomIntToEffect (GenerateRandomInt reply) = do
  random <- randomInt bottom top
  pure $ reply random

-- Any values or functions that are needed by Reader are passed in
-- from the outside (i.e. `envRecord`)
readerToEffect :: Environment -> Reader Environment ~> Effect
readerToEffect environment (Reader reply) = do
  pure $ reply environment

-- - an interpreter from the (Free AllEffects) type to the base monad, Effect,
--      using `foldFree` and the above interprters.
--      Any values or functions that are needed by Reader are passed in
--      from the outside (i.e. `envRecord`)
runProgram :: Environment -> Free AllEffects ~> Effect
runProgram envRecord = foldFree go

  where
  -- - route each data type in the containing Coproduct to its correct
  --    interpreter using the convenience function, `coproduct3`
  go :: AllEffects ~> Effect
  go =
    coproduct3
      logToScreenToEffect
      generateRandomIntToEffect
      (readerToEffect envRecord)

-----------------------------------------
-- Infrastructure: any other code (i.e. databases, frameworks, libraries)
--                   that provides effects that do not appear in `Effect.*` modules

-- We aren't using other libraries (Node.ReadLine, Halogen, etc.).
-- Thus, nothing needs to go here for right now


-----------------------------------------
-- Machine Code: set up everything we need and then run the program

main :: Effect Unit
main = do
  -- set up the environment
  let environment = { hardCodedInt: HardCodedInt 4 }

  -- run the program by passing in the environment and the final data type
  -- that includes all the instructions to run via their interpreters.
  runProgram environment program
