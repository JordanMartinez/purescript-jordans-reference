# Free

The fact that "`bind` forces us to return the same monad type" created a problem for us when we wanted to run a sequential computation using multiple effects (e.g. `MonadState` and `MonadReader` in the same computation). In the `mtl` approach, we got around that problem (i.e. were able to use "extensible effects") by nesting monads inside one another. However, what if we didn't fight against `bind` and simply used just one monad? That's one of the ideas behind "`Free` monad" approach.

This approach separates the "description" of a computation from its "execution"/"interpretation". Essentially, rather than building a large function that is composed of smaller functions (i.e. `mtl`) that runs once the initial arguments are given to it, the `Free` approach will create a large deeply-nested data structure that consists of computation descriptions, which are later "interpreted" via a `NaturalTransformation` into a single monad (i.e. `Effect`) that runs those computations. In other words, something akin to `executeProgram :: Free DomainSpecificLanguage output -> Effect output`.

What are the advantages that `Free` provides? Due to the different "interpreters" that one can write, it's very easy to:
- run the program via an `Effect`-based interpreter
- pretty-print something
- test that a computation produces Y outputs given X inputs

What are the disadvantages?
- It seems to be slower (though I am not sure how much slower) than the `mtl` approach

This folder will explain how the `Free` monad approach enables one to write programs that are structured according to the "onion architecture" idea. This idea can also be done using `mtl`, but we won't explain it until after covering the `Free` monad.
