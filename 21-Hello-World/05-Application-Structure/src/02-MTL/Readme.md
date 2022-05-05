# MTL

This folder does 5 things:
- walks the reader through the `Function` monad and how to read its `do notation` and how functions can become monad transformers. At the end, we'll describe the whole point of using monad transformers.
- walks the reader through the problems that led us to define the `MonadState` type class and explains why its function's type signature is defined that way. We'll use this idea to teach the general idea behind all the other monad transformers
- overviews each monad transformer
- explains what problem `MonadTrans` solves and how the 'monad transformer stack' works
    - See [Using Monad Transformers without Understanding Them](https://hasgeek.com/FP-Juspay/pureconf/schedule/using-monad-transformers-without-understanding-them-JAFRaaAiVQBaBfVX3Yuruv) and its corresponding repo: https://github.com/JordanMartinez/pure-conf-talk
- explains the limitations of monad transformers
- overviews the `ReaderT design pattern`. At the end, we'll clarify when to use "monad stacks" and when to use the `ReaderT design pattern`.

## Explaining the Name

**Monad Transformers** are thus named because they "transform" some other monad by augmenting it with additional capabilities. One monad (e.g. `Box`) can only use `bind` and `pure` to do sequential computation. However, we can "transform" `Box`, so that it now has state-manipulating functions like `get`/`set`/`modify`. Purescript has defined all of these in the library called `purescript-transformers`.
