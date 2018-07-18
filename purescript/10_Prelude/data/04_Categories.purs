class Semigroupoid a where
  compose :: forall b c d. a c d   -> a b c    -> a b d
     -- In other words... (c -> d) -> (b -> c) -> (b -> d)
     -- but generalized to things other than functions

composeFlipped :: Signature -> Excluded

infixr 9 compose as <<<
infixr 9 composeFlipped as >>>

-- Composition
f :: Int -> Int
f x = x + 1

g :: Int -> Int
g x = x * 4

f(g(3)) == (f <<< g)(3) == (\x -> (x * 4) + 1)(3) == 13
g(f(3)) == (f >>> g)(3) == (\x -> (x + 1) * 4)(3) == 16

class (Semigroupoid a) <= Category a where
  identity :: forall t. a t t
    -- In other words...
    -- function :: forall a. a -> a
    -- function a = a

(f >>> identity)(3) == f(3) == 4
(identity <<< f)(3) == f(3) == 4
