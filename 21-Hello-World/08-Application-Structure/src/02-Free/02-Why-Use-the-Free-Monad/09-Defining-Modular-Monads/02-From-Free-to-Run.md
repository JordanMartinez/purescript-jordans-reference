# From `Free` to `Run`

If you recall, `xgromxx` mentions [`purescript-run`](https://pursuit.purescript.org/packages/purescript-run/2.0.0) in [a comment in `ADT8.purs`](https://github.com/xgrommx/purescript-from-adt-to-eadt/blob/master/src/ADT8.purs#L11). (The ReadMe of this library provides an overview of the ideas we've explained here.)

The library provides the same functionality as `Free` in `purescript-free` with one advantage. Whereas `Free` is vulnerable to stack overflows, `purescript-run` can lessen the possibility of stack overflows or completely guarantee stack-safety. Thus, it should be used instead of `Free`. **See the "Stack-Safety" section at the bottom of the project's ReadMe.**

We'll explain later in the "Onion Architecture.md" file why the stackoverflow problem can occur. For now, we'll solve the paper's version of the Expression Problem using `purescript-run` to gradually introduce you to its types and some of its functions.

## Core Type and A Few Functions

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

-- | Extracts the value from a purely interpreted program.
extract ∷ ∀ a. Run () a → a
extract = -- implementation not shown

peel :: forall a r. Run r a -> Either (VariantF r (Run r a)) a
```
The takeaways here:
- `Run` is a newtype, so there is no runtime overhead
- `lift` is `Run`'s version of `Free`'s `liftF`
- `peel` is `Run`'s version of `Free`'s `resume`
- These types and functions provide a nice wrapper over `Free` and `VariantF`, making it easier to read/write code that uses them.

## Examining the Type Aliases

Second, let's look at some of the type aliases it provides:
```purescript
type EFFECT = FProxy Effect
type AFF = FProxy Aff
```
Rather than typing `(fieldName :: FProxy Functor)`, we use an all-caps type alias: `(fieldName :: FUNCTOR)`. This improves code readability, so we will follow suit.
