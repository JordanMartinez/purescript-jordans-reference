# Random Number Test

Now that we've written our program in various approaches, it's time we test them.

The following folder will show
- the thought process for thinking through which kind of testing we'll do (I believe my approach here is a version of state-machine-based testing.)
- Examples for most of our approaches.

Note: one should read the `ReaderT` "different monad" and "same monad" in the following way:

| File Name | Idea |
| - | - |
| DifferentMonad | test monad is **different from** production monad, and the environment argument is **the same** |
| SameMonad | test monad is **the same as the** production monad, but the environment argument is **different** |


## Where's the `Free`-based Tests?

I did not include tests for the Free-based implementations for these reasons:

1. `Run` already provides code/functions for the state monad. Thus, implementing tests for it here is easy to do. `Free` does not do that, so I would have to figure out how to write that code and then do so and then explain it to you.
2. `Run` is more easily extensible than `Free` in terms of defining new effects. Since it's more refactor-resistant, I'd start with it rather than jumping to it later.
3. `Run` is just a compile-time wrapper over `Free`, so it's basically doing the same thing that `Free` does.
4. I'm assuming that the `VariantF` code does not slow down the performance of the code (as compared to `Coproduct`)
