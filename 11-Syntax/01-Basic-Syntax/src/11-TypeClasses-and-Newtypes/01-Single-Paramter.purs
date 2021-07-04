module Syntax.Basic.Typeclass.SingleParameter where

import Prelude

-- Basic Type classes

-- a type class definition...
class TypeClassName parameterType where
  functionName :: parameterType -> ReturnType

-- Or the parameter type could be the return type:
class TypeClassName_ parameterType where
  fromString :: String -> parameterType

-- example
class ToInt a where
  toInt :: a -> Int

-- ... and its implementation for SomeType
instance TypeClassName SomeType where
  functionName type_ = ReturnType

-- ## Type Class Instance Name Requirement
--
-- Previously, naming type class instances was required.
-- As of `v0.14.2`, this requirement has been dropped as the compiler
-- generates the instance name instead now.
--
-- Below is an example of a named type class instance. You
-- may continue to see these while the ecosystem catches up.
-- The name typically follows this naming convention:
--    `classNameType1NameType2Name...TypeNName`.
{-
instance typeClassNameSomeType :: TypeClassName SomeType where
  functionName type_ = ReturnType
-}

-- The rest of this repo will use unnamed type class instances.


instance ToInt Boolean where
  toInt true = 1
  toInt false = 0

test :: Boolean
test = (toInt true) == 0

-- Type classes can also specify values:

class TypeClassDefiningValue a where
  value :: a

instance TypeClassDefiningValue Int where
  value = 42

-- Type classes usually only specify one function, but sometimes
-- they specify multiple functions and/or values:

class ZeroAppender a where
  append :: a -> a -> a
  zeroValue :: a

instance ZeroAppender Int where
  append = (+)
  zeroValue = 0

warning_orphanInstance :: String
warning_orphanInstance = """

Be aware of what an 'orphan instance' is.

See the following link for more info:
https://github.com/purescript/documentation/blob/master/errors/OrphanInstance.md
"""

{-
Note: Type class instances that use type aliases (i.e. the `type` keyword)
will fail to compile. The following code demonstrates this.
-}

-- Uncomment me and I'll become a compiler error
-- type Age = Int
-- instance TypeClassDefiningValue Age where
--   value = 2

-- Type classes are useful for constraining types, which will be covered next.

-- necessary to make file compile
data ReturnType = ReturnType
data SomeType
