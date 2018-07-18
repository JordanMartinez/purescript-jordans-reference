-- Basic Type classes

-- a type class definition...
class TypeClassName paramerType where
  functionName :: paramerType -> ReturnType

-- example
class ToInt a where
  toInt :: a -> Int

-- ... and its implementation for SomeType
instance typeClassNameDefinitionForSomeType :: TypeClassName SomeType where
  functionName type_ = ReturnType

instance toIntBoolean :: ToInt Boolean where
  toInt true = 1
  toInt false = 0

-- usage
(toInt true) == 0

-- Add a Type Class constraint to a function
constrainedFunction :: forall a. TypeClass a => a -> String

-- data List a
--   = Nil
--   | Cons a List

stringList_to_intList :: ToInt a => List a => List Int
stringList_to_intList Nil = Nil
stringList_to_intList (Cons head tail) = Cons ((toInt head) (stringList_to_intList tail))

-- Add multiple Type class constraints to a function
constrainedFunction2 :: forall a b. TypeClass1 a => TypeClass2 b => a -> b

-- Type class relationships

-- a type class that extends another type class
class SuperTypeClass a <= Class a where
  functionName :: a -> ReturnType

-- examples
class ToInt a <= PlusFive a where
  plusFive :: a -> Int

-- instance does not require constraint from SuperTypeClass
instance classType :: Class a where
  functionName :: a -> ReturnType


instance plusFiveBoolean :: PlusFive Boolean where
  plusFive b = 5 + toInt b

(plus5 true) == 6
