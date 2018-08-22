## The Effect Monad

(The following section is copied from [here](https://github.com/purescript/documentation/blob/master/guides/Eff.md) and slightly edited. I would add the license for that here, but it's not listed. Since the documentation is supposed to be public anyways, I doubt this is an issue.)

When we talk about side-effects, we are referring to two possible meanings. The first are "non-native" side-effects that use techniques like monoids, monads, applicatives, and arrows. The second are "native side-effects", which are effects provided by the RunTime System (RTS) and which can't be emulated by pure functions.

Some examples of native effects are:
- Shared
    - Random number generation
    - Exceptions
    - Reading/writing mutable state
    - Writing/reading to/from local storage
- Node only:
    - Console IO
- Browser only:
    - DOM manipulation
    - XMLHttpRequest / AJAX calls
    - Interacting with a websocket

PureScript's [`purescript-effect`](https://pursuit.purescript.org/packages/purescript-effect/) package defines a monad called `Effect`, which is used to handle native effects. The goal of the `Effect` monad is to provide a typed API for effectful computations, while at the same time generating efficient Javascript.

(The remainder of this article is my own work.)

None of the above examples can be pure code and yet they are necessary for any practical computations. As a reminder, the following table shows the difference between pure and impure code:

| | Pure | Pure Example | Impure | Impure Example
| - | - | - | - | - |
| Given an input, will it always return some output? | Always <br> (Total Functions) | `n + m` | Sometimes <br> (Partial Functions) | `4 / 0 == undefined`
| Given the same input, will it always return the same output? | Always <br> (Deterministic Functions) | `1 + 1` always equals `2` | Sometimes <br> (Non-Deterministic Functions) | `random.nextInt()`
| *Does it interact with the real world? | Never |  | Sometimes | `file.getText()` |
| *Does it acces or modify program state | Never | `newList = oldList.removeElemAt(0)`<br>Original list is copied but never modified | Sometimes | `x++`<br>variable `x` is incremented by one.
| *Does it throw exceptions? | Never | | Sometimes | `function (e) { throw Exception("error") }` |

## Understanding the Effect Monad

The following code is not necessarily how `Effect` is implemented, but it does help one quickly understand it by analogy:
```purescript
data Unit = Unit

unit :: Unit
unit = Unit

-- | A computation that will only be run when passed in a `unit`
type PendingComputation a = (Unit -> a)

-- | A data structure that stores a pending computation.
data Effect a = Box (PendingComputation a -> a)

-- | This unwraps the data structure to get the
-- | pending computation, uses it to compute a value,
-- | and returns its result.
unsafePerformEffect :: Effect a -> a
unsafePerformEffect (Box pendingComputation) = pendingComputation unit
```

The whole idea of `Effect` is to use `unsafePerformEffect` as little as possible and ideally never since it is an impure function. The only caveat to this is explained next.

## Main: A Program's Entry Point

The entry point into each program written in Purescript is the `main` function. It's type signature must be: `main :: Effect Unit`.

The following explanation is not what happens in practice, but understanding it this way will help one understand the concepts it represents:
> When one writes `pulp --psc-package build`, one could say that, conceptually, pulp will compile `unsafePerformEffect main` into Javascript and the resulting Javascript is what gets run by the RunTime System (RTS) when the program is executed.^^

In other words, the RunTime System is (ideally) the only entity that ever calls `unsafePerformEffect`. When it does, `main` is its argument.

One might still call `unsafePerformEffect` in otherwise pure code in situations where they know what they are doing. In other words, they know the pros & cons, costs & benefits of doing so, and are willing to pay for those costs to acheive their benefits.

^^ `pulp --psc-package build` or `pulp --psc-package browserify` both, by default, add in the necessary code to automatically execute `main`. To remove this, one needs to pass the flag `--skip-entry-point` to these commands.
