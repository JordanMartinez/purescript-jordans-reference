module Projects.SimplestProgram.Run where

import Prelude
import Effect (Effect)
import Effect.Console as Console
import Effect.Random (randomInt)
import Type.Row (type (+))
import Data.Functor.Variant (on)
import Run (Run, FProxy, lift, interpret, case_)
import Data.Symbol (SProxy(..))

-----------------------------------------
-- Core: Define our hard-coded value:

newtype HardCodedInt = HardCodedInt Int

-----------------------------------------
-- Domain:

-- write our business logic as one function that uses capabilities (program)
program :: forall r. Run ( LOG_TO_SCREEN
                         + GENERATE_RANDOM_INT
                         + GET_HARDCODED_INT
                         + r
                         ) Unit
program = do
  -- use capability to generate random int
  randomInt <- generateRandomInt

  -- use capabilty to get value
  (HardCodedInt hardInt) <- getHardCodedInt

  -- do the comparison and convert the result into something more readable
  let comparisonResult = case compare hardInt randomInt of
          LT -> " < "
          GT -> " > "
          EQ -> " = "

  let message = show hardInt <> comparisonResult <> show randomInt

  -- use capability to log comparison to console
  logToScreen $ show message

-- declare what those capabilities are as data types.
data LogToScreen a = LogToScreen String a
derive instance ltsf :: Functor LogToScreen

data GenerateRandomInt a = GenerateRandomInt (Int -> a)
derive instance grif :: Functor GenerateRandomInt

data GetHardCodedInt a = GetHardCodedInt (HardCodedInt -> a)
derive instance ghcif :: Functor GetHardCodedInt

-- and smart construtors
_logToScreen :: SProxy "logToScreen"
_logToScreen = SProxy

type LOG_TO_SCREEN r = (logToScreen :: FProxy LogToScreen | r)

logToScreen :: forall r. String -> Run (LOG_TO_SCREEN + r) Unit
logToScreen msg = lift _logToScreen $ LogToScreen msg unit

_generateRandomInt :: SProxy "generateRandomInt"
_generateRandomInt = SProxy

type GENERATE_RANDOM_INT r = (generateRandomInt :: FProxy GenerateRandomInt | r)

generateRandomInt :: forall r. Run (GENERATE_RANDOM_INT + r) Int
generateRandomInt = lift _generateRandomInt $ GenerateRandomInt identity

_getHardCodedInt :: SProxy "getHardCodedInt"
_getHardCodedInt = SProxy

type GET_HARDCODED_INT r = (getHardCodedInt :: FProxy GetHardCodedInt | r)

getHardCodedInt :: forall r. Run (GET_HARDCODED_INT + r) HardCodedInt
getHardCodedInt = lift _getHardCodedInt $ GetHardCodedInt identity

-----------------------------------------
-- API: define the following things

-- - a natural transformation from each data type to the base monad
logToScreenToEffect :: LogToScreen ~> Effect
logToScreenToEffect (LogToScreen msg next) = do
  Console.log msg
  pure next

generateRandomIntToEffect :: GenerateRandomInt ~> Effect
generateRandomIntToEffect (GenerateRandomInt reply) = do
  random <- randomInt bottom top
  pure $ reply random

getHardCodedIntToEffect :: HardCodedInt -> GetHardCodedInt ~> Effect
getHardCodedIntToEffect hardCodedInt (GetHardCodedInt reply) = do
  pure $ reply hardCodedInt

-- - a function that handles Run's version of `foldFree`
runProgram :: HardCodedInt ->
             Run ( LOG_TO_SCREEN
                 + GENERATE_RANDOM_INT
                 + GET_HARDCODED_INT
                 + ()
                 )
          ~> Effect
runProgram hardCodedInt = interpret (
  case_
    # on _logToScreen logToScreenToEffect
    # on _generateRandomInt generateRandomIntToEffect
    # on _getHardCodedInt (getHardCodedIntToEffect hardCodedInt)
  )

-----------------------------------------
-- Infrastructure: We aren't using other libraries (Node.ReadLine, Halogen, etc.)
-- so nothing needs to go here for right now

-----------------------------------------
-- Machine Code: set up everything we need and then run the program

main :: Effect Unit
main = do
  runProgram (HardCodedInt 4) program
