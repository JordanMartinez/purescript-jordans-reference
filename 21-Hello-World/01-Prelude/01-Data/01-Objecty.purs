-- This code does not compile, but syntax highlighting works on it.
class Show a where
  show :: a -> String

-- no function aliases

class Eq a where
  eq :: a -> a -> Boolean

  notEq :: a -> a -> Boolean
  notEq a1 a2 = not (eq a1 a2)

infix 4 eq as ==
infix 4 notEq as /=

data Ordering
  = LT
  | GT
  | EQ

class (Eq a) <= Ord a where
  compare :: a -> a -> Ordering

lessThan        :: forall a. Ord a => a -> a -> Boolean
lessThanOrEq    :: forall a. Ord a => a -> a -> Boolean
greaterThan     :: forall a. Ord a => a -> a -> Boolean
greaterThanOrEq :: forall a. Ord a => a -> a -> Boolean

-- NOT VALID SYNTAX, BUT MORE CONCISE!
infixl 4 methods as [< / <= / > / >=]

min :: forall a. Ord a => a -> a -> a
max :: forall a. Ord a => a -> a -> a

clamp   :: forall a. Ord a => lowerBound -> a -> upperBound -> value
between :: forall a. Ord a => lowerBound -> a -> upperBound -> Boolean

class (Ord a) <= Bounded a where
  top :: a
  bottom :: a
