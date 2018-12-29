# Projects

This folder's purposes are
- to solidify one's understanding for how to write FP programs according to modern FP architecture principles.
    - Explain the throught-process behind designing some program by starting with the properties one wants to employ. This will include diagrams and other explanations.
    - Compare the various ways one can structure an FP program and analyze their pros/cons and other tradeoffs. The following approaches are explained more in this file:
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
| Layer 2 | API | the "production" or "test" monad which "links" these effects/capabilties to their implementations: <ul><li>a newtyped `ReaderT` and its instances</li><li>the `Free`/`Run` monad's language and its interpretation</li></ul>
| Layer 1 | Infrastructure | the platform-specific framework/libraries we'll use to implement some special effects/capabilities (i.e. `Node.ReadLine`/`Halogen`/`StateT`)
| Layer 0 | Machine Code<br>(no equivalent onion term) | the "base" monad that runs the program (e.g. production: `Effect`/`Aff`; test: `Identity`)

## Explaining "Standard" vs "Layered Compilers" Terms

By "standard," I mean the code will follow the ideas expressed in the table above. This is the code one would expect to see in production-level programs.

By "layered compilers," I mean defining a monad with a higher-level language (e.g. Domain) that gets interpreted  (`Free`/`Run`) or lifted (`ReaderT`) into the same monad with a lower-level language (e.g. API). This is purely an experimental idea that shows what one _can_ do, but not necessarily "best practices" per say.
It might help one write a program when the specifications are still not well-understood. Or it might just be pointless boilerplate-y work.

Since "layered compilers" is rather long, I'll just use "layered" in folders' and modules' names.

## Libraries Overviewed

Below is the current list of libraries we introduce and further explain here. This list may grow over time.
- `Node.ReadLine` for console-based programs
- `Halogen` for web-based programs
- `Aff` for using asynchronous effects

## Projects

- (Easy) "Guess the Random Number" game.

## Compilation Instructions

### Setting Up This Folder

Since this folder includes benchmarking, we'll be using `Benchotron`, which is still not yet included in the default package set. Thus, you'll need to follow these instructions to set up this folder's `psc-package.json` file correctly:

1. Delete this folder's `.psc-package` folder (Step 4 won't work if you have already set up a package set in this folder)

2. Install [`Benchmark.js`](https://benchmarkjs.com/) locally via the command below:
```bash
# Note: This must be installed locally for the code to work.
# If you install it globally, Node won't be able to find `benchmark`.
npm install benchmark
```

3. Use `spacchetti` to create your own local custom package set by following these instructions:
```bash
# I've already ran `spacchetti local-setup`
# and configured the 'packages.dhall' file.
# See this folder as an example of what you would need to do
# if you had to do it on your own.

# So, we just need to install the local custom package set
spacchetti insdhall
```

4. Install that package set using psc-package:
```bash
psc-package install
```


### Building/Running Each Approach

Each folder will specify the `pulp` command to run to build/run the program. Because of the multi-project nature of this folder, the `pulp` command must be executed in `Hello World/Projects/`, not in each project's folder.
To run a web-based program, follow the folder's build instructions and then open the `dist/<project-name>/<FP structure approach>/index.html` file
