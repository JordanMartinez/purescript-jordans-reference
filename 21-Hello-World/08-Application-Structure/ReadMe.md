# Application Structure

Prerequisites:
- You should be familiar with type-level programming
- You should understand what "smart constructors" (see `Design Patterns` folder) are and how they work

The upcoming folders will explain
- a small explanation on the onion architecture / 3-Layer Haskell Cake concepts
- an overview of what MTL and Free/Run are and how they work conceptually
- how to structure an FP program via MTL and Free/Run
- examples of basic programs using these application architecture styles. We'll start with the simplest "hello world" program that uses only one effect and write programs that use more and more effects/capabilities.

These will later be used to write games/programs that run in Node via the console and in the Browser via Halogen

In the functional paradigm, programs are structured in such a way that they look very similar to something called the "onion architecture." **The below videos are optional watching.** Watch them for a clearer idea of what "onion architecture" is:
- [A Quick Introduction to Onion Architecture](https://www.youtube.com/embed/R2pW09tMCnE?start=6&end=527)
- [Domain-Driven Design through Onion Architecture](https://www.youtube.com/watch?v=pL9XeNjy_z4)

When we structure our code according to the below table, it provides a number of benefits
- top-down domain-driven design: your data types and your function's type signatures are often your always-up-to-date documentation
- "impure" computations (i.e. computations that do things like state manipulation, reading from a file, network activities) are expressed as a "pure" computation, making them much easier to test
- "Platforms" (i.e. frameworks, databases, etc.) can easily be swapped out with other newer platforms without changing any "business logic" code or potentially introducing regressions

| Layer Level | Onion Architecture Term | General idea |
| - | - | - |
| Layer 4 | Core | Strong types with well-defined properties and their pure, total functions that operate on them
| Layer 3 | Domain | the "business logic" code which uses "effects," impure computations that are expressed in a pure way
| Layer 2 | API | the "production" or "test" monad which "links" these pure effects/capabilties to their impure implementations
| Layer 1 | Infrastructure | the platform-specific framework/libraries we'll use to implement some special effects/capabilities (i.e. `Node.ReadLine` (terminal-based programs), `Halogen`/`React` (web-based UIs))
| Layer 0 | Machine Code<br>(no equivalent onion term) | the "base" monad that runs the program (e.g. production: `Effect`/`Aff`; test: `Identity`)

To get a general idea for the concept this folder is going to try to teach:
- Watch [Functional Architecture - The Pits of Success](https://www.youtube.com/watch?v=US8QG9I1XW0)
- Optional but also worth watching: [Boundaries](https://www.destroyallsoftware.com/talks/boundaries)

### A Word of Thanks

While trying to learn this myself, I benefited from looking at the code in stepchownfun's BSD-3 licensed project, [`effects`](https://github.com/stepchowfun/effects), as a guide when I did not completely understand something myself.
