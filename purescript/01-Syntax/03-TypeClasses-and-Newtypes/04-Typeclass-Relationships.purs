-- A type class can extend another type class to add more functionality.
-- Instances can use functions from `SuperTypeClass` in their `Class` instance
class SuperTypeClass a <= Class a where
  functionName :: a -> ReturnType

-- examples
-- the super type class of 'PlusFive'
class ToInt a where
  toInt :: a -> Int

class ToInt a <= PlusFive a where
  plusFive :: a -> Int

-- writing an instance of Class does not require a constraint from SuperTypeClass
-- as this is already known due to `Class`'s definition
instance classType :: Class a where
  functionName :: a -> ReturnType

-- example
instance toIntBoolean :: ToInt Boolean where
  toInt true = 1
  toInt false = 0

instance plusFiveBoolean :: PlusFive Boolean where
  plusFive b = 5 + toInt b

-- using it in code
(plus5 true) == 6
(plus5 false) == 5
