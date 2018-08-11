data Box a = Box a

instance boxFunctor :: Functor Box where
  map :: forall a b. (a -> b) -> f a -> f b -- alias is "<$>"
  map (Box a) f = Box $ f a -- Box (f a)

instance boxApply :: Apply Box where
  apply :: f (a -> b) -> f a -> f b
  apply (Box f) (Box a) = Box (f a)


class (Apply f) <= Applicative f where
  pure :: forall a. a -> f a  -- wraps a value of a into a context of f

instance boxApplicative :: Applicative Box where
  pure :: forall a. a -> f a
  pure x = Box x

(pure 5) == (Box 5)
(pure (\x -> x + 1)) == (Box (\x -> x + 1))

-- synonmous with `map` from Functor but doesn't use that implementation
-- Useful in cases where `map` might be slower than `ap`
liftA1 :: forall f a b. Applicative f -> (a -> b) -> f a -> f b
liftA1 function fa = (pure function) <*> fa

(\x -> x + 1) <$> (Box 1) == (Box 2) == liftA1 (\x -> x + 1) (Box 1)

when :: forall m. Applicative m => Boolean -> m Unit -> m Unit
when true action = action
when false _ = pure unit

unless :: forall m. Applicative m => Boolean -> m Unit -> m Unit
unless b action = when (not b) action
