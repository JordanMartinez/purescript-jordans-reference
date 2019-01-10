module Free.Add (AddF(..), add, addAlgebra, showAddExample) where

import Prelude hiding (add)
import Effect (Effect)
import Effect.Console (log)
import Control.Monad.Free (Free, wrap)
import Free.Value (iter, value)

--------------------------------------------------
-- Code in this section will be reused in upcoming file

data AddF e = AddF e e
derive instance af :: Functor AddF

addAlgebra :: AddF Int -> Int
addAlgebra (AddF a b) = a + b

--------------------------------------------------
-- Code in this section will NOT be reused

type AddOnly = Free AddF

add :: forall a. AddOnly a -> AddOnly a -> AddOnly a
add a b = wrap (AddF a b)

evalAdd :: AddOnly Int -> Int
evalAdd = iter addAlgebra

addOnlyExample :: AddOnly Int
addOnlyExample =
  add
    (value 4)
    (add
      (value 8)
      (value 5)
    )

showAddExample :: Effect Unit
showAddExample = do
  log "Add example:"
  log $ show $ evalAdd addOnlyExample
