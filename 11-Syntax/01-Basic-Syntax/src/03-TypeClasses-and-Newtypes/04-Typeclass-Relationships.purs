module Syntax.Typeclass.SuperTypeClasses where

import Prelude

-- A type class can extend another type class to add more functionality.
-- Instances can use functions from `SuperTypeClass` in their `Class` instance
class SuperTypeClass a <= ActualTypeClass a where
  functionName :: a -> ReturnType

-- examples
-- the super type class of 'PlusFive'
class ToInt a where
  toInt :: a -> Int

class ToInt a <= PlusFive a where
  plusFive :: a -> Int

-- writing an instance of ActualTypeClass does not require a constraint
-- from SuperTypeClass in its type signature as this is already known due
-- to `ActualTypeClass`'s definition
instance actualTypeClass :: ActualTypeClass TheType where
  functionName _ = "body"

-- example
instance toIntBoolean :: ToInt Boolean where
  toInt true = 1
  toInt false = 0

instance plusFiveBoolean :: PlusFive Boolean where
  plusFive b = 5 + toInt b

-- using it in code
test1 :: Boolean
test1 =
  (plusFive true) == 6

test2 :: Boolean
test2 =
  (plusFive false) == 5

-- A type class can also extend multiple typeclasses:

class (SuperTypeClass1 a, SuperTypeClass2 a {-, ... -}) <= TheTypeClass a where
  function :: a -> a

-- necessary to make file compile
type ReturnType = String
data TheType = TheType

class SuperTypeClass a where
  fn :: a -> String

instance superTypeClassTheTypeInstance :: SuperTypeClass TheType where
  fn _ = "body"

class SuperTypeClass1 a where
  fn1 :: a -> String

class SuperTypeClass2 a where
  fn2 :: a -> String
