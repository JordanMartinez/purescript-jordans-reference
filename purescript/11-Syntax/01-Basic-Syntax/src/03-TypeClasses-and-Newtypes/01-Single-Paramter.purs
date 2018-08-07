module Syntax.Typeclass.SingleParameter where

import Prelude

-- Basic Type classes

-- a type class definition...
class TypeClassName paramerType where
  functionName :: paramerType -> ReturnType

-- Or the parameter type could be the return type:
class TypeClassName_ paramerType where
  fromString :: String -> paramerType

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
-- (toInt true) == 0

-- Type classes are useful for constraining types, which will be covered next.

-- necessary to make file compile
data ReturnType = ReturnType
data SomeType
