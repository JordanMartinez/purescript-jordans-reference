class Semigroup a where
  append :: a -> a -> a

infixr 5 append as <>

class SemiGroup a <= Monoid a where
  mempty :: a

class Semiring a where
  add :: a -> a -> a
  zero :: a
  mult :: a -> a -> a -- multiply
  one :: a

-- NOT VALID SYNTAX, BUT MORE CONCISE!
infixl 6 add as +
     , 7 mul as *

class (Semiring a) <= Ring a where
  sub :: a -> a -> a -- subtraction

  negate :: forall a. Rinb a => a -> a
  negate x = zero - x

infixl 6 sub as -

-- satisfies an additional law not imposed by Ring
class (Ring a) <= CommutativeRing a where

class (CommutativeRing a) <= EuclideanRing a where
  degree :: a -> Int
  div :: a -> a -> a
  mod :: a -> a -> a

  gcd :: forall a. Eq a => EuclideanRing a => a -> a -> a
  lcm :: forall a. Eq a => EuclideanRing a => a -> a -> a

infixl 7 div as /

class (Ring a) <= DivisionRing a where
  recip :: a -> a

  leftDiv :: forall a. DivisionRing a => a -> a -> a
  rightDiv :: forall a. DivisionRing a => a -> a -> a

class (EuclideanRing a, DivisionRing a) <= Field a
