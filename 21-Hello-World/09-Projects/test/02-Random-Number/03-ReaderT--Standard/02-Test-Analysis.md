# ReaderT Different Monad Test Analysis

This post comes out of my dialogue with thomashoneyman on Slack.

Some might say that there's a problem with how `AppM` works. Due to hard-coding the `Aff` monad in `AppM`'s type definition...
```purescript
-- source code: AppM
newtype AppM a = AppM (ReaderT Environment Aff a)
```
... we must write use a completely different monad (i.e. `TestM`) for our tests:
```purescript
-- test code: TestM
newtype TestM a = TestM (ReaderT Environment (State (Array String)) a)
```

This leads to boilerplate. One way to improve this situation is to make the monad in our `AppM` definition generic, so that any monad type can be used there. Then, our instances for a specific type class is defined by using the `Environment` type.

Please, now look at `src`'s `ReaderT/Same-Monad.purs` file to see how we update our `AppM` definition. Once that's covered, look at the next file: `test/Random-Number/ReaderT-Same-Monad.purs`
