module Free.AddAndMultiply where

import Prelude hiding (add)
import Effect (Effect)
import Effect.Console (log)
import Control.Monad.Free (Free, wrap)
import Data.Functor.Coproduct (Coproduct, coproduct)
import Data.Functor.Coproduct.Inject (class Inject, inj)
import Free.Value (iter, value)
import Free.Add (AddF(..), addAlgebra, showAddExample)
import Free.Multiply (MultiplyF(..), multiplyAlgebra, showMultiplyExample)

-- `Coproduct AddF MultiplyF` is same as `Either (AddF a) (MultiplyF a)`

addAndMultiplyAlgebra :: Coproduct AddF MultiplyF Int -> Int
addAndMultiplyAlgebra =
  -- coproduct handles the Coproduct and Either stuff for us
  coproduct
    -- when the instance is AddF, use this function
    addAlgebra
    -- when the instance is MultiplyF, use this function
    multiplyAlgebra

type AddAndMultiply = Free (Coproduct AddF MultiplyF)

-- Since we're putting AddF into a Coproduct now before we put that
-- into a Free, we need to pass it into 'inj' before it gets passed into `wrap`
add' :: forall a. AddAndMultiply a -> AddAndMultiply a -> AddAndMultiply a
add' a b = wrap $ inj (AddF a b)

-- This function exists for the same reasons as above. However,
-- it also shows that we do not need to hard-code the "AddAndMultiply" type
-- to get this to work.
multiply' :: forall f a.
             Functor f =>
             Inject MultiplyF f =>
             Free f a -> Free f a -> Free f a
multiply' a b = wrap $ inj (MultiplyF a b)

evalAddAndMultiply :: AddAndMultiply Int -> Int
evalAddAndMultiply = iter addAndMultiplyAlgebra

{- Note:
Non-Coproduct version: add   multiply
Coproduction version:  add'  multiply'                                       -}
exampleAddAndMultiply :: AddAndMultiply Int
exampleAddAndMultiply =
  add'
    (multiply'
      (value 4)
      (add'
        (value 8)
        (value 5)
      )
    )
    (value 5)

showAddAndMultiplyExample :: Effect Unit
showAddAndMultiplyExample = do
  log "Add and multiply example:"
  log $ show $ evalAddAndMultiply exampleAddAndMultiply

------------------------------------

main :: Effect Unit
main = do
  showAddExample
  showMultiplyExample
  showAddAndMultiplyExample
