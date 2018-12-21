# Projects

This folder's purposes are
- to solidify one's understanding for how to write FP programs according to modern FP architecture principles.
    - Explain the throught-process behind designing some program by starting with the properties one wants to employ. This will include diagrams and other explanations.
    - Compare the various ways one can structure an FP program and analyze their pros/cons and other tradeoffs
        - "standard" ReaderT approach
        - "standard" Free/Run approach
        - "layered compilers" Free/Run approach
        - "layered compilers" ReaderT approach (my experiment)
    - Explain and show how to test and benchmark our code
- to introduce the reader to a few commonly-used libraries in the "real world."
    - We'll introduce/overview the libraries we'll use in later projects before using them in those projects.
- to help the reader determine which approach with which they feel most comfortable (there is no "the one and only way" to doing this)

Note: each 'project' folder in the `src` folder has a corresponding folder in `test` folder. When reading through a project's files, read through its `src` folder's content before its `test` folder's content.

## Clarifying Our Terminology

When overviewing the design process of the program, we'll use the following terminology to refer to the various layers of our program:

| Layer Level | Onion Architecture Term | General idea |
| - | - | - |
| Layer 4 | Core | Strong types with well-defined properties and their pure, total functions that operate on them
| Layer 3 | Domain | the "business logic" code which uses effects
| Layer 2 | API | the "production" or "test" monad which "links" these effects/capabilties to their implementations: <ul><li>a newtyped `ReaderT`'s instances</li><li>the `Free`/`Run` monad's final interpreter</li></ul>
| Layer 1 | Infrastructure | the platform-specific framework/monad we'll use to implement an effect/capability (i.e. `Node.ReadLine`/`Halogen`/`StateT`)
| Layer 0 | Machine Code<br>(no equivalent onion term) | the "base" monad that runs the program (e.g. production: `Effect`/`Aff`; test: `Identity`)

## Libraries Overviewed

Below is the current list of libraries we introduce and further explain here. This list may grow over time.
- `Node.ReadLine` for console-based programs
- `Halogen` for web-based programs
- `Aff` for using asynchronous effects

## Projects

- (Easy) "Guess the Random Number" game.

## Compilation Instructions

Each folder will specify the `pulp` command to run to build/run the program. Because of the multi-project nature of this folder, the `pulp` command must be executed in `Hello World/Projects/`, not in each project's folder.
To run a web-based program, follow the folder's build instructions and then open the `dist/<project-name>/<FP structure approach>/index.html` file
