module Free.RunBased.Add
  ( main
  , AddF, ADD, add
  , example_add, addAlgebra
  , eval
  ) where
--
import Prelude hiding (add)
import Effect (Effect)
import Effect.Console (log)
import Data.Either (Either(..))
import Data.Functor.Variant (VariantF, on, case_)
import Type.Row (type (+))
import Type.Proxy (Proxy(..))
import Free.RunBased.Value (value)
import Run (Run, lift, peel)

-- Data stuff
data AddF e = AddF e e

derive instance Functor AddF

-- Variant Stuff
type ADD r = (add :: AddF | r)

_add :: Proxy "add"
_add = Proxy

{-
We know from previous code that we need a type signature like
add :: Expression a
    -> Expression a
    -> Expression a

However, if we follow the same pattern we've been using via `Run.lift`
the return type's `a` will be another "Expression a"
-}
add_problematic :: forall r a
                 . Run (ADD + r) a
                -> Run (ADD + r) a
                -> Run (ADD + r) (Run (ADD + r) a)
add_problematic x y = lift _add (AddF x y)

{-
To get around this problem, we need to remember that
Run is a monad. Thus, the above type signature could look like this:

    add_problematic :: forall m a
                     . Monad m
                    => m a
                    -> m a
                    -> m (m a)

We need a function whose type signature is...
    m (m a) -> m a
... to get rid of that nested monad.
This is known as 'join' from 'Bind'                                         -}
add_correct :: forall r a
             . Run (ADD + r) a
            -> Run (ADD + r) a
            -> Run (ADD + r) a
add_correct x y = join $ add_problematic x y

-- Putting it all on one line:
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
