# Debug Trace

Previously, we got around the "monads don't compose" problem by using `MonadEffect`. However, we also explained that `ST`, the monad used to run a computation that uses local state, did not have an instance for `MonadEffect` and that this was intentional.

In this file, we'll present a package that can be easily abused by programmers new to FP. Please do not abuse it. This package exists to help you debug your code and/or prototype things. It's not meant for production-level logging. (We'll show how to do that in the `Application Structure` folder).

This package is called [Debug.Trace](https://pursuit.purescript.org/packages/purescript-debug/4.0.0/docs/Debug.Trace)

**WARNING**: `Debug.Trace`'s functions are not always reliable when running concurrent code (i.e. `Aff`-based computations).

## Compilation Instructions

### Seeing the Custom Type Errors

The warnings that will appear when compiling this code only appear once. Once you have built the code, `spago` will reuse the already-compiled JavaScript and thus won't retrigger these warnings. If you want to see them again, follow these instructions.
```bash
# Remove all previously compiled JavaScript
rm -rf output/

# Now build the code to see the warnings.
spago build
```

### Running the Examples

Use these commands
```bash
spago run -m Debugging.DebugTrace
spago run -m Debugging.LocalState
```
