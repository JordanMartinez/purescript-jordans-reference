# Overview of Run

## Core Type and Function

First, let's look at a few core types and functions (the following block of code is licensed under [the MIT license](https://github.com/natefaubion/purescript-run/blob/v2.0.0/LICENSE):
```purescript
newtype Run r a = Run (Free (VariantF r) a)

-- ignore the type signature and just look at the implementation
lift
  ∷ ∀ sym r1 r2 f a
  . Row.Cons sym (FProxy f) r1 r2
  ⇒ IsSymbol sym
  ⇒ Functor f

  ⇒ SProxy sym
  → f a
  → Run r2 a
lift symbol dataType = Run <<< liftF <<< inj symbol dataType

run
  ∷ ∀ m a r
  . Monad m
  ⇒ (VariantF r (Run r a) → m (Run r a))
  → Run r a
  → m a
run k = loop
  where
  loop ∷ Run r a → m a
  loop = resume (\a → loop =<< k a) pure

-- | Extracts the value from a program via some Monad `m`. This assumes
-- | stack safety under Monadic recursion.
interpret
  ∷ ∀ m a r
  . Monad m
  ⇒ (VariantF r ~> m)
  → Run r a
  → m a
interpret = run

-- | Extracts the value from a purely interpreted program.
extract ∷ ∀ a. Run () a → a
extract = unwrap >>> runFree \_ → unsafeCrashWith "Run: the impossible happened"
```
The takeaways here:
- `Run` is a newtype, so there is no runtime overhead
- `lift` is `Run`'s version of `Free`'s `liftF`
- There are at least three ways to run a `Free`-based program depending on what you want to do with its output. Each runs or interprets the purely-defined computation...:
    - and just gets its output: `extract`
    - into some other monad (more restrictive): `interpret`. Rather than writing `log $ show $ extract expression`, one could `interpret` the expression into the `Effect` monad
    - into some other monad (less restrictive): `run`
- `Run` and these functions provide a nice wrapper over `Free` and `VariantF`, making it easier to read/write code that uses them.

## Examining the Type Aliases

Second, let's look at some of the type aliases it provides (the following two blocks of code are licensed under [the MIT license](https://github.com/natefaubion/purescript-run/blob/v2.0.0/LICENSE):
```purescript
type EFFECT = FProxy Effect
type AFF = FProxy Aff
```
Rather than typing `FProxy Functor`, we use an all-caps type alias: `FUNCTOR`. This improves code readability. We should follow suit.

Here's a few other type aliases that will look familiar.
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

Third, if we look at some of the functions that each of the above MTL-like types provide, we'll notice another pattern. Each type (e.g. `Reader`) seems to define its own `Symbol` (e.g. `_reader :: SProxy "reader"`) for the corresponding type in `VariantF`'s row type (e.g. `READER`).

However, if one wanted to use a custom `Symbol` name for their usage of an MTL-like type (e.g. `Reader`), they can append `at` to the function and get the same thing. In other words:
```purescript
liftReader readerObj = liftReaderAt _reader readerObj

liftReaderAt symbol readerObj = -- implementation

ask = askAt _reader

askAt symbol = -- implementation
```
