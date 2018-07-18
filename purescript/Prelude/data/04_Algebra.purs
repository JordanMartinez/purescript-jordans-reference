class HeytingAlgebra a where
  conj :: a -> a -> a -- a1 && a2
  tt :: a             -- identity for &&

  disj :: a -> a -> a -- a1 || a2
  ff :: a             -- identity for ||

  implies :: a -> a -> a
  not :: a -> a

infixr 3 conj as &&
infixr 2 disj as ||

class (HeytingAlgebra a) <= BooleanAlgebra a where
