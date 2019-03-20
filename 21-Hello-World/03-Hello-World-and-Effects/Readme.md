# Hello World and Effects

This folder accomplishes the following goals:
- An explanation of what "native side-effects" are and how this is turned into a type via `Effect`.
- A demonstration of how to write the infamous "Hello World" app in Purescript
- A demonstration of the various `Effect` types out there and their usage.

These examples are compilable, enabling the reader to do two things.

## REPL

First, one can interact with the code in the REPL via the command `pulp repl`. Once initialized, one can import a module into the REPL and play with the code from there (e.g. run `main`).

For example, one might input the following command sequence:
```bash
pulp repl
import HelloWorld
main
```

## Compilation

Second, one can compile the examples and view their resulting Javascript files, a file for a module or a file that bundles everything into an executable:

| | Module | Executable File |
| - | - | - |
| Command | `spago make-module --main [moduleName] --to dist/module.js` | `spago bundle --main [moduleName] --to dist/app.js`
| Javascript files' location | `dist/module.js` | `dist/app.js` |

To run each program in this directory, use these commands:
```bash
spago run --main HelloWorld
spago run --main HelloNumber
spago run --main HelloDoNotation
spago run --main RandomNumber
spago run --main CurrentDateAndTime
spago run --main TimeoutAndInterval
spago run --main MutableState.Global
spago run --main MutableState.Local
```

Now go to the `src/` directory and read through the code files in numerical order.
