# ReaderT Different Monad Test Analysis

This post comes out of my dialogue with `thomashoneyman` on Slack.

Some might say that there's a problem with how `AppM` works. Due to hard-coding the `Aff` monad in `AppM`'s type definition...
```haskell
-- source code: AppM
newtype AppM a = AppM (ReaderT Environment Aff a)
```
... we must create and use a completely different monad (i.e. `TestM`) for our tests:
```haskell
-- test code: TestM
newtype TestM a = TestM (ReaderT Environment (State (Array String)) a)
```

This leads to boilerplate. One way to improve this situation is to make the monad in our `AppM` definition generic, so that any monad type can be used there. Then, our instances for a specific type class is defined by using the `Environment` type.

By taking this approach, we'd rename `AppM` (a monad) to `AppT` (a monad transformer). **However, I would discourage this approach as the random number game's benchmarks shows that it runs slower than the `AppM` approach.**

To see how this works in practice, look at these files:
- `src/Random Number/ReaderT/Same-Monad.purs`
- `test/Random-Number/ReaderT-Same-Monad.purs`
