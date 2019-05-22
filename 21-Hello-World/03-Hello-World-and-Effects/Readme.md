# Hello World and Effects

This folder accomplishes the following goals:
- An explanation of what "native side-effects" are and how this is turned into a type via `Effect`.
- A demonstration of how to write the infamous "Hello World" app in Purescript
- A demonstration of the various `Effect` types out there and their usage.

These examples are compilable, enabling the reader to do two things.

## REPL

First, one can interact with the code in the REPL via the command `spago repl`. Once initialized, one can import a module into the REPL and play with the code from there (e.g. run `main`).

For example, one might input the following command sequence:
```bash
spago repl
import HelloWorld
main
```

## Compilation

Second, one can compile the examples and view their resulting Javascript files. One can view just the module (i.e. the JavaScript code generated from a single PS file) or the entire program as an executable file (i.e. the JavaScript code generated from a call to file's `main` function):

| | Single Module | Entire Program |
| - | - | - |
| Command | `spago make-module --main [moduleName] --to dist/module.js` | `spago bundle-app --main [moduleName] --to dist/app.js`
| Javascript files' location | `dist/module.js` | `dist/app.js` |

To run each program in this directory, use these commands:
```bash
# Syntax
# spago run --main Module.Path.To.Main.Module
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
