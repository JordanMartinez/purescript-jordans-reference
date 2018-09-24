module Free.RunBased.Value (main, value, example_value) where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Data.Either (Either(..))
import Data.Functor.Variant (VariantF, FProxy, inj, on, case_, default)
import Data.Symbol (SProxy(..))
import Run (Run, extract, lift, interpret, peel)
import Type.Row (type (+))
import Partial.Unsafe (unsafeCrashWith)

value :: forall r. Int -> Run r Int
value i = pure i

example_value :: forall r. Run r Int
example_value = value 5

main :: Effect Unit
main = do
  log $ show $ extract example_value
