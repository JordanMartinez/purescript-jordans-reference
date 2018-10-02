# Run

This file has two folders:
- `v1` is a almost an exact copy of the `Free`-based example from before, just written in the `VariantF`/`Run` style. The only change is that the `API` level language does not include a `Log` term and the Domain `NotifyUser` term is directly translated into the Infrastructure-level effect that logs the message to the console.
- `v2` (WIP) extends the first version with additional algebras that can easily change our program by changing which algebra we use for a given term
