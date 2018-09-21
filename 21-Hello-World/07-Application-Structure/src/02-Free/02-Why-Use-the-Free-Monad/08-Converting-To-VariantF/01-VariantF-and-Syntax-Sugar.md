# VariantF and Syntax Sugar

Now that we have a better understanding of the concept, let's add the type-level stuff back in using `VariantF`.

## Composing Type-Level Types via `RowApply`

When we wanted to compose two or more data types, we used nested `Either`s. When we wanted to compose two or more higher-kinded data types, we used nested `Coproduct`s. What, then, do we write to compose two or more type-level higher-kinded types?

We use type aliases for rows and [`RowApply`/`+`](https://pursuit.purescript.org/packages/purescript-typelevel-prelude/3.0.0/docs/Type.Row#t:RowApply) from `Prelude`:
```purescript
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
type ValueAdd otherRow = (value :: FProxy ValueF, add :: FProxy AddF | otherRow)

-- and we can put this into a VariantF
VariantF (ValueAdd + r) e
```

## Defining Composable Algebras for Data Types

To evaluate an expression, we will write this:
```purescript
fold (
  case_
    -- valueAlgebra
    # on valueSymbol (\(ValueF x) -> x)                               {-
    # otherAlgebra -- like add or multiply                            -}
  ) expression
```
Thus, to make one `Algebra` (i.e. a fancy name for `f a -> a`) composable with other algebras of future data types that we might declare, we will write things like this:
```purescript
valueAlgebra :: forall r

             -- this is the `case_` function
              . (VariantF r Int -> Int)

             -> (VariantF (Value + r) Int -> Int)
valueAlgebra = on valueSymbol \(ValueF x) -> x
```

## Running an Algebra on an Expression

When we are ready to evaluate an expression, we will need the `algebra` (`f a -> a`) that can compute a value when given an expression, and the actual expression. To make it work for all output types, we'll use a generic type. Thus, we get something like this:
```purescript
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

The following files of code are an adapted version of a gist that was sent to me on the Slack channel. The link to the gist will appear after the next few files of code.

The following files can be run using this command below:
```
pulp --psc-package run -m ComputingWithMonads.Free.VariantF.Value
pulp --psc-package run -m ComputingWithMonads.Free.VariantF.Add
pulp --psc-package run -m ComputingWithMonads.Free.VariantF.Multiply
```
