module Free.RunBased.Add
  ( main
  , AddF
  , ADD
  , add
  , example_add
  , addAlgebra
  , eval
  ) where
--
import Prelude hiding (add)
import Effect (Effect)
import Effect.Console (log)
import Data.Either (Either(..))
import Data.Functor.Variant (VariantF, FProxy, on, case_)
import Data.Symbol (SProxy(..))
import Type.Row (type (+))
import Free.RunBased.Value (value)
import Run (Run, lift, peel)

-- Data stuff
data AddF e = AddF e e

derive instance af :: Functor AddF

-- Variant Stuff
type ADD r = (add :: FProxy AddF | r)

_add :: SProxy "add"
_add = SProxy

add :: forall r a
     . Run (ADD + r) a
    -> Run (ADD + r) a
    -> Run (ADD + r) a
add x y = join $ lift _add (AddF x y)

example_add :: forall r. Run (ADD + r) Int
example_add = add (value 5) (value 6)

-- Eval stuff
addAlgebra :: forall r
            . (VariantF r Int -> Int)
           -> (VariantF (ADD + r) Int -> Int)
addAlgebra = on _add \(AddF x y) -> x + y

-- fold
iter :: forall r a. (VariantF r a -> a) -> Run r a -> a
iter k = go
  where
  go m = case peel m of
    Left f -> k (go <$> f)
    Right a -> a

eval :: forall r a b
      . ((VariantF () a -> b) -> VariantF r Int -> Int)
     -> Run r Int
     -> Int
eval algebra = iter (case_ # algebra)

-- Examples
main :: Effect Unit
main = do
  log $ show $ eval addAlgebra example_add
