# Free

The fact that "`bind` forces us to return the same monad type" created a problem for us when we wanted to run a sequential computation using multiple effects (e.g. `MonadState` and `MonadReader` in the same computation). In the `mtl` approach, we got around that problem (i.e. were able to use "composable effects") by nesting monads inside one another. However, what if we didn't fight against `bind` and simply used just one monad? That's one of the ideas behind "`Free` monad" approach.

This approach separates the "description" of a computation from its "execution"/"interpretation". Essentially, rather than building a large function that is composed of smaller functions (i.e. `mtl`) that runs once the initial arguments are given to it, the `Free` approach will create a large deeply-nested data structure that consists of computation descriptions, which are later "interpreted" via a `NaturalTransformation` into a single monad (i.e. `Effect`) that runs those computations. In other words, something akin to `executeProgram :: Free DomainSpecificLanguage output -> Effect output`.

What are the advantages that `Free` provides? Due to the different "interpreters" that one can write, it's very easy to:
- run the program via an `Effect`-based interpreter
- pretty-print something
- test that a computation produces Y outputs given X inputs

What are the disadvantages?
- In Haskell, `Free` is slower (though I am not sure how much slower) than the `mtl` approach because it can heavily optimize the code in the compilation process. That is not the case with Purescript, whose compiler could still be optimized in a number of ways. I'm not sure whether one is faster than another and what are the other pros/cons one would need to think about when doing that.

This folder will teach readers with no prior understanding the fundamental concepts of the `Free` monad and a basic understanding of how to use it.
