module Syntax.Newtype where

import Prelude

-- Given the following code:
data Box a = Box a

class Show_ a where
  show_ :: a -> String

instance showBox :: (Show a) => Show (Box a) where
  show (Box a) = "Box(" <> show a <> ")"

{-
What if we wanted a slightly different instance for Show Box?
Newtypes are useful for creating a custom type class implementation
  for a given type. They do not incur overhead for wrapping/unwrapping
  the single type given to its constructor.
By wrapping types, they also indicate more information/context about them. -}

-- Syntax:
newtype NewTypeName = OnlyAllowsOneConstructor WhichOnlyTakesOneArgument_TheWrappedType

-- For example....
newtype Box2 a = Box2 (Box a)

instance showBox2 :: (Show a) => Show (Box2 (Box a)) where
  show (Box2 (Box a)) = "Box with value of [" <> show a <> "] inside of it."

-- Or, to add more context to a type...
newtype Name = Name String
newtype Age = Age Int
newtype Relationships = Relationships (List People)

-- Assuming all three above have a Show instance:
--
-- printPerson :: Name -> Age -> Relationships -> String
-- printPerson (Name n) (Age i) (Relationships l) =
--    "Name: " <> n <> ", Age: " <> show i <> ", Relationships: " <> show l

-- needed to compile

type WhichOnlyTakesOneArgument_TheWrappedType = String

data List a
data People
