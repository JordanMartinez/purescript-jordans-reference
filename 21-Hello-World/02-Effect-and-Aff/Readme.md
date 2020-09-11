# Effect and Aff

This folder accomplishes the following goals:
- An explanation of what "native side-effects" are and how this is modeled via `Effect`.
- A demonstration of how to write the infamous "Hello World" app in Purescript
- A demonstration of the various `Effect` types out there and their usage.
- An overview of `Aff` and how to use some of its API.
- An explanation and example of using the first workaround to the "`bind` outputs the same box-like type it receives" restriction.
- A how-to guide for dealing with "callback hell" via `Aff` and using `Node.ReadLine` as an example.

These examples are compilable, enabling the reader to do two things.

## REPL

First, one can interact with the code in this folder by using the REPL via the command, `spago repl`. Once initialized, one can import a module into the REPL and play with the code from there (e.g. run `main`).

For example, one might input the following command sequence:
```bash
spago repl
import HelloWorld
main
```

**Note: some of the code in this folder will not work properly when used with the REPL. When it doesn't, use the second approach below.**

## Compilation

Second, one can compile the examples into their resulting JavaScript files. One can view just the module (i.e. the JavaScript code generated from a single PS file) or the entire program as an executable file (i.e. the JavaScript code generated from a call to file's `main` function). The latter can be run using `Node`:

| | Single Module | Entire Program |
| - | - | - |
| Command | `spago make-module --main [moduleName] --to dist/module.js` | `spago bundle-app --main [moduleName] --to dist/app.js`
| Javascript files' location | `dist/module.js` | `dist/app.js` |

### Effect Folder

To run each program in the `Effect` folder, use these commands:
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

### Aff Folder

To run each program in the `Aff` folder, use these commands:
```bash
spago run -m AffBasics.LaunchAff
spago run -m AffBasics.Delay
spago run -m AffBasics.ForkJoin
spago run -m AffBasics.SuspendJoin
spago run -m AffBasics.CachedJoin
spago run -m AffBasics.SwitchingContexts
spago run -m TimeoutAndInterval.Aff
```

The following examples must be compiled first and then run by `node`:

```haskell
spago bundle-app -m ConsoleLessons.ReadLine.Effect -t dist/readline-effect.js && node dist/readline-effect.js

spago bundle-app -m ConsoleLessons.ReadLine.Aff -t dist/readline-aff.js && node dist/readline-aff.js
```
