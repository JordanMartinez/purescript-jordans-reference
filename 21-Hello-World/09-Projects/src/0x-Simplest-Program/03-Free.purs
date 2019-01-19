module Projects.SimplestProgram.Free where

import Prelude
import Effect (Effect)
import Effect.Console as Console
import Effect.Random (randomInt)
import Control.Monad.Free (Free, liftF, foldFree)
import Data.Functor.Coproduct.Nested (Coproduct3, coproduct3)
import Data.Functor.Coproduct.Inject (inj)
-----------------------------------------
-- Core: Define our hard-coded value:

newtype HardCodedInt = HardCodedInt Int

-----------------------------------------
-- Domain:

-- write our business logic as one function that uses capabilities (program)

program :: Free AllEffects Unit
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

-- - combine all the data types together using a Coproduct
type AllEffects = Coproduct3 LogToScreen GenerateRandomInt GetHardCodedInt

-- - declare what those capabilities are as data types.
data LogToScreen a = LogToScreen String a
derive instance ltsf :: Functor LogToScreen

data GenerateRandomInt a = GenerateRandomInt (Int -> a)
derive instance grif :: Functor GenerateRandomInt

data GetHardCodedInt a = GetHardCodedInt (HardCodedInt -> a)
derive instance ghcif :: Functor GetHardCodedInt

-- - define their smart construtors
logToScreen :: String -> Free AllEffects Unit
logToScreen message = liftF $ inj $ LogToScreen message unit

generateRandomInt :: Free AllEffects Int
generateRandomInt = liftF $ inj $ GenerateRandomInt identity

getHardCodedInt :: Free AllEffects HardCodedInt
getHardCodedInt = liftF $ inj $ GetHardCodedInt identity

-----------------------------------------
-- API: define the following things

-- - a natural transformation from the AllEffects type to the base monad
--      that may use different environment values between different runs
runProgram :: HardCodedInt -> Free AllEffects ~> Effect
runProgram hardCodedInt = foldFree go

  where
  go :: AllEffects ~> Effect
  go =
    coproduct3
      (\(LogToScreen msg next) -> do
        Console.log msg
        pure next
      )
      (\(GenerateRandomInt reply) -> do
        random <- randomInt bottom top
        pure $ reply random
      )
      (\(GetHardCodedInt reply) -> do
        pure $ reply hardCodedInt
      )

-----------------------------------------
-- Infrastructure: We aren't using other libraries (Node.ReadLine, Halogen, etc.)
-- so nothing needs to go here for right now

-----------------------------------------
-- Machine Code: set up everything we need and then run the program

main :: Effect Unit
main = do
  runProgram (HardCodedInt 4) program
