# Free

## Overview

This folder will do 4 things:
- explain what the Free monad is
- explain how it can be used to create a pure abstract syntax tree (AST) and interpret that AST into an impure but useful computation
- explain why one should use `Run` instead of `Free`
- explain the limitations of `Free`/`Run`.

`Free` monads are another way to structure the architecture of your program. However, I wouldn't recommend using this particular way of structuring your program. See this folder's "Drawbacks of Free" for some examples.

Moreover, the gist of `Free` monads is clearly explained by Nate Faubion in his overview of `Free` and `CoFree`: [Unrolling Free & Cofree (stop at 1:19:23)](https://www.youtube.com/watch?v=eKkxmVFcd74&t=18) (Actual YouTube video name is "PS Unscripted - Free from Tree & Halogen VDOM"). If you watch that video, you do not need to read through the "Why Use the Free Monad" folder's content.

The `Free` approach deals with the "`bind` forces us to return the same monad type it receives" restriction by using only one monad. Rather than building a large function that is composed of smaller functions that runs once the initial arguments are given to it (i.e. `MTL`), the `Free` approach will create an Abstract Sytax Tree (AST) that describes the desired computation in a pure way. This tree is later "interpreted" via a `NaturalTransformation` into a base monad (i.e. `Effect`) that runs those computations in an inpure way. In other words, something akin to
```haskell
type DSL = DomainSpecificLanguage
type AbstractSyntaxTree output = Free DSL output

defineProgram :: AbstractSyntaxTree
defineProgram = -- implementation

runProgram :: AbstractSyntaxTree ~> Effect
runProgram = -- implementation
```
