module Syntax.Basic.Typeclass.RequiredTypeClasses where

import Prelude

{-
Type classes can also have relationships with other type classes.

While the syntax looks hierarchial (i.e. parent-child relationships),
they aren't necessarily hierarchical. Rather, one should see them as
"conditional," which will be shown soon.
-}

-- Here's the syntax. It reads,
--    "Type 'a' can have an instance of the type class,
--    'ActualTypeClass.' However, it must also have an instance
--    of the type class, 'RequiredTypeClass.'"
class RequiredTypeClass a <= ActualTypeClass a where
  functionName :: a -> ReturnType

-- examples
-- the required type class of 'PlusFive'
class ToInt a where
  toInt :: a -> Int

class ToInt a <= PlusFive a where
  plusFive :: a -> Int

-- Writing an instance of ActualTypeClass does not require a constraint
-- from RequiredTypeClass in its type signature as this is already known due
-- to `ActualTypeClass`'s definition
instance ActualTypeClass TheType where
  functionName _ = "body"

-- example
instance ToInt Boolean where
  toInt true = 1
  toInt false = 0

instance PlusFive Boolean where
  plusFive b = 5 + toInt b

-- using it in code
test1 :: Boolean
test1 = (plusFive true) == 6

test2 :: Boolean
test2 = (plusFive false) == 5

-- Now let's explain what we mean by "conditional."
instance ToInt Int where
  -- notice how the required type class, `ToInt`, is using functions
  -- from its extension type class, `PlusFive`.
  toInt x = plusFive x

instance PlusFive Int where
  plusFive b = 5 + b

-- If a type implements instances for a number of type classes, its instances
-- can use any of these type class' functions/values. Still,
-- one of those instances will actually need to be independent from the
-- others (i.e. it doesn't use any functions/values from other type classes).



-- A type class can also combine multiple typeclasses. Sometimes,
-- they will add additional functionality or laws. Other times,
-- they simply combine two or more type classes into one.

class RequiredTypeClass1 a where
  fn1 :: a -> String

class RequiredTypeClass2 a where
  fn2 :: a -> String

-- Example of combining and adding additional functionality:
class (RequiredTypeClass1 a, RequiredTypeClass2 a {-, ... -}) <= TheTypeClass a where
  function :: a -> a

-- Example of only combining and not adding any additional functionality.
-- Sometimes, this will add another law; other times, it only combines
-- multiple type classes together:
class (RequiredTypeClass1 a, RequiredTypeClass2 a {-, ... -}) <= CombineOnly a

-- necessary to make file compile

type ReturnType = String
data TheType = TheType

class RequiredTypeClass a where
  fn :: a -> String

instance RequiredTypeClass TheType where
  fn _ = "body"
