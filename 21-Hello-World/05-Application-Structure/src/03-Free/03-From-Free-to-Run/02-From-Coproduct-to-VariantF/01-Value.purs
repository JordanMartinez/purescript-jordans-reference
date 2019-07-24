module Free.ExpressionBased.VariantF.Value
  (
  -- data type and VariantF injection stuff
    ValueF, Value, value

  -- eval stuff
  , valueAlgebra, example_value, eval

  -- The "glue" that makes this work (Expression stuff)
  -- Normally, this file would not have these declarations because
  -- a library would provide it and we'd import it here.
  , Expression(..), fold, run
  ) where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Data.Functor.Variant (VariantF, FProxy, inj, on, case_)
import Data.Symbol (SProxy(..))
import Type.Row (type (+))

-- Expression, fold, and algebra-unspecific run
-- (These would be imported from the libraries that provide them)
newtype Expression f = In (f (Expression f))

fold :: forall f a. Functor f => (f a -> a) -> Expression f -> a
fold f (In t) = f (map (fold f) t)

-- see `eval` below
run :: forall f a b output
      . Functor f
      -- |     case_        | # |    algebra       |
     => ((VariantF () a -> b) -> f output -> output)
     -> Expression f
     -> output
run algebra expression = fold (case_ # algebra) expression

-- data stuff
data ValueF e = ValueF Int

derive instance vf :: Functor ValueF

-- VariantF stuff
type Value r = (value :: FProxy ValueF | r)

valueSymbol :: SProxy "value"
valueSymbol = SProxy

value :: forall r. Int -> Expression (VariantF (Value + r))
value i = In $ inj valueSymbol (ValueF i)

example_value :: forall r. Expression (VariantF (Value + r))
example_value = value 5

-- eval stuff
valueAlgebra :: forall r
              . (VariantF r Int -> Int)
             -> (VariantF (Value + r) Int -> Int)
valueAlgebra = on valueSymbol \(ValueF x) -> x

-- This function is not necessary.
--
-- It simply makes `run` above seem more sensible by giving you a
-- more familiar name and by defining the output type to be `Int`
eval :: forall f a b
      . Functor f
     => ((VariantF () a -> b) -> f Int -> Int)
     -> Expression f
     -> Int
eval = run

-- examples
main :: Effect Unit
main = log $ show $ eval valueAlgebra example_value
