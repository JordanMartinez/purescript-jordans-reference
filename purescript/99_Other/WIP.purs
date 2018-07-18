-- Partial

-- zero type arguments
-- used to make compile-time assertions about our code/functions
class Partial

-- UNSAFELY converts partial function into regular function
unsafePartial :: forall a. (Partial => a) -> a

-- Derive instance for some type classes
-- For now, only works for Eq, Ord, Functor (maybe more?)
data Foo = Foo Int String

derive instance eqFoo :: Eq Foo
