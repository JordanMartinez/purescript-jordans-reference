## The Effect Monad

(The following section is copied from [here](https://github.com/purescript/documentation/blob/master/guides/Eff.md) and slightly edited. I would add the license for that here, but it's not listed. Since the documentation is supposed to be public anyways, I doubt this is an issue.)

When we talk about side-effects, we are referring to two possible meanings. The first are "non-native" side-effects that we can emulate using pure functions (e.g. state manipulation on immutable data structures, returning additional output from a computation, etc.). The second are "native side-effects", which are effects provided by the RunTime System (RTS) and which can't be emulated by pure functions.

Some examples of native effects are:
- Shared
    - Random number generation
    - Exceptions
    - Rendering content to the screen
- Node only:
    - User input via the terminal
    - Interacting with the File System
- Browser only:
    - DOM manipulation
    - XMLHttpRequest / AJAX calls
    - Interacting with a websocket
    - Interacting with Cookies

PureScript's [`purescript-effect`](https://pursuit.purescript.org/packages/purescript-effect/) package defines a monad called `Effect`, which is used to handle native effects. The goal of the `Effect` monad is to provide a typed API for effectful computations, while at the same time generating efficient Javascript.

(The remainder of this article is my own work.)

## Understanding the Effect Monad

The following code is not necessarily how `Effect` is implemented, but it does help one quickly understand it by analogy:
```haskell
data Unit = Unit

unit :: Unit
unit = Unit

-- | A computation that will only be run when passed in a `unit`
type PendingComputation a = (Unit -> a)

-- | A data structure that stores a pending computation.
data Effect a = Box (PendingComputation a)

-- | This unwraps the data structure to get the
-- | pending computation, uses it to compute a value,
-- | and returns its result.
unsafePerformEffect :: Effect a -> a
unsafePerformEffect (Box pendingComputation) = pendingComputation unit
```

Some readers may realize that this is similar to the idea we introduced back in `ROOT_FOLDER/Hello-World/Prelude/Control-Flow--Functor-to-Monad.md` when we showed how an FP program does sequential computation using Monads. If you replace `Box` from that example with `Effect`, you would have a working FP program.

The whole idea of `Effect` is to use `unsafePerformEffect` as little as possible and ideally only once as the program's main entry point, explained next.

## Main: A Program's Entry Point

The entry point into each program written in Purescript is the `main` function. It's type signature must be: `main :: Effect Unit`.

The following explanation is not what happens in practice, but understanding it this way will help one understand the concepts it represents:
> When one executes the command `spago bundle-app`, one could say that, conceptually, spago will compile `unsafePerformEffect main` into Javascript and the resulting Javascript is what gets run by the RunTime System (RTS) when the program is executed.

In other words, spago "creates" a function called `runProgram` and tells the RunTime System (RTS) to execute it
```haskell
runProgram :: Unit
runProgram = unsafePerformEffect main
```

This limits our impure code as much as possible to the program's start. Hopefully, everything else in our code is pure.

However, one might still call `unsafePerformEffect` in otherwise pure code in situations where they know what they are doing. In other words, they know the pros & cons, costs & benefits of doing so, and are willing to pay for those costs to achieve their benefits.
