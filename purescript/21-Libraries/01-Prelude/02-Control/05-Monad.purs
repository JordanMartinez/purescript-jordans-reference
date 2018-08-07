data Box a = Box a

instance boxFunctor :: Functor Box where
  map :: forall a b. (a -> b) -> f a -> f b -- alias is "<$>"
  map (Box a) f = Box $ f a -- Box (f a)

instance boxApply :: Apply Box where
  apply :: f (a -> b) -> f a -> f b
  apply (Box f) (Box a) = Box (f a)

instance boxApplicative :: Applicative Box where
  pure :: forall a. a -> f a
  pure x = Box x

instance boxBind :: Bind Box where
  bind :: forall a b. m a -> (a -> m b) -> m b
  bind (Box a) function = function a


class (Applicative m, Bind m) <= Monad m

-- Monadic version of Applicative's when
whenM :: forall m. Monad m => m Boolean -> m Unit -> m Unit

-- Monaic version of Applicative's unless
unlessM :: forall m. Monad m => m Boolean -> m Unit -> m Unit


-- Functions that can be used to implement
-- Monad's super type classes: Functor and Apply

-- `map`/<$> for a monad, but without using <$>
-- So one can use this to implement a Functor's <$> implementation
liftM1 :: forall m a b. Monad m => (a -> b) -> m a -> m b

-- `map`/<$> for a monad, but without using <$>
-- So one can use this to implement a Functor's <$> implementation
ap :: forall m a b. Monad m => m (a -> b) -> m a -> m b

-- example
data Box2 a = Box2 a

instance box2Applicative :: Applicative Box2 where
  pure = Box2

instance box2Bind :: Bind Box2 where
  bind (Box2 a) function = function a

-- Because there is an instance of Applicative and Bind for Box2
-- we can implement Functor and Apply for Box2 using a combination
-- of Applicative and Bind methods

instance box2Functor :: Functor Box2 where
  map = liftM1

instance box2Apply :: Apply Box2 where
  apply = ap
