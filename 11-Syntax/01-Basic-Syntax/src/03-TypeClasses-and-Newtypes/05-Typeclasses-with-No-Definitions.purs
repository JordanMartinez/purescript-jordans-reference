module Syntax.Basic.Typeclasses.NoDefinition where

import Prelude

{-
Some type classes do not declare any functions or values in their definition.

This usually occurs for one of two reasons:

1. They specify another law on top of the previous type class.

For example, the `ToString` type class converts any type's value into a String.
-}
class ToString a where
  toString :: a -> String

-- However, it doesn't specify how big or small that String should be.
-- So, we can extend it with another type class that adds a law on how
-- long the String can be before it's too long.

class (ToString a) <= ToString_50CharLimit a -- no "where" keyword here!
  -- no function or value here!

-- Assuming we've already written the `ToString` instance,
-- to create an instance for the above type class, we'd write:
instance toString_50CharLimitInt :: ToString_50CharLimit Int -- no "where" keyword!
-- This instance means the developer who wrote it asserts that
-- the given type, Int, satisfies the given law.

{-
A developer making a library that specifies such a type as this has
documented through the types what users of that library should expect:
  calling 'toString a' will produce a String that is 50 chars or less.

Note:
Since the following are true...
  - `toString` defines a function `toString`
  - Int has an instance of `ToString`
  - `ToString_50CharLimit` adds a law to `ToString`'s `toString` function
  - Int has an instance of `ToString_50CharLimit`

... then a function that uses `show Int` will still output a String
that is 50 chars or less, even if the Int is not constrained to
the `ToString_50CharLimit` type class.

Since the latter imposes more restrictions on the former, the former must
also abide by those restrictions.

If one wanted to avoid this, they should define a new type class that
adds a function specifically for that:

  class (ToString a) <= ToString_50CharLimt_2 a where
    toString_limited a = -- implementaton that uses 'show'
-}

-- 2. Some type classes merely combine two or more type classes together:

data Box a = Box a

class Wrap a where
  wrapIntoBox :: a -> Box a

class Unwrap a where
  unwrapFromBox :: Box a -> a

class (Wrap a, Unwrap a) <= Boxable a

-- To create an instance of `Boxable`, we need to define instances
-- for Wrap, Unwrap, and Boxable, even if `Boxable` doesn't require
-- you to implement any functions/values.

instance wrapInt :: Wrap Int where
  wrapIntoBox i = Box i

instance unwrapInt :: Unwrap Int where
  unwrapFromBox (Box i) = i

useBoxable :: forall a. (Boxable a) => a -> a
useBoxable a = unwrapFromBox (wrapIntoBox a)

-- Necessary to compile

instance toStringInt :: ToString Int where
  toString = show
