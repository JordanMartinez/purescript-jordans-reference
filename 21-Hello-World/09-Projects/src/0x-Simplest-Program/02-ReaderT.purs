module Projects.SimplestProgram.ReaderT where

import Prelude
import Effect (Effect)
import Effect.Console as Console
import Effect.Random (randomInt)
import Effect.Class (class MonadEffect, liftEffect)
import Control.Monad.Reader.Trans (ReaderT, runReaderT)
import Control.Monad.Reader.Class (class MonadAsk, ask, asks)
import Type.Equality (class TypeEquals, from)

-----------------------------------------
-- Core: Define our hard-coded value:

newtype HardCodedInt = HardCodedInt Int

-----------------------------------------
-- Domain:

-- write our business logic as one function that uses capabilities (program)

program :: forall m.
           LogToScreen m =>
           GenerateRandomInt m =>
           GetHardCodedInt m =>
           m Unit
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

-- declare what those dependencies are.
class (Monad m) <= LogToScreen m where
  logToScreen :: String -> m Unit

class (Monad m) <= GenerateRandomInt m where
  generateRandomInt :: m Int

class (Monad m) <= GetHardCodedInt m where
  getHardCodedInt :: m HardCodedInt

-----------------------------------------
-- API: define the following things

-- - an `Environment` record type alias that includes all things that are
--      available globally at all times
type Environment = { hardCodedInt :: HardCodedInt }

-- - a newtyped ReaderT monad called "AppM" that hard-codes the Environent
--      type and the base monad (Effect in this case)
newtype AppM a = AppM (ReaderT Environment Effect a)

-- - a 'runAppM' function that unwraps AppM newtype and runs the ReaderT program
runAppM :: Environment -> AppM ~> Effect
runAppM env (AppM m) = runReaderT m env

-- - a MonadAsk instance that uses TypeEquals to work around the "cannot use a
--      type alias (i.e. the `Environent` type) in type class instance"
--      restriction.
instance monadAskAppM :: TypeEquals e Environment => MonadAsk e AppM where
  ask = AppM $ asks from

-- - write instances for capabilities above, so that AppM can use them
instance logCapability :: LogToScreen AppM where
  logToScreen :: String -> AppM Unit
  logToScreen message = liftEffect $ Console.log message

instance generatorCapability :: GenerateRandomInt AppM where
  generateRandomInt :: AppM Int
  generateRandomInt = liftEffect $ randomInt bottom top

instance getGlobalValueCapability :: GetHardCodedInt AppM where
  getHardCodedInt :: AppM HardCodedInt
  getHardCodedInt = do
    envRecord <- ask
    pure $ envRecord.hardCodedInt

-- - derive instances for AppM, so that it is a Monad via ReaderT
derive newtype instance a1 :: Functor AppM
derive newtype instance a2 :: Applicative AppM
derive newtype instance a3 :: Apply AppM
derive newtype instance a4 :: Bind AppM
derive newtype instance a5 :: Monad AppM
derive newtype instance a6 :: MonadEffect AppM

-----------------------------------------
-- Infrastructure: We aren't using other libraries (Node.ReadLine, Halogen, etc.)
-- so nothing needs to go here for right now

-----------------------------------------
-- Machine Code: set up everything we need and then run the program

main :: Effect Unit
main = do
  -- set up the environment
  let environment = { hardCodedInt: HardCodedInt 4 }

  -- run the program by passing the Environment and the domain logic
  -- into the `runAppM` function
  runAppM environment program
