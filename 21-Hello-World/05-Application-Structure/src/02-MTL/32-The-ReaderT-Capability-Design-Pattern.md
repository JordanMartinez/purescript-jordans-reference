# The `ReaderT`/`Capability` Design Pattern

## The `ReaderT` and `Capability` Design Patterns

Some of the drawbacks of MTL (though not all of them) are what led to [the `ReaderT` Design Pattern](https://www.fpcomplete.com/blog/2017/06/readert-design-pattern) from which I originally got many of the above problems.

This design pattern was interpreted by others in a different way, so that it led to [the Capability Design Pattern](https://www.tweag.io/posts/2018-10-04-capability.html) post.

The main point of the `Capability Design Pattern` is that the `Monad[Word]` type classes define what effects will be used in some function, not necessarily how that will be accomplished. This key insight is what makes testing our business logic code much simpler.

For a clearer picture of this idea, see the [Three Layer Haskell Cake](https://www.parsonsmatt.org/2018/03/22/three_layer_haskell_cake.html).

Looking at the above from a top-down perspective, we get this:

| Layer Level | Onion Architecture Term | General idea |
| - | - | - |
| Layer 4 | Core | Strong types with well-defined properties and their pure, total functions that operate on them
| Layer 3 | Domain | the "business logic" code which uses effects
| Layer 2 | API | the "production" or "test" monad which "links" these effects/capabilties to their implementations: <ul><li>a newtyped `ReaderT` and its instances</li></ul>
| Layer 1 | Infrastructure | the platform-specific framework/monad we'll use to implement some special effects/capabilities (i.e. `Node.ReadLine`/`Halogen`/`StateT`)
| Layer 0 | Machine Code<br>(no equivalent onion term) | the "base" monad that runs the program (e.g. production: `Effect`/`Aff`; test: `Identity`/`Trampoline`)

Putting it into code, we would get something that looks like this:
```purescript
-- Layer 4

newtype Name = Name String

getName :: Name -> String
getName (Name s) = s

-- Layer 3

-- Capability type classes:
class (Monad m) <= LogToScreen m where
  log :: String -> m Unit

class (Monad m) <= GetUserName m where
  getUserName :: m Name

-- Business logic that uses these capabilities
-- which makes it easier to test
program :: forall m.
          LogToScreen m =>
          GetUserName m =>
          m Unit
program = do
  log "What is your name?"
  name <- getName
  log $ "You name is" <> (getName name)

-- Layer 2 (Production)

-- Environment type
type Environment = { } -- mutable state, read-only values, etc. go in this record

-- newtyped ReaderT that implements the capabilities
newtype AppM a = AppM (ReaderT Environment Effect a)

runApp :: AppM a -> Environment -> Effect a
runApp (AppM reader_T) env = runReaderT reader_T env

-- Layer 1 (the implementations of each instance)
instance lts :: LogToScreen AppM where
  log = liftEffect $ Console.log

instance gun :: GetUserName AppM where
  getName = liftEffect $ -- implementation

-- Layer 0 (production)
main :: Effect Unit
main = do
  let globalEnvironmentInfo = -- global stuff
  runApp program globalEnvironmentInfo

-----------------------
-- Layer 2 (test)

-- newtyped ReaderT that implements the capabilities for testing
newtype TestM a = TestM (Reader Environment a)

runTest :: TestM a -> Environment -> a
runTest (TestM reader) env = runReader reader env

-- Layer 1 (test: implementations of instances)
instance lts :: LogToScreen TestM where
  log = pure unit -- no need to implement this

instance gun :: GetUserName TestM where
  getName = pure (Name "John") -- general idea. Don't do this in real code.

-- Layer 0 (test)
main :: Effect Unit
main = do
  let globalEnvironmentInfo = -- mutable state, read-only values, etc.
  assert (runTest program globalEnvironmentInfo) == correctValue
```

## When to Use it: ReaderT Design Pattern vs Monad Transformer Stack?

| Scope of Code | Example | Use |
| - | - | - |
| Programming in the large<br>(e.g. Application Structure) | Connecting impure effects to their pure type classes via an API layer | `ReaderT`
| Programming in the small<br>(e.g. a single complicated computation) | Doing one particular computation that uses a number of effects that others in the surrounding context do not use | Monad Transformer Stack
