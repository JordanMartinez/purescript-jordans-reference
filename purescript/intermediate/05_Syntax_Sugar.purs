-- Work in progress!

dollar :: (a -> b) -> a -> b
dollar f a = f a

infix precendence dollar as $

print (5 + 5) == print $ 5 + 5

class Functor a where
  map :: f a -> (a -> b) -> f b

infix precedence map as <$>

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
