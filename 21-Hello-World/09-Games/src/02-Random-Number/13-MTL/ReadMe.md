# MTL

`Core.purs` to `Infrastructure.purs` is a almost an exact copy of the `Run`-based example from before, just written in the `MTL` style via the ReaderT design/capability pattern.

## Comparing `Free`/`Run` to `MTL`

In the `Free`/`Run`-based approach, we had to chain interpreters together to run our code (e.g. `runAPI interface (runDomain (runCore game))`).

In the `MTL` approach, we will simply run one monad transformer, a newtyped version of the `ReaderT` (e.g. `runAPI interface game`). This will be called `AppM` (i.e. "application monad"...? I don't know if that's why it's usually named that way, but it works for me). Rather than "chaining" things together like `Free`, we implement an instance for each capability required by our newtyped `ReaderT` monad transformer.

These instances should be implemented by reusing capabilties from lower-level languages.

Below demonstrates the general pattern we will follow:
```purescript
type Envirnoment = { allGlobalThingsGoHere :: GlobalStuff
                   -- such as...
                   , globalMutableVariables :: MoreGlobalStuff
                   , infrastructureLevelFunctions :: InfrastructureCode
                -- , etc.
                   }

-- This is either `Effect` or `Aff`.
-- For now, we'll make it `Aff`
type MonadType = Aff
newtype AppM output = AppM (ReaderT Environment MonadType output)

-- Derive all the type classes for Functor up to Monad (shown at bottom of example)

-- Derive MonadEffect for AppM
derive newtype instance me :: MonadEffect AppM
  -- enables liftEffect :: Effect a -> AppM a

-- Derive `MonadAff` for `AppM` if `MonadType` is `Aff`
derive newtype instance ma :: MonadAff AppM
  -- enables liftAff :: Aff a -> AppM a

-- Since we're not newtyping the `Environment` record, we'll
-- need to use `TypeEquals` to convince the compiler that `Environment`
-- is the same thing as `e`
instance monadAsk :: TypeEquals e Environment => MonadAsk e AppM where
  ask = AppM $ asks from
  -- Now, whenever we use `ask`, it'll handle all the `AppM $` boilerplate
  -- for us by using the above implementation.

-- Define all our capabilities
class (Monad m) <= CoreCapability m where
  core :: m Unit

class (Monad m) <= DomainCapability m where
  domain :: String -> m String

class (Monad m) <= APICapability m where
  api :: Int -> Int -> m Number

-- Note: there is no InfrastructureCapability as that is covered
-- by the above `Environment` type.

-- re-use capabilities from lower levels (e.g. Domain)
instance coreStuff :: CoreCapability AppM where
  core = do
    domain "re-use the non-Infrastructure-Capability functions"

-- re-use the capabilities from lower levels (e.g. API)
instance domainStuff :: DomainCapability AppM where
  domain msg = do
    api 2 5

-- Now use MonadEffect/MonadAff functions here
-- to make testing easier
instance apiStuff :: APICapability AppM where
  api l u = do
    env <- ask
    env.valueOrFunction l u

-- Now create the actual computation
pureFunction :: forall m.
                CoreCapability m =>
                m Unit
pureFunction = do
  core

-- Now pass in the initial arguments:
main :: Effect Unit
main = do
  let env = { field: 4, function: (\x -> x < 4) }
  in runAppM env pureFunction
```
Following this pattern above, we can pass in different environment values that change how the API DSLs are interpreted into the actual impure runnable program:
- use real values: run the actual program
- use mocked values: test the program's business logic
