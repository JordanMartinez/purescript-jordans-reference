# Projects

This folder's purposes are
- to solidify one's understanding for how to write FP programs according to modern FP architecture principles.
    - Explain the throught-process behind designing some program by starting with the properties one wants to employ. This will include diagrams and other explanations.
    - Compare the various ways one can structure an FP program and analyze their pros/cons and other tradeoffs. The following approaches are covered here:
        - ReaderT approach (all folders)
        - Run approach (all folders)
        - other approaches (only in the `Random Number Game` folder).
    - Explain and show how to test and benchmark our code
- to introduce the reader to a few commonly-used libraries in the "real world."
    - We'll introduce/overview the libraries we'll use in later projects before using them in those projects.
- to help the reader determine which approach with which they feel most comfortable (there is no "the one and only way" to doing this)

Note: each 'project' folder in the `src` folder has a corresponding folder in the `test` and `benchmark` folders. When reading through a project's files, read through its `src` folder's content before its `test` folder's content, followed by its `benchmark` folder's content.

## Other "Example Projects"

- [hdgarrood's 'MultiPac' project](https://github.com/hdgarrood/multipac)
- [thomashoneyman's 'Real World App' project](https://github.com/thomashoneyman/purescript-halogen-realworld)
- [jaspervdj's 'Beeraffe' game](https://github.com/jaspervdj/beeraffe/)
- [AndrewBrownK's 'Minesweeper CLI' game](https://github.com/AndrewBrownK/purescript-minesweeper-cli)

### Projects in non-JS backends

- [Lambda Lantern](https://lettier.itch.io/lambda-lantern)

## Clarifying Our Terminology

When overviewing the design process of the program, we'll use the following terminology to refer to the various layers of our program:

| Layer Level | Onion Architecture Term | General idea |
| - | - | - |
| Layer 4 | Core | Strong types with well-defined properties and their pure, total functions that operate on them
| Layer 3 | Domain | the "business logic" code which uses effects
| Layer 2 | API | the "production" or "test" monad which "links" these effects/capabilties to their implementations: <ul><li>a newtyped `ReaderT` and its instances</li><li>the `Free`/`Run` monad's language and its interpretation</li></ul>
| Layer 1 | Infrastructure | the platform-specific framework/libraries we'll use to implement some special effects/capabilities (i.e. `Node.ReadLine`/`Halogen`/`StateT`)
| Layer 0 | Main<br>(no equivalent onion term) | the program's entry point<br>the "base" monad that runs the program (e.g. production: `Effect`/`Aff`; test: `Identity`)

## Libraries Overviewed

Below is the current list of libraries we introduce and further explain here. This list may grow over time.
- `Node.ReadLine` for console-based programs (`purescript-node-readline`)
- `Halogen` for web-based programs (`purescript-halogen`)
- `Aff` for using asynchronous effects (`purescript-aff`)
- `Yargs` for command-line parsing (`purescript-yargs`)
- `Node.FS` for reading/writing files (`purescript-node-fs-aff`)
- `StringParers` for parsing files' contents (`purescript-string-parsers`)
- `Tree` for producing trees (`purescript-tree`)

## Projects

- (Easy) "Guess the Random Number" game.
- (Easy-ish) "Table of Contents Generator" program for this specific repository.

## License

All source code in these projects is licensed under the MIT license.
```
Copyright 2019 Jordan Martinez and Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

## Compilation Instructions

### Setting Up This Folder

Since this folder includes bindings to JS libraries, we need to install them via NPM before their purescript bindings will work. Follow these instructions:

1. Install the NPM dependencies locally

```bash
# Benchmark.js - https://benchmarkjs.com/
npm install benchmark
```

2. Build the folder's contents using `spago`, which will also install the PS libraries
```bash
spago build
```

### Building/Running Each Approach

Each folder will specify the `spago` command to run to build/run the program. Because of the multi-project nature of this folder, the `spago` command must be executed in `Hello World/Projects/`, not in each project's folder.
To run a web-based program, follow the folder's build instructions and then open the `dist/<project-name>/<FP structure approach>/index.html` file
