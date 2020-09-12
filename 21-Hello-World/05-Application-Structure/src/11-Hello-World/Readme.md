# Random Number

This folder will show how to build a the infamous "hello world" program using the various approaches (i.e. `ReaderT`, `Free`, and `Run`) to structuring one's application in such a way that the pure domain logic is separated from the impure effects needed to make it work.

This is as simple as can be: the program prints "hello world" to the console and then terminates.

## Compilation Instructions

Run the following while in the `Hello World/Application Structure/` folder.

```bash
spago run -m Examples.HelloWorld.ReaderT
spago run -m Examples.HelloWorld.Free
spago run -m Examples.HelloWorld.Run
```
