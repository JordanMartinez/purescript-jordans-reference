# Application Structure

Prerequisites:
- You should be familiar with type-level programming
- You should understand what "smart constructors" (see `Design Patterns` folder) are and how they work

The upcoming folders will explain
- a small explanation on the onion architecture
- an overview of what MTL and Free/Run are and how they work conceptually
- how to structure an FP program via MTL and Free/Run, so that it looks like the onion architecture

These will later be used to write games/programs that run in Node via the console and in the Browser via Halogen

In the functional paradigm, programs tend to have an architecture that looks very similar to one called the "onion architecture."
For a clearer idea of what "onion architecture" is, see these videos:
- [A Quick Introduction to Onion Architecture](https://www.youtube.com/embed/R2pW09tMCnE?start=6&end=527)
- [Domain-Driven Design through Onion Architecture](https://www.youtube.com/watch?v=pL9XeNjy_z4)

To get a general idea for the concept this folder is going to try to teach:
- Watch [Functional Architecture - The Pits of Success](https://www.youtube.com/watch?v=US8QG9I1XW0)
- Optional but also worth watching: [Boundaries](https://www.destroyallsoftware.com/talks/boundaries)

### A Word of Thanks

While trying to learn this myself, I benefited from looking at the code in stepchownfun's BSD-3 licensed project, [`effects`](https://github.com/stepchowfun/effects), as a guide when I did not completely understand something myself.
