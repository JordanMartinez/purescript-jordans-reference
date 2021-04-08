# Debug Trace

Previously, we got around the "`bind` outputs the same box-like type it receives" restriction by using `MonadEffect`. However, we also explained that `ST`, the monad used to run a computation that uses local mutable state, did not have an instance for `MonadEffect`. This decision is intentional.

When we run production code, we want to uphold this restriction. However, when we are debugging code, this restriction can be very annoying. Fortunately, the [Debug](https://pursuit.purescript.org/packages/purescript-debug/docs/Debug) package exists to help you use print debugging in any monadic context. You should use it when initially prototyping things. It should never appear in production code, nor as a solution for production-level logging. (We'll show how to do that in the `Application Structure` folder).

**WARNING**: `Debug`'s functions are not always reliable when running concurrent code (i.e. `Aff`-based computations).

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
spago run -m Debugging.Debug
spago run -m Debugging.LocalState
```
