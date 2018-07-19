data Box a = Box a

-- Note: a function ending in "Flipped" means the order
--   of its two arguments are flipped. Thus, the full type signature
--   will not be included

-- Note: Functor is in Data module, not Control module
--   because it changes values that are wrapped in some 'f' context
--   and doesn't dictate the flow of the code and its control
--   (e.g. if statements)
-- It is still included here because
--   it's the type class upon which all others are founded
class Functor f where
  map :: forall a b. (a -> b) -> f a -> f b

-- example
instance boxFunctor :: Functor Box where
  map :: forall a b. (a -> b) -> f a -> f b
  map (Box a) f = Box $ f a -- Box (f a)

infixl 4 map as <$>
infixl 1 mapFlipped as <#>

-- example
((\x -> x + 1) `map`       (Box 1))       == (Box 2)
((\x -> x + 1) <$>         (Box 1))       == (Box 2)

((Box 1)      `mapFlipped` (\x -> x + 1)) == (Box 2)
((Box 1)      <#>          (\x -> x + 1)) == (Box 2)

voidRight :: forall f a b. Functor f => a -> f b -> f a
infixl 4 voidRight as <$
-- example
(3    <$ (Box 1)) == (Box 3)
(Unit <$ (Box 1)) == (Box Unit)

void :: forall f a. Functor f => f a -> f Unit

-- example
(void (Box 1)) == (Unit <$ (Box 1)) == (Box Unit)



--
class (Functor f) <= Apply f where
  apply :: f (a -> b) -> f a -> f b

infixl 4 apply as <*>

instance boxApply :: Apply Box where
  apply :: f (a -> b) -> f a -> f b
  apply (Box f) (Box a) = Box (f a)

-- example
(Box (\x -> x + 1)) <*> (Box 3) == (Box 4)

applyFirst :: forall a b f. Apply f => f a -> f b -> f a
infixl 4 applyFirst as <*

applySecond :: forall a b f. Apply f => f a -> f b -> f b
infixl 4 applySecond as *>

lift2 :: forall a b c f. Apply f
  => (a -> b -> c) -- Type Constructor
  -> f a           -- first arg
  -> f b           -- second arg
  -> f c           -- third arg

-- Prereq
data Person = PersonConstructor Name Age Height
-- in code
lift3 PersonConstructor nameArg ageArg heightArg
-- is the same as what is more commonly seen
PersonConstructor <$> nameArg <*> ageArg <*> heightArg -- and other args



--
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

-- Syntax Sugar using `ado`
box :: Box Int
box :: Box 0

ado
  in function box
-- function <$> box

ado
  binding <- box
  in function binding
-- (\binding -> function binding) <$> box

ado
  one   <- box1
  two   <- box2
  three <- box3
  in function one three two
-- (\one two three -> function one three two) <$> box1 <*> box2 <*> box3

ado
  one  <-    box1
  {- _ <- -} box2 -- skipped
             box3
  four <-    box4
  in function one four
-- (\one _ _ four -> function one four) <$> box1 <*> box2 <*> box3 <*> box4

ado
  one <- box1
  let y = one + 1
  in function one y
-- (\one ->
--   let y = one + 1
--   in function one y
-- ) <*> box1

-- all of them now
ado
  one <- box1
  let y = one + 1
  box2
  three <- box3
  in function one y three
-- (\one ->
--   let y = one + 1
--   in \_ three -> function one y three
--  ) <$> box1 <*> box2 <*> box3



-- Thus...
PersonConstructor <$> nameArg <*> ageArg <*> heightArg
-- is the same as..
ado
  name <- nameArg
  age <- ageArg
  height <- heightArg
  in PersonConstructor name age height



--
class (Apply m) <= Bind m where
  bind :: forall a b. ma -> (a -> m b) -> m b

instance boxBind :: Bind Box where
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
composeKleisli returnsMB returnsMC a = returnsMB a >>= {- \b -} returnsMC -- b

infixr 1 composeKleisli as >=>
infixr 1 composeKleisliFlipped as <=<


--
class (Applicative m, Bind m) <= Monad m

-- `map`/<$> for a monad, but without using <$>
-- So one can use this to implement a Functor's <$> implementation
liftM1 :: forall m a b. Monad m => (a -> b) -> m a -> m b

-- `map`/<$> for a monad, but without using <$>
-- So one can use this to implement a Functor's <$> implementation
ap :: forall m a b. Monad m => m (a -> b) -> m a -> m b

-- Monadic version of Applicative's when
whenM :: forall m. Monad m => m Boolean -> m Unit -> m Unit

-- Monaic version of Applicative's unless
unlessM :: forall m. Monad m => m Boolean -> m Unit -> m Unit

-- example
data Box a = Box a

instance boxFunctor :: Functor Box where
  map = liftM1

instance boxApply :: Apply Box where
  apply = ap

instance boxApplicative :: Applicative Box where
  pure = Box

instance boxBind :: Bind Box where
  bind (Box a) function = function a

-- because there is an instance of Applicative and Bind for Box
-- we can also implement Functor and Apply for Box using a combination
-- of Applicative and Bind methods
