# From Coproduct to VariantF

Previously, we explained `Coproduct`
```haskell
data Either l r = Left l | Right r

newtype Coproduct f g a = Coproduct (Either (f a) (g a))

-- not nested
Either (Value e) (Add e)
Coproduct Value Add e

-- nested
Either   (Value e) (Either   (Add e) (Multiply e))
Coproduct Value    (Coproduct Add     Multiply) e

-- nested using convenience types from both libraries
Either3   (Value e) (Add e) (Multiply e)
Coproduct3 Value     Add     Multiply e
```

When covering `Either`, we explained that it was vulnerable to the following refactoring issues because it is not "open":
1. Change the order of the types
2. Add/Remove a type
3. Change one type to another type

Since `Coproduct` is just a newtype wrapper over an `Either`, it suffers from the same "closed" problem. Thus, we'll need a corresponding `Variant`-like type to make it open. That type is `VariantF`.

| | Open/Closed | Kind
| - | - | - |
| `Either` | Closed | Type
| `Variant` | Open | Type
| `Coproduct` | Closed | Type -> Type
| `VariantF` | Open | Type -> Type

## Explaining `VariantF`

[`VariantF`](https://pursuit.purescript.org/packages/purescript-variant/5.0.0/docs/Data.Functor.Variant#t:VariantF) builds upon `Variant`. To refresh our memory, `Variant`...
- enables us to write nested `Either`s using row kinds via `# Type` that is refactor-proof due to row polymorphism (i.e. "open" data type).
- has two core methods:
    - `inj` (inject): puts a value into a `Variant`
    - `prj` (project): extracts a value from a `Variant` if it exists
- requires the use of `Symbol` and `Proxy` to specify which field within the row is being used

`VariantF` adds the additional requirement of using a proxy called `FProxy` to wrap a type-level higher-kinded type:
```haskell
data FProxy (f :: Type -> Type) = FProxy
```
Looking at `VariantF`, we see the following definition, whose type names I have modified to make it look similar to `Coproduct`:
```haskell
data    VariantF (f_and_g :: # Type) a

-- for example
--      VariantF (f :: FProxy F_Type, g :: FProxy G_Type) a
newtype Coproduct f g                a  = Coproduct (Either (f a) (g a))
```

Let's see what the code looks like now:
```haskell
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
derive instance Functor Fruit_HigherKindedType

-- Either (Fruit_HigherKindedType Int) (v Int)
-- Coproduct Fruit_HigherKindedType v Int
forall v. VariantF (fruit :: FProxy Fruit_HigherKindedType | v) Int
```

## Composing Type-Level Types via `RowApply`

When we wanted to compose two or more data types, we used nested `Either`s. When we wanted to compose two or more higher-kinded data types, we used nested `Coproduct`s. What, then, do we write to compose two or more type-level higher-kinded types?

We use type aliases for rows and [`RowApply`/`+`](https://pursuit.purescript.org/packages/purescript-typelevel-prelude/3.0.0/docs/Type.Row#t:RowApply) from `Prelude`:
```haskell
import Type.Row (type (+)) -- infix for RowApply
data ValueF e = ValueF Int
data AddF e = AddF e e

-- We create a type alias for a Row that includes
-- that specific higher-kinded type via FProxy
type Value r = (value :: FProxy Valuef | r)
type Add r = (add :: FProxy AddF | r)

-- and then compose the rows together using RowApply / "+"
type ValueAdd r = (Value + Add + r)
-- which desugars ultimately to
type ValueAdd otherRows = (value :: FProxy ValueF, add :: FProxy AddF | otherRows)

-- In our final type, we'll need to use an empty row to "close" the row
-- so that our code compiles
VariantF (ValueAdd + ()) e
```

## Defining Composable Algebras for Data Types

To evaluate an expression, we will write this:
```haskell
fold (
  case_
    -- valueAlgebra
    # on valueSymbol (\(ValueF x) -> x)                               {-
    # otherAlgebra -- like add or multiply                            -}
  ) expression
```
Thus, to make one `Algebra` (i.e. a fancy name for `f a -> a`) composable with other algebras of future data types that we might declare, we will write things like this:
```haskell
valueAlgebra :: forall r

             -- this is the `case_` function
              . (VariantF r Int -> Int)

             -> (VariantF (Value + r) Int -> Int)
valueAlgebra = on valueSymbol \(ValueF x) -> x
```

## Running an Algebra on an Expression

When we are ready to evaluate an expression, we will need the `algebra` (`f a -> a`) that can compute a value when given an expression, and the actual expression. To make it work for all output types, we'll use a generic type. Thus, we get something like this:
```haskell
run :: forall f a b output
      . Functor f
     -- |   composed algebra waiting for `case_`     |
     --  |     case_        | # | composed algebra |
     => ((VariantF () a -> b) -> f output -> output )
     -> Expression f
     -> output
run composedAlgebras expression = fold (case_ # composedAlgebras) expression
```

## Final Result

The following files of code are an adapted version of a gist that was sent to me in PureScript's chatroom. The link to the gist will appear after the next few files of code.

The following files can be run using this command below:
```
spago run -m Free.ExpressionBased.VariantF.Value
spago run -m Free.ExpressionBased.VariantF.Add
spago run -m Free.ExpressionBased.VariantF.Multiply
```
