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


class (Apply m) <= Bind m where
  bind :: forall a b. m a -> (a -> m b) -> m b

instance boxBind :: Bind Box where
  bind :: forall a b. m a -> (a -> m b) -> m b
  bind (Box a) function = function a

infixl 1 bind as >>=
infixr 1 bindFlipped as =<<

-- Syntax Sugar
computation `bind` (\value ->   function value)
computation >>=     \value ->   function value
computation >>= {- \value -> -} function -- value
computation >>=                 function

   (\value ->    function value) `bindFlipped` computation
   (\value ->    function value)          =<<  computation
{- (\value -> -} function {- value) -}    =<<  computation
                 function                 =<<  computation

computation >>= \a -> computeX a >>= \_ -> computeB >>= \b -> pure (b + 1)
do
  a <- computation
  _ <- computeX a  {- or as more commonly seen..
       computeX a  -}
  b <- computeB
  pure (b + 1)

join :: forall a m. Bind m => m (m a) -> m a

ifM :: forall a m. Bind m => m Boolean -> m a -> m a -> m a
ifM condition truePath falsePath =
  if condition >>= \boolean_ -> if boolean_ truePath else falsePath

-- Rather than returnsMA >>= \a -> returnsMB >>= \b -> returnsMC
composeKleisli :: forall a b c m. Bind m => (a -> m b) -> (b -> m c) -> a -> m c
composeKleisli returnsMB returnsMC a = returnsMB a >>=    returnsMC   {- or...
composeKleisli returnsMB returnsMC a = returnsMB a >>= \b returnsMC b -}

infixr 1 composeKleisli as >=>
infixr 1 composeKleisliFlipped as <=<
