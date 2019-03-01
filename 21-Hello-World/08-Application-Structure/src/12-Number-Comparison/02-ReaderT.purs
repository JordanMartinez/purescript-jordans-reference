module Examples.NumberComparison.ReaderT where

import Prelude
import Effect (Effect)
import Effect.Console as Console
import Effect.Random (randomInt)
import Effect.Class (class MonadEffect, liftEffect)
import Control.Monad.Reader.Trans (ReaderT, runReaderT)
import Control.Monad.Reader.Class (class MonadAsk, asks)
import Type.Equality (class TypeEquals, from)

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
--      that uses type class constraints to define the effects our
--      program requires to be run
program :: forall m.                -- for any monad supporting these capabilities/effects--
           LogToScreen m =>         --   one of which is logging a message
           GenerateRandomInt m =>   --   one of which is generating a random int
           MonadAsk Environment m => --   one of which is getting info from a global record/config
                                    --    where that record type is "Environment"
           m Unit                   -- --running this monad will produce no output.
                                    -- However, it will side-effects that make running this code useful
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

-- - define an `Environment` record type alias that includes all things that are
--      available globally at all times. This is only necessary because we're
--      using a ReaderT-like approach.
type Environment = { hardCodedInt :: HardCodedInt }

-- - declare what those capabilities are as type classes.
class (Monad m) <= LogToScreen m where
  logToScreen :: String -> m Unit

class (Monad m) <= GenerateRandomInt m where
  generateRandomInt :: m Int

-----------------------------------------
-- API: define how the pure domain concepts and logic above translate
--        down into pure effects and impure effects via a `ReaderT`-based monad

-- - a newtyped ReaderT monad called "AppM" that hard-codes the Environent
--      type and the base monad (Effect in this case)
newtype AppM a = AppM (ReaderT Environment Effect a)

-- - a 'runAppM' function that unwraps the AppM newtype and runs the program
--      in the `Effect` monad, which is transformed/augmented by the ReaderT function
--      Any values or functions that are needed to provide effects
--      are passed in from the outside (i.e. `envRecord`)
runAppM :: Environment -> AppM ~> Effect
runAppM env (AppM m) = runReaderT m env

-- - a MonadAsk instance that uses TypeEquals to work around a restriction:
--      "cannot use a type alias (i.e. `Environent` type) in type class instance"
instance monadAskAppM :: TypeEquals e Environment => MonadAsk e AppM where
  ask = AppM $ asks from

-- - write instances for capabilities above, so that AppM can use them
instance logToScreenAppM :: LogToScreen AppM where
  logToScreen :: String -> AppM Unit
  logToScreen message = liftEffect $ Console.log message

instance generateRandomIntAppM :: GenerateRandomInt AppM where
  generateRandomInt :: AppM Int
  generateRandomInt = liftEffect $ randomInt bottom top

-- - derive instances for AppM, so that it is a Monad via ReaderT
derive newtype instance functorAppM :: Functor AppM
derive newtype instance applicativeAppM :: Applicative AppM
derive newtype instance applyAppM :: Apply AppM
derive newtype instance bindAppM :: Bind AppM
derive newtype instance monadAppM :: Monad AppM
derive newtype instance monadEffectAppM :: MonadEffect AppM

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

  -- run the program by passing the Environment and the domain logic
  -- into the `runAppM` function
  runAppM environment program
