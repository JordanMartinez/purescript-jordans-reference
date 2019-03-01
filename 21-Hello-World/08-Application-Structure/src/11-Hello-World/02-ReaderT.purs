module Examples.HelloWorld.ReaderT where

import Prelude
import Effect (Effect)
import Effect.Console as Console
import Effect.Class (class MonadEffect, liftEffect)
import Control.Monad.Reader.Trans (ReaderT, runReaderT)

-----------------------------------------
-- Core: Define any domain-specific concepts and their rules/relationships to
--         other domain-specific concepts

-- since there are no domain concepts or rules/relationships,
--    we won't include anything here...

-----------------------------------------
-- Domain: define business logic and capabilities need to run it:

-- - define our business logic as one pure function (program)
--      that uses type class constraints to define the effects our
--      program requires to be run
program :: forall m.                -- for any monad supporting these capabilities/effects--
           LogToScreen m =>         --   one of which is logging a message
           m Unit                   -- --running this monad will produce no output.
                                    -- However, running it will produce side-effects
                                    -- that make running this code useful
program = do
  -- use capability to log a message to the console
  logToScreen "Hello World!"

-- - declare what those capabilities are as type classes that require monadic types.
class (Monad m) <= LogToScreen m where
  logToScreen :: String -> m Unit

-----------------------------------------
-- API: define how the pure domain concepts and logic above translate
--        down into pure effects and impure effects via a `ReaderT`-based monad

-- - a newtyped ReaderT monad called "AppM" that hard-codes the Environent
--      type ("Unit" in this case because there is no global config value)
--      and the base monad (Effect in this case)
newtype AppM a = AppM (ReaderT Unit Effect a)

-- - a 'runAppM' function that unwraps the AppM newtype and runs the program
--      in the `Effect` monad, which is transformed/augmented by the ReaderT function
--      Since we don't have any global config being passed into our program,
--        we just pass in "unit"
runAppM :: AppM ~> Effect
runAppM (AppM m) = runReaderT m unit

-- - Since there is no global configuration value for this program
--      we do not need AppM to have an instance for MonadAsk
-- derive newtype instance a7 :: MonadAsk e AppM

-- - write instances for capabilities above, so that AppM can use them
instance logToScreenAppM :: LogToScreen AppM where
  logToScreen :: String -> AppM Unit
  logToScreen message = liftEffect $ Console.log message


-- - derive instances for AppM, so that it is a Monad via ReaderT
derive newtype instance functorAppM :: Functor AppM
derive newtype instance applicativeAppM :: Applicative AppM
derive newtype instance applyAppM :: Apply AppM
derive newtype instance bindAppM :: Bind AppM
derive newtype instance monadAppM :: Monad AppM

-- - enable functions that return `Effect a` to be run inside our `AppM` program
--      such as Effect.Console.log
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
  -- no global config to set up here

  -- run the program by passing the domain logic into the `runAppM` function
  runAppM program
