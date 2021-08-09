# Application Structure

Prerequisites:
- You should understand what "smart constructors" are (see `Design Patterns` folder) and how they work

The upcoming folders will explain
- a small explanation on the onion architecture / 3-Layer Haskell Cake concepts
- an overview of what MTL and Free/Run are and how they work conceptually
- how to structure an FP program via MTL and Free/Run
- **folders starting with `1` contain heavily-commented examples of basic programs using these application architecture styles.** When learning one particular style, you should look at these programs for what an 'end-result' looks like using that style as well as how it compares to other styles. We'll start with the simplest "hello world" program that uses only one effect and write programs that use more and more effects/capabilities.

These will later be used to write programs in the `Projects` folder that run in Node via the console and/or in the Browser via Halogen.

In the functional paradigm, programs are structured in such a way that they look very similar to something called the "onion architecture." **The below videos are optional watching.** Watch them for a clearer idea of what "onion architecture" is:
- [A Quick Introduction to Onion Architecture](https://www.youtube.com/embed/R2pW09tMCnE?start=6&end=527)
- [Domain-Driven Design through Onion Architecture](https://www.youtube.com/watch?v=pL9XeNjy_z4)

Another optional video to watch: [Functional Architecture - The Pits of Success](https://www.youtube.com/watch?v=US8QG9I1XW0). It explains that FP naturally pushes developers towards this architecture whereas other languages push developers away from it.

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
| Layer 0 | Machine Code<br>(no equivalent onion term) | the "base" monad that runs the program (e.g. production: `Effect`/`Aff`; test: `Identity`/`Trampoline`)

To get a general idea for the concept this folder is going to try to teach:
- Watch the second half of [Code Reuse in PureScript: Functions, Type Classes, and Interpreters](https://youtu.be/GlUcCPmH8wI?t=1977) and focus on the following section:
    - 'Which code is more reusable' (45:28 - 50:29):
        - Final Encoding = Provide an implementation as an argument = monad transformers (what we cover first in this folder)
        - Initial Encoding = Interpret a result = `Free` monad (what we cover second in this folder)
- Optional reading: [Final tagless encodings have little to do with typeclasses](https://www.foxhound.systems/blog/final-tagless/)

Another learning resource that is still a work-in-progress but which will explain more than this work is 'Functional Design and Architecture':
- [Reddit post introducing it](https://np.reddit.com/r/haskell/comments/avaxda/the_campaign_for_my_book_functional_design_and/?st=jsowhkm4&sh=d2be89c4)
- [Its current Table of Contents](https://docs.google.com/document/d/1bh9Sa0rIGzU9Z88N_TJF6BtgHD_QLYdh1nK-yLKn_IU/edit)

## A Word of Thanks

While trying to learn this myself, I benefited from looking at the code in stepchownfun's BSD-3 licensed project, [`effects`](https://github.com/stepchowfun/effects), as a guide when I did not completely understand something myself.
