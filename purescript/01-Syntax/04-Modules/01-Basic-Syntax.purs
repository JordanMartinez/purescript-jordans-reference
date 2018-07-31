module ModuleName
{-
if this module makes anything public to the rest of the world
it should go here using the syntax:
  ( export
  , export

  , ... (this will be shown explicitly later)
  )
-}
where
{- or
module ModuleName.SubModuleName.SubSubModule ... where -}

-- imports (by convention) appear at the top
import Prelude

-- everything else in the module (by convention) goes underneath it

function :: forall a b. a -> b
-- implementation

value :: Int
value = 3
