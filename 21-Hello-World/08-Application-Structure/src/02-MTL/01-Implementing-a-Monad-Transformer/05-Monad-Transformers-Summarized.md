# Monad Transformers Summarized

This helps us understand the name behind "Monad Transformers".

First, there is a type class that indicates that some underlying monad has the **capability** to do some effect (e.g. state manipulation via `MonadState`).

Second, there is a default implementation for that class via a monadic newtyped function (e.g. `StateT`). Such functions add in specific effects, reduce some of the boilerplate behind the scenes (i.e. turning `Tuple value state <- stateManipulatingFunction` into `value <- stateManipulatingFunction`), and make impossible states impossible (i.e. passing in the right `state` value behind the scenes). When we wish to transform some other monad, we use the newtyped monadic functions that end with `T` as in "transformer". However, if we want to transform the `Identity` monad, then we remove that `T`. (We'll talk more about the idea of capabilities when we show how MTL enables the onion architecture.)

Third, the general pattern (there are exceptions!) that we will see reappear when overviewing the other Monad Transformers:
- There is a type class called `Monad[Word]` where `[Word]` clarifies what functions the type class provides. This type class indicates that some underlying monad has the **capability** of that effect.
- There is a single implementation for `Monad[Word]` called `[Word]T`. When the monad type is specialized to `Identity`, it's simply called `[Word]`.
- To run a computation using `Monad[Word]`, we must use either `run[Word]` (i.e. the monad is `Identity`) or `run[Word]T` (i.e. a non-`Identity` monad).

Putting it into a table, we get this:

| Type Class | Sole Implementation<br>(`m` is undefined)<br><br>function that runs it | Sole Implementation<br>(`m` is `Identity`)<br><br>function that runs it |
| - | - | - |
| `Monad[Word]`<br>(General Pattern) | `[Word]T`<br><br>`run[Word]` | `[Word]`<br><br>`run[Word]` |
| `MonadState` |  `StateT`<br><br>`runState` | `State`<br><br>`runState` |
| `MonadReader` | `ReaderT`<br><br>`runReader` | `Reader`<br><br>`runReader` |
| `MonadWriter` | `WriterT`<br><br>`runWriter` | `Writer`<br><br>`runWriter` |
| `MonadCont` | `ContT`<br><br>`runCont` | `Cont`<br><br>`runCont` |
| `MonadError` | `ExceptT`<br><br>`runExceptT` | `Except`<br><br>`runExcept` |

Putting it differently, we get this:

| A basic concept... | ...as a monad transformer |
| - | - |
| `oldState -> monad (Tuple (output, newState))`<br>(state manipulation) | StateT
| `monad (Tuple (output, accumulatedValue)` | WriterT
| `globalValue -> monad outputThatUsesGlobalValue` | ReaderT
| `Either e a`<br>computation that handles partial functions | ExceptT
| `function $ arg` | ContT
| `Maybe a`<br>computation that might return a value or not | MaybeT
| `List a`<br>computation that returns a (possibly empty) list of values | ListT

The "base monad" that usually inhibits `m` at the end of the "stack" of nested monad transformers is usually one of two things:
- `Effect`/`Aff`: impure computations that actually make our business logic useful
- `Identity`/`Free`: pure computations that test our business logic.
