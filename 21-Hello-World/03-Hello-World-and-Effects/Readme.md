# Hello World and Effects

This folder accomplishes the following goals:
- An explanation of what "native side-effects" are and how this is turned into a type via `Effect`.
- A demonstration of how to write the infamous "Hello World" app in Purescript
- A demonstration of the various `Effect` types out there and their usage.

These examples are compilable, enabling the reader to do two things.

### REPL

First, one can interact with the code in the REPL via the command `pulp repl`. Once initialized, one can import a module into the REPL and play with the code from there (e.g. run `main`).

For example, one might input the following command sequence:
```bash
pulp repl
import HelloWorld
main
```

### Compilation

Second, one can compile the examples and view their resulting Javascript files, the unoptimized and optimized version:

| | Unoptimized | Optimized |
| - | - | - |
| Command | `pulp --psc-package build --main [moduleName]` | `pulp --psc-package build --main [moduleName] --to dist/[fileName].js`
| Javascript files' location | `output/[moduleName]/index.js` | `dist/[fileName].js` |
| Examples | `pulp --psc-package build --main HelloWorld`<hr>`output/HelloWorld/index.js` | `pulp --psc-package build --main HelloWorld --to dist/HelloWorld.js`<hr>`dist/HelloWorld.js`

Now go to the `src/` directory and read through the code files in numerical order.
