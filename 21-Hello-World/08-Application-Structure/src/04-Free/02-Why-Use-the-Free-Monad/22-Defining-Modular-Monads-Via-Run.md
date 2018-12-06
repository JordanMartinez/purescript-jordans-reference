# Defining Modular Monads via Run

## MTL-Like Type Aliases

`purescript-run` has a few other type aliases that will look familiar.
```purescript
newtype Reader e a = Reader (e → a)
type READER e = FProxy (Reader e)

data State s a = State (s → s) (s → a)
type STATE s = FProxy (State s)

data Writer w a = Writer w a
type WRITER w = FProxy (Writer w)

newtype Except e a = Except e
type EXCEPT e = FProxy (Except e)
type FAIL = EXCEPT Unit
```
The takeaways here:
- We have type aliases for most of the monads we originally explained in the `MTL` folder. The `a` in each type is the output type, so it is excluded.
- The `a` type is likely defined elsewhere in a function that uses it
- `FAIL` indicates an error whose type we don't care about.

## Examining the MTL-Like Functions

If we look at some of the functions that each of the above MTL-like types provide, we'll notice another pattern. Each type (e.g. `Reader`) seems to define its own `Symbol` (e.g. `_reader :: SProxy "reader"`) for the corresponding type in `VariantF`'s row type (e.g. `READER`).

However, if one wanted to use a custom `Symbol` name for their usage of an MTL-like type (e.g. `Reader`), they can append `at` to the function and get the same thing. In other words:
```purescript
liftReader readerObj = liftReaderAt _reader readerObj

liftReaderAt symbol readerObj = -- implementation

ask = askAt _reader

askAt symbol = -- implementation
```

In short, one can use a `Run`-based monad to do two different state computations in the same function, unlike the unmodified `MTL` approach that doesn't use `Symbols`.

## Examples of MTL-Like Run-Based Code

- [A simple program using multiple effects](https://pursuit.purescript.org/packages/purescript-run/2.0.0/docs/Run#t:Run)
- A [short explanation from Free to Run](https://github.com/natefaubion/purescript-run#free-dsls) that also covers `Coproduct`/`VariantF` and whose code can be found in the project's test directory:
    - [Examples.purs](https://github.com/natefaubion/purescript-run/blob/master/test/Examples.purs)
    - [Main.purs](https://github.com/natefaubion/purescript-run/blob/master/test/Main.purs)
