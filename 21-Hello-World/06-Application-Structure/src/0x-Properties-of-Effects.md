# Properties of "Effects"

Read through the first section of [Monad transformers, free monads, mtl, laws and a new approach](https://ocharles.org.uk/posts/2016-01-26-transformers-free-monads-mtl-laws.html).

We will explain and illustrate what is meant by each property

## Extensible

While the above effects (e.g. `MonadState`) are pretty obvious, we might one day wish to define a new effect for handling authentication, `MonadAuthenticate`. If a function that uses state-manipulation effects via `MonadState` now needs to add the "authenticate" effect, it should be easy to add that and not require us to refactor a whole lot of code.

In other words, going from this function ...
```purescript
f :: forall m.
     MonadState m =>
     InitialState -> m OutputtedState
```
... to this function...
```purescript
f' :: forall m.
      MonadState m =>
      MonadAuthenticate m =>
      InitialState ->
      m OutputtedState
```
... should be easy/quick.

## Composable

Composable means using two or more effects in the same function should be lawful.

For example
- `set`ting some state to `5` and later `get`ting that state should return `5`, not `8`, no matter what other effects or computations we run in-between those two calls (e.g. printing some value to the console).
- `catch`ing an error cannot occur unless an error was `throw`n prior to it.
- `ask`ing for a configuration value should return the same value each time no matter what happens before/after that call.

## Efficient

This can be understood a few different ways:
- During runtime: the program runs fast (time-efficient) or uses as little memory as possible (space-efficient)
- During compile-time: the compiler runs fast (time-efficient) or uses as little memory as possible (space-efficient)

I believe the author is referring to the first idea (runtime).

## Terse

We shouldn't have to write boilerplate-y code

For example, we shouldn't have to write
- many lines of code to do one thing
- many types to do one thing

## Inferable

Related to `Terse`, we shouldn't have to annotate code (e.g. wrapping `value` with its type annotation: `(value :: { name :: String, age :: Int })` )
