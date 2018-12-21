# Free

I decided not to implement a test for the Free-based implementation for these reasons:
- `Run` is more easily extensible than `Free` in terms of defining new effects
- `Run` already includes operations for simulating a number of monad transformers (e.g. `MonadState`), so I don't have to write as much code to do the same thing.
- `Run` is just a wrapper over `Free`, so it's basically doing the same thing one would do when using `Free`.
