# Identifying the Pattern

It's time to reveal the real names of the types we've defined:

| Our Name | Real Name |
| - | - |
| `class (Monad m) <= StateLike s m` | `class (Monad m) <= MonadState s m` |
| `stateLike` | `state`
| `StateFunctionT s m a` | `StateT s m a`
| `StateFunction s a` | `State s a`
| `runStateFunctionT` | `runStateT`
| `runStateFunction` | `runState`

The same approach we took above (implementing a type class with one type that makes it work for all other monad types) is exactly what we'll do for the rest of our monad transformer type classes.

This summarizes the general pattern (there are exceptions!) that we will see reappear when overviewing the other Monad Transformers:
- There is a type class called `Monad[Word]` where `[Word]` clarifies what functions the type class provides
- There is a single implementation for `Monad[Word]` called `[Word]T`. When the monad type is specialized to `Identity`, it's simply called `[Word]`.
- To run a computation using `Monad[Word]`, we must use either `run[Word]` (i.e. the monad is `Identity`) or `run[Word]T` (i.e. the monad is another transformer in the "stack" of monad transformers)

Putting it into a table, we get this:

| Type Class | Sole Implementation<br>(`m` is undefined)<br><br>function that runs it | Sole Implementation<br>(`m` is `Identity`)<br><br>function that runs it |
| - | - | - | - |
| `Monad[Word]`<br>(General Pattern) | `[Word]T`<br><br>`run[Word]` | `[Word]`<br><br>`run[Word]` |
| `MonadState` |  `StateT`<br><br>`runState` | `State`<br><br>`runState` |
| `MonadReader` | `ReaderT`<br><br>`runReader` | `Reader`<br><br>`runReader` |
| `MonadWriter` | `WriterT`<br><br>`runWriter` | `Writer`<br><br>`runWriter` |
| `MonadCont` | `ContT`<br><br>`runCont` | `Cont`<br><br>`runCont` |
| `MonadError`<br><br>(Exception!) | `ExceptT`<br><br>`runExcept` | `Except`<br><br>`runExcept` |
