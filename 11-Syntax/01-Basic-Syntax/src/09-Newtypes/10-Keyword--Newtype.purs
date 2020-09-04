module Syntax.Basic.Newtype where

import Prelude

{-
The last data type keyword to explain here is `newtype`.

It is a compile-time-only type that only takes one type as its argument.

These are useful primarily for two reasons
  - They add a more meaningful name to another type (like type aliases).
  - They are compile-time-only types, so one does not incur runtime overhead
      (like type aliases).
  - They need to be constructed/deconstructed in code (unlike type aliases).
      When used with Phantom Types (see the `Design Patterns` folder), they can
      restrict how developers can use the type in very useful ways.
  - They enable one to define multiple type class instances for the same type.
-}

-- Syntax:
newtype NewTypeName = OnlyAllowsOneConstructor WhichOnlyTakesOneArgument_TheWrappedType

newtype NamedStringType = NamedStringType String

-- Pattern matching on a type defined via the `newtype` keyword works
-- just like a type defined via the `data` keyword.
-- You can expose the value wrapped by the newtype constructor
-- using a pattern match and/or `case _ of` syntax
patternMatching :: String
patternMatching =
  unwrap_a_newtype_via_pattern_match
    (wrap_a_value_via_constructor
      (unwrap_a_newtype_via_pattern_match
        (NamedStringType "example")
      )
    )

  where
    wrap_a_value_via_constructor :: String -> NamedStringType
    wrap_a_value_via_constructor str = NamedStringType str

    unwrap_a_newtype_via_pattern_match :: NamedStringType -> String
    unwrap_a_newtype_via_pattern_match (NamedStringType str) = str

    unwrap_a_newtype_via_case_of_syntax :: NamedStringType -> String
    unwrap_a_newtype_via_case_of_syntax = case _ of
      NamedStringType str -> str

-- Given the following code:
data Box a = Box a

class Show_ a where
  show_ :: a -> String

instance showBox :: (Show a) => Show (Box a) where
  show (Box a) = "Box(" <> show a <> ")"

-- What if we wanted to use a different type class instance for `Box` in some
-- situations, but not want to redefine `Box` as a new type with a different
-- name? We would do this:
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
