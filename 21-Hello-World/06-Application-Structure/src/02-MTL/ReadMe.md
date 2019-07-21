# MTL

This folder does 5 things:
- walks the reader through the problems that led us to define the `MonadState` in the way that it is and uses this idea to teach the general idea behind all the other monad transformers
- overviews each monad transformer
- explains what problem `MonadTrans` solves and how the 'monad transformer stack' works
- explains the limitations of monad transformers
- overviews the `ReaderT design pattern`

## Explaining the Name

As stated before, **Monad Transformers** are thus named because they "transform" some other monad by augmenting it with additional functions. One monad (e.g. `Box`) can only use `bind` and `pure` to do sequential computation. However, we can "transform" `Box`, so that it now has state-manipulating functions like `get`/`set`/`modify`. In Haskell, "**mtl**" is a library that provides default implementations for each monad transformer mentioned so that the order of the "monad stack" does not matter. In Purescript, the library is called `purescript-transformers`.

## Setting Your Expectations

**The upcoming code examples for each type class may seem pointless at first because the program doesn't do anything "useful." That's intentional for teaching purposes.** Each monad transformer needs to be studied separately to increase familiarity. Once we understand how they work individually, we can start to compose them together.
