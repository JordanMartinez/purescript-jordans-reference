# MTL - Test Analysis

This post comes out of my dialogue with thomashoneyman on Slack.

Some might say that there's a problem with how `AppM` works. Due to hard-coding the `Aff` monad in `AppM`'s type definition...
```purescript
-- source code: AppM
newtype AppM a = AppM (ReaderT Environment Aff a)
```
... we must write use a completely different `AppM` monad for our tests:
```purescript
-- test code: AppM
newtype AppM a = AppM (ReaderT Environment (State (Array String)) a)
```

This leads to one problem: out-of-sync code. A developer might accidentally make the Test AppM might implement its type class instances differently than the Source AppM. In such a case, our tests might be testing non-production code and business logic, making them meaningless. This breaks the FP principle: "Make impossible states impossible."

One way to solve this problem is to make the monad in our `AppM` definition generic, so that any monad type can be used there.

Please, now look at `src/MTL/Same-Monad.purs` to see how we do this. Once that's covered, look at the next file: `test/Random-Number/MTL-Same-Monad.purs`
