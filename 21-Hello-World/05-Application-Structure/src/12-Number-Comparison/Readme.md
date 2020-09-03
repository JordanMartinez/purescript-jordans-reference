# Random Number

This folder will show how to build a very simple program using the various approaches (i.e. `ReaderT`, `Free`, and `Run`) to structure one's application in such a way that the pure domain logic is separated from the impure effects needed to make it work.

To keep things simple, this program will only use the `Effect` monad and basic effects, such as logging to the screen some output and generating a random number. It will not use the slightly more complicated monad, `Aff`, or other libraries that provide specifc effects like getting the users' input via `Node.ReadLine` and/or running the application as a web app via `Halogen`.

As said before, by structuring programs in this style, it makes them easier to test and benchmark the domain logic because these are pure functions, not impure ones. However, tests and benchmarks for this program will not be done.

The upcoming projects will build on this pattern and include tests/benchmarks there.

## Compilation Instructions

Run the following while in the `Hello World/Application Structure/` folder.

```bash
spago run -m Examples.NumberComparison.ReaderT
spago run -m Examples.NumberComparison.Free
spago run -m Examples.NumberComparison.Run
```
