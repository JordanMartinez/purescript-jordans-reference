# Converting to VariantF

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

## Final Result

This is an adapted version of [this code here](https://gist.github.com/xgrommx/35f912544d37420db5f195c9b515ceb3) that converts the unfamiliar Matryoshka-library types and names into the more familiar types and names we've been using here.
```purescript
-- File 1
data ValueF e = ValueF Int
data AddF e = AddF e e

derive instance vf :: Functor ValueF
derive instance af :: Functor AddF

type Value r = (value :: FProxy ValueF | r)
type Add r = (value :: FProxy AddF | r)

type Base r = (Value + Add + r)

newtype Expression f = In (f (Expression f))

valueSymbol :: SProxy "value"
valueSymbol = SProxy

value :: forall r. Int -> Expression (VariantF (Val r))
value i = In $ inj valueSymbol (ValueF i)

addSymbol :: SProxy "add"
addSymbol = SProxy

add :: forall r
       . Expression (VariantF (Add + r))
      -> Expression (VariantF (Add + r))
      -> Expression (VariantF (Add + r))
add x y = In $ inj addSymbol (AddF x y)

evaluateBaseAlgebra :: forall v
                     . ((VariantF r) -> Int)
                    -> (VariantF (Base + r)) Int
evaluateBaseAlgebra = onMatch
  { value: \(ValueF x) -> x
  , add : \(AddF x y) -> x + y
  }

fold :: Functor f => (f a -> a) -> Expression f -> a
fold f (In t) = f (map (fold f) t)

eval :: forall f. (f Int -> Int) -> Expression f -> Int
eval evaluateAlgebra expression = fold (case_ # evaluateAlgebra) expression

-- call `eval evaluateBaseAlgebra file1Example`
file1Example :: forall r. Expression (VariantF (Base + r))
file1Example = add (value 5) (value 6)

-- File 2
data MultiplyF e = MultiplyF e e
derive instance mf :: Functor Multiply

multiplySymbol :: SProxy "multiply"
multiplySymbol = SProxy

multiply :: forall r
       . Expression (VariantF (Multiply + r))
      -> Expression (VariantF (Multiply + r))
      -> Expression (VariantF (Multiply + r))
multiply x y = In $ inj multiplySymbol (Multiply x y)

evaluateMultiAlgebra :: forall v
                     . ((VariantF r) -> Int)
                    -> (VariantF (Multiply + r)) Int
evaluateMultiAlgebra =
  on multiplySymbol (\(MultiplyF x y) -> x * y)

evaluateBoth :: forall v
              . ((VariantF r) -> Int)
             -> (VariantF (Base + Multiply + r)) Int
evaluateBoth =
  evaluateBaseAlgebra >>> evaluateMultiAlgebra

-- call `eval evaluateBoth file2Example`
file2Example :: :: forall r. Expression (VariantF (Base + Multiply + r))
file2Example = add (value 5) (multiply (add (value 2) (value 8)) (value 4))
```
