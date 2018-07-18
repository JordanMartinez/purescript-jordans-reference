-- Note: Functor is in Data module, not Control module
class Functor f where
  map :: forall a b. (a -> b) -> f a -> f b

infixl 4 map as <$>

mapFlipped :: forall f a b. Functor f => f a -> (a -> b) -> f b
infixl 1 mapFlipped as <#>

void :: forall f a. Functor f => f a -> f Unit

voidRight :: forall f a b. Functor f => a -> f b -> f a
infixl 4 voidRight as <$


class Apply a where
  ap :: f (a -> b) -> f a -> f b

infix precedence ap as <*>

class Monad a where
  bind :: a -> (b -> m c) -> m c

infixl 7 bind as >>=
infixr 7 bind as =<<``

function :: (Monad a) => a -> ReturnType
-- these all do the same thing
function computation = computation >>= \value -> doSomethingWithValue value
function computation = computation >>= doSomethingWithValue
function computation = \value -> doSomethingWithValue value =<< computation
function computation = doSomethingWithValue =<< computation
function computation = do
    value <- computation
    anotherComputation {- produced value gets ignored... same as
    ignoredValue <- anotherComputation                        -}
    doSomethingWithValue value
