module Free.ExpressionBased.VariantF.Add
  ( AddF, Add, add
  , example_add, addAlgebra

  , example_value_add, VA, vaAlgebraComposed
  ) where

import Prelude hiding (add)
import Effect (Effect)
import Effect.Console (log)
import Data.Functor.Variant (VariantF, inj, on)
import Type.Row (type (+))
import Type.Proxy (Proxy(..))
import Free.ExpressionBased.VariantF.Value (
    Value, value
  , example_value, valueAlgebra
  , Expression(..), eval
)

-- Data stuff
data AddF e = AddF e e

derive instance Functor AddF

-- Variant Stuff
type Add r = (add :: AddF | r)

addSymbol :: Proxy "add"
addSymbol = Proxy

add :: forall r
       . Expression (VariantF (Add + r))
      -> Expression (VariantF (Add + r))
      -> Expression (VariantF (Add + r))
add x y = In $ inj addSymbol (AddF x y)

example_add :: forall r. Expression (VariantF (Value + Add + r))
example_add = add (value 5) (value 6)

-- Eval stuff
addAlgebra :: forall r
            . (VariantF r Int -> Int)
           -> (VariantF (Add + r) Int -> Int)
addAlgebra = on addSymbol \(AddF x y) -> x + y

-- Composition
type VA r = (Value + Add + r)

example_value_add :: forall r. Expression (VariantF (VA + r))
example_value_add = add (value 4) (add (value 8) example_value)

vaAlgebraComposed :: forall r
                     . (VariantF r Int -> Int)
                    -> (VariantF (VA + r) Int -> Int)
vaAlgebraComposed = valueAlgebra >>> addAlgebra

{-
This could also work if we defined `Add` in the same file as
Value, so that we could use `ValueF`'s data constructor.
It doesn't work here because we did not export
ValueF's data constructor.
To understand why we made this choide,
see "Design Patterns/Smart Constructors"
vaAlgebraBoth :: forall r
                     . (VariantF r Int -> Int)
                    -> (VariantF (VA + r) Int -> Int)
vaAlgebraBoth = onMatch
  { value: \(ValueF x) -> x
  , add: \(AddF x y) -> x + y
  }                                                                 -}

-- Examples
main :: Effect Unit
main = do
  log $ show $ eval vaAlgebraComposed $ example_add
  log $ show $ eval vaAlgebraComposed $ example_value_add

  -- log $ show $ eval vaAlgebraBoth     $ example_add
  -- log $ show $ eval vaAlgebraBoth     $ example_value_add
