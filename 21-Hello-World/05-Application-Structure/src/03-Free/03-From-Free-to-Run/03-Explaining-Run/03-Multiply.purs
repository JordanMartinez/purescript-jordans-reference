module Free.RunBased.Multiply where

import Prelude hiding (add)
import Effect (Effect)
import Effect.Console (log)
import Data.Functor.Variant (VariantF, FProxy, on)
import Data.Symbol (SProxy(..))
import Type.Row (type (+))
import Free.RunBased.Value (value)
import Free.RunBased.Add (ADD, add, addAlgebra, eval)
import Run (Run, lift)

-- Data stuff
data MultiplyF e = MultiplyF e e

derive instance af :: Functor MultiplyF

-- Variant Stuff
type MULTIPLY r = (multiply :: FProxy MultiplyF | r)

_multiply :: SProxy "multiply"
_multiply = SProxy

multiply :: forall r a
     . Run (MULTIPLY + r) a
    -> Run (MULTIPLY + r) a
    -> Run (MULTIPLY + r) a
multiply x y = join $ lift _multiply (MultiplyF x y)

example_multiply :: forall r. Run (MULTIPLY + r) Int
example_multiply = multiply (value 5) (value 6)

-- Eval stuff
multiplyAlgebra :: forall r
            . (VariantF r Int -> Int)
           -> (VariantF (MULTIPLY + r) Int -> Int)
multiplyAlgebra = on _multiply \(MultiplyF x y) -> x * y

amAlgebra :: forall r
           . (VariantF r Int -> Int)
          -> (VariantF (ADD + MULTIPLY + r) Int -> Int)
amAlgebra = addAlgebra >>> multiplyAlgebra

-- Examples
main :: Effect Unit
main = do
  log $ show $ eval multiplyAlgebra example_multiply
  log $ show $ eval amAlgebra (multiply (add (value 5) (multiply (value 2) (value 4))) (value 5))
