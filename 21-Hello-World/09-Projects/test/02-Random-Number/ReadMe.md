# Random Number Test

Now that we've written our program using the onion architecture, it's time we test it.

The following folder will show
- the thought process for thinking through which kind of testing we'll do (I believe my approach here is a version of state-machine-based testing.)
- Examples of tests for the following approaches
    - Run
    - MTL
        - where the test monad is **different from** production monad, and the environment argument is **the same**
        - where the test monad is **the same as the** production monad, but the environment argument is **different**
