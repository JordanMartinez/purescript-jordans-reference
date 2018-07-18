-- Basic Type classes

-- a type class definition...
class TypeClassName paramerType where
  functionName :: paramerType -> ReturnType

-- example
class Debug a where
  debug :: a -> String

-- ... and its implementation for SomeType
instance typeClassNameDefinitionForSomeType :: TypeClassName SomeType where
  functionName type_ = ReturnType

instance debugBoolean :: Debug Boolean where
  debug true = "true"
  debug false = "false"

-- usage
debug true = "true"
debug (2 > 5) = "false"

-- Add a constraint to a function
contrainedFunction :: forall a. TypeClass a => a -> String

contrainedFunction2 :: forall a b. TypeClass1 a => TypeClass2 b => a -> b

-- Type class relationships

-- a type class that extends another type class
class SuperTypeClass a <= Class a where
  functionName :: a -> ReturnType

-- examples
class Debug a <= IndentedDebug a where
  indentedDebug :: a -> String

-- an instance that adds a constraint on 'a' to insure it can use
-- methods from the SuperClass type class
instance classType :: SuperTypeClass a => Class a where
  functionName :: a -> ReturnType


instance indentedDebugBoolean :: IndentedDebug a where
  indentedDebug b = "   " <> debug b

indentedDebug (5 >= 5 + 3) == "   false"


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
