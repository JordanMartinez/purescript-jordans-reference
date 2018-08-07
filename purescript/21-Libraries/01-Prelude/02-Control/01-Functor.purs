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
