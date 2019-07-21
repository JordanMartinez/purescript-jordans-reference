## Summary of Effect Libraries

Since the `spago.dhall` file does not allow me to explain what each dependency does, I've offloaded that to the table below. These are not all of the Effects that exist. For example, I did not cover `Avar`, `Aff`, and others (see the full list on Pursuit [here](https://pursuit.purescript.org/search?q=Effect). Not all of the `Effects` found on there are truly `Effect`s as they might be newtypes for something else). Rather, they give you something to use as you learn more and more of Purescript and FP concepts:

| Library | Included Module | Usage
| - | - | - |
| [purescript-effect](https://pursuit.purescript.org/packages/purescript-effect/2.0.0) | `Effect` | Provides the `Effect` type itself.
| [purescript-console](https://pursuit.purescript.org/packages/purescript-console/4.1.0) | `Effect.Console` | Provides bindings to the Console
| [purescript-random](https://pursuit.purescript.org/packages/purescript-random/4.0.0) | `Effect.Random` | Type used to create random values
| [purescript-now](https://pursuit.purescript.org/packages/purescript-now/4.0.0/docs/Effect.Now) | `Effect.Now` | Get current Date/Time from machine. (Note: see the [date-time](https://pursuit.purescript.org/packages/purescript-datetime/4.0.0) repo for additional related functions)
| [purescript-js-timers](https://pursuit.purescript.org/packages/purescript-js-timers/4.0.1) | `Effect.Timer` | Bindings to low-level JS API: `set/clearTimeout` and `set/clearInterval`
| [purscript-refs](https://pursuit.purescript.org/packages/purescript-refs/4.1.0/docs/Effect.Ref) | `Effect.Ref` | Global mutable state
| [purscript-st](https://pursuit.purescript.org/packages/purescript-st/4.0.0/docs/Control.Monad.ST) | `Control.Monad.ST` | Local mutable state
