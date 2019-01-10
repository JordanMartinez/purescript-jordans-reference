module Free.Multiply (MultiplyF(..), multiply, multiplyAlgebra, showMultiplyExample) where

import Prelude hiding (add)
import Effect (Effect)
import Effect.Console (log)
import Control.Monad.Free (Free, wrap)
import Free.Value (iter, value)

--------------------------------------------------
-- Code in this section will be reused in upcoming file

data MultiplyF e = MultiplyF e e
derive instance mf :: Functor MultiplyF

multiplyAlgebra :: MultiplyF Int -> Int
multiplyAlgebra (MultiplyF a b) = a * b

--------------------------------------------------
-- Code in this section will NOT be reused

type MultiplyOnly = Free MultiplyF

multiply :: forall a. MultiplyOnly a -> MultiplyOnly a -> MultiplyOnly a
multiply a b = wrap (MultiplyF a b)

evalMultiply :: MultiplyOnly Int -> Int
evalMultiply = iter multiplyAlgebra

multiplyOnlyExample :: MultiplyOnly Int
multiplyOnlyExample =
  multiply
    (value 4)
    (multiply
      (value 8)
      (value 5)
    )

showMultiplyExample :: Effect Unit
showMultiplyExample = do
  log "Multiply example:"
  log $ show $ evalMultiply multiplyOnlyExample
