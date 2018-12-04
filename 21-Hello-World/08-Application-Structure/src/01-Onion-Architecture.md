# Onion Architecture

Due to its strong types, a clear distinction between partial and total functions, and its distinction between functions that perform side-effects and those that do not, FP programs naturally tend to look similar to the Onion Architecture in contrast to the Traditional Layered Architecture.

For a clearer idea of what "onion architecture" is, see these videos:
- [A Quick Introduction to Onion Architecture](https://www.youtube.com/embed/R2pW09tMCnE?start=6&end=527)
- [Domain-Driven Design through Onion Architecture](https://www.youtube.com/watch?v=pL9XeNjy_z4)

We can translate the above terminology to:

| Onion Architecture Term | FP Idea |
| - | - |
| `Core` | well-defined types with clear properties |
| `Domain` | pure total functions |
| `API` | smart constructors / error handling |
| `Infrastructure` | Impure functions / side-effects<br>(e.g. `Effect`/`Aff`)

To understand this more clearly,
- watch [Functional Architecture - The Pits of Success](https://www.youtube.com/watch?v=US8QG9I1XW0)
- get a general idea of [Three Layer Haskell Cake](https://www.parsonsmatt.org/2018/03/22/three_layer_haskell_cake.html), where `Infrastructure` is Level 1, `API` is Level 2, and `Domain` is Level 3
- Also worth watching: [Boundaries](https://www.destroyallsoftware.com/talks/boundaries)

The rest of this folder will show how to do the `Domain` part of this structure via `MTL` and `Free`.
