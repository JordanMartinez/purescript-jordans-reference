# Explaining `Run`

This folder will explain the basic idea of `purescript-run` and then solve the paper's version of the Expression Problem using it.

## What is `Run`?

If you recall, `xgrommx` mentions [`purescript-run`](https://pursuit.purescript.org/packages/purescript-run/2.0.0) in [a comment in `ADT8.purs`](https://github.com/xgrommx/purescript-from-adt-to-eadt/blob/master/src/ADT8.purs#L11). (The ReadMe of this library provides an overview of the ideas we've explained here.)

What is `purescript-run`? Why would we use that over `Free`? There are three reasons.

First, let's look at the type of `Run` :
```haskell
newtype Run r a = Run (Free (VariantF r) a)
```
We can see that `Run` is a compile-time-only type that specifies the `Functor` type of `Free` to the open `CoProduct` type: `VariantF`.

Let's compare the same idea encoded in both forms (note: `Run` will use naming conventions that will be explained below):
```haskell
free :: Free (VariantF (add :: FProxy Add, subtract :: FProxy Subtract)) a
-- is the same as
run  :: Run (ADD + SUBTRACT) a
```
**In short, `Run` draws attention to the effects used and eliminates other distracting "noise" that occurs due to a lot of types.**

Second, this library exposes helper [functions](https://pursuit.purescript.org/packages/purescript-run/2.0.0/docs/Run#v:interpret) that add a [`MonadRec` type class](https://pursuit.purescript.org/packages/purescript-tailrec/4.0.0/docs/Control.Monad.Rec.Class#t:MonadRec) constraint to guarantee that stack overflows won't occur. Due to the recursive nature by which one "interprets" a `Free` monad, `Free`-based computations can sometimes result in stack overflows. **These helper functions make it trivial to insure stack-safety.** See the "Stack-Safety" section at the bottom of the project's ReadMe for more info.

Third, **this library already defines types and functions for using and working with different effects** (e.g. `StateT`, `ReaderT`, `WriterT`, etc. but for the `Free` monad). One does not need to re-implement these types for each project, so that the code works every time. (These are also covered more below)

## Comparing Run to Free and MTL

### Free and Run: Some Core Functions Compared

Let's look at a few core functions (the following block of code is licensed under [the MIT license](https://github.com/natefaubion/purescript-run/blob/v2.0.0/LICENSE):
```haskell
newtype Run r a = Run (Free (VariantF r) a)

-- `Run`'s version of `Free`'s `liftF`
lift
  ∷ ∀ sym r1 r2 f a
  . Row.Cons sym (FProxy f) r1 r2
  ⇒ IsSymbol sym
  ⇒ Functor f

  ⇒ Proxy sym
  → f a
  → Run r2 a
                    -- Run    (Free    ( VariantF (row :: type)) output)
lift symbol dataType = Run <<< liftF <<< inj symbol dataType

-- This function will appear later in this folder's code
-- | Extracts the value from a purely interpreted program.
extract ∷ ∀ a. Run () a → a

-- `Run`'s version of `Free`'s `resume`
peel :: forall a r. Run r a -> Either (VariantF r (Run r a)) a
```

### Naming Conventions for Effects

Let's look at some of the type aliases it provides:
```haskell
type EFFECT = FProxy Effect
type AFF = FProxy Aff
```
Rather than typing `(fieldName :: FProxy Functor)`, we use an all-caps type alias: `(fieldName :: FUNCTOR)`. This improves code readability, so we will follow suit.

### Similarities to MTL

#### Type Aliases

`purescript-run` has a few other type aliases that will look familiar.
```haskell
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
- As stated above, `purescript-run` already defines and properly handles the types that make the same effects we saw in the `MTL` folder work out-of-box.
- The `a` in each type is the output type, so it is excluded.
- `FAIL` indicates an error whose type we don't care about.

#### MTL-Like Functions

If we look at some of the functions that each of the above MTL-like types provide, we'll notice another pattern. Each type (e.g. `Reader`) seems to define its own `Symbol` (e.g. `_reader :: Proxy "reader"`) for the corresponding type in `VariantF`'s row type (e.g. `READER`).

However, if one wanted to use a custom `Symbol` name for their usage of an MTL-like type (e.g. `Reader`), they can append `at` to the function and get the same thing. In other words:
```haskell
liftReader readerObj = liftReaderAt _reader readerObj

liftReaderAt symbol readerObj = -- implementation

ask = askAt _reader

askAt symbol = -- implementation
```

In short, one can use a `Run`-based monad to do two different state computations in the same function, something which the unmodified `MTL` approach via `MonadState` cannot do.

## Examples of MTL-Like Run-Based Code

- See this project's `Hello World/Projects/src/Simplest Program` folder for an example of what a very simple program with a `Run`-based architecture looks like.
- [A simple program using multiple effects](https://pursuit.purescript.org/packages/purescript-run/2.0.0/docs/Run#t:Run)
- A [short explanation from Free to Run](https://github.com/natefaubion/purescript-run#free-dsls) that also covers `Coproduct`/`VariantF` and whose code can be found in the project's test directory:
    - [Examples.purs](https://github.com/natefaubion/purescript-run/blob/master/test/Examples.purs)
    - [Main.purs](https://github.com/natefaubion/purescript-run/blob/master/test/Main.purs)
