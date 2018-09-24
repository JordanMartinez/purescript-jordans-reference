# From Coproduct to VariantF

## Revealing Coproduct

In the previous file, we wrote this:
```purescript
Either (Value e) (Either (Add e) (Multiply e))
```
However, this is just a more verbose form of [`Coproduct`](https://pursuit.purescript.org/packages/purescript-functors/3.0.1/docs/Data.Functor.Coproduct#t:Coproduct):
```purescript
newtype Coproduct f g a = Coproduct (Either (f a) (g a))
```
Indeed, just as there was a library for `Either` via `purescript-either`, there is also a library for `Coproduct`: [`purescript-functors`](https://pursuit.purescript.org/packages/purescript-functors/3.0.1/docs/Data.Functor.Coproduct#t:Coproduct), which also includes convenience functions and types for dealing with nested versions of `Coproduct` [here](https://pursuit.purescript.org/packages/purescript-functors/3.0.1/docs/Data.Functor.Coproduct.Nested) as well as inject instances into and project instances out of it [here](https://pursuit.purescript.org/packages/purescript-functors/3.0.1/docs/Data.Functor.Coproduct.Inject).

To help us understand how to read and write `Coproduct`, let's compare the `Coproduct` version to its equivalent `Either` version:
```purescript
-- not nested
Either (Value e) (Add e)
Coproduct Value Add e

-- nested
Either (Value e) (Either (Add e) (Multiply e))
Coproduct Value (Coproduct Add Multiply) e

-- nested using convenience types from both libraries
Either3 (Value e) (Add e) (Multiply e)
Coproduct3 Value Add Multiply e
```

## Explaining VariantF

When we explored the idea of nested `Either`s before, we raised the issue of refactoring, which has three forms:
1. Change the order of the types
2. Add/Remove a type
3. Change one type to another type

Our solution to the above problem was to use `Variant`, which is an "open" `Either` for kind `Type`. However, now we need a version of `Variant` that works for kind `Type -> Type`, higher-kinded types at the type-level.  `Variant` uses type-level programming, how would we do that? Fortunately, there is `VariantF`, which exists for that reason.

`VariantF` builds upon `Variant`. To refresh our memory, `Variant`...
- enables us to write nested `Either`s using the `Row`/`# Type` kind that is refactor-proof due to row polymorphism (i.e. "open" data type).
- has two core methods:
    - `inj` (inject): puts an instance into a `Variant`
    - `prj` (project): extracts an instance from a `Variant` if it exists
- requires the use of `Symbol` and `SProxy` to specify which "field"/type within the row is being used

`VariantF` adds the additional requirement of using a proxy called `FProxy` to wrap a type-level higher-kinded type:
```purescript
data FProxy (f :: Type -> Type) = FProxy
```
Looking at `VariantF`, we see the following definition, whose type names I have modified to make it look similar to `Coproduct`:
```purescript
data    VariantF (f_and_g :: # Type) a

newtype Coproduct f g                a  = Coproduct (Either (f a) (g a))
```

Let's see what the code looks like now:
```purescript
-- Rather than writing this...
data Fruit_ConcreteType
  = Apple
  | Banana

-- Either Fruit_ConcreteType v
forall v. Variant  (fruit ::        Fruit_ConcreteType     | v)

-- ... we can now write this...
data Fruit_HigherKindedType e
  = Apple
  | Banana
derive instance f :: Functor Fruit_HigherKindedType

-- Either (Fruit_HigherKindedType Int) (v Int)
-- Coproduct Fruit_HigherKindedType v Int
forall v. VariantF (fruit :: FProxy Fruit_HigherKindedType | v) Int
```

## Postponing Further Explantion

Since `VariantF` uses type-level programming, which can add "noise" to our explanations because one has to deal with the type-level aspect of things, we'll use `Coproduct` instead in the upcoming examples.

Since `Coproduct` is a compile-time-only type that wraps `Either`, any functions on it will be delegated to the underlying `Either`.
