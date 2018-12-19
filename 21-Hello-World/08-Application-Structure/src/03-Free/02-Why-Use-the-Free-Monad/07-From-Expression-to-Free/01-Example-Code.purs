module Free.ExampleCode where

import Prelude hiding (add)
import Effect (Effect)
import Effect.Console (log)
import Control.Monad.Free (Free, wrap, resume)
import Data.Either (Either(..))
import Data.Functor.Coproduct (Coproduct, coproduct)
import Data.Functor.Coproduct.Inject (inj)

data AddF e = AddF e e
derive instance af :: Functor AddF

evalAdd :: AddF Int -> Int
evalAdd (AddF a b) = a + b

data MultiplyF e = MultiplyF e e
derive instance mf :: Functor MultiplyF

evalMultiply :: MultiplyF Int -> Int
evalMultiply (MultiplyF a b) = a * b


type Expr = Free (Coproduct AddF MultiplyF)

value :: forall a. a -> Expr a
value a = pure a

add :: forall a. Expr a -> Expr a -> Expr a
add a b = wrap $ inj (AddF a b)

multiply :: forall a. Expr a -> Expr a -> Expr a
multiply a b = wrap $ inj (MultiplyF a b)

evalAlgebra :: Coproduct AddF MultiplyF Int -> Int
evalAlgebra =
  -- coproduct handles the Coproduct and Either stuff for us
  coproduct
    -- when the instance is AddF, use this function
    evalAdd
    -- when the instance is MultiplyF, use this function
    evalMultiply

iter :: forall f a. Functor f => (f a -> a) -> Free f a -> a
iter k = go where
  go m = case resume m of
    Left f -> k (go <$> f)
    Right a -> a

eval :: Expr Int -> Int
eval = iter evalAlgebra

example :: Expr Int
example =
  add
    (multiply
      (value 4)
      (add
        (value 8)
        (value 5)
      )
    )
    (value 5)


main :: Effect Unit
main = do
  log $ show $ eval example
