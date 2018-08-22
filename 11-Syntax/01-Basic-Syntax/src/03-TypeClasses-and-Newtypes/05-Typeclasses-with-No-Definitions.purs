module Syntax.Typeclasses.NoDefinition where

import Prelude

{-
Some type classes do not declare any functions or values in their definition.

This usually occurs for one of two reasons:

1. They are specify another law on top of the previous type class.

For example, the `ToString` type class converts any instance into a String.
-}
class ToString a where
  toString :: a -> String

-- However, it doesn't specify how big or small that String should be.
-- So, we can extend it with another type class that adds a law on how
-- long the String can be before it's too long.

class (ToString a) <= ToString_50CharLimit a -- no where keyword here!
  -- no function or value here!

{-
A developer making a library that specifies such a type as this has
documented through the types what users of that library should expect:
calling 'toString a' will produce a String that is 50 chars or less.

Note: Since `toString` is the method used here, even if one uses a function
that includes a type constrained to `ToString`....
    f :: forall a. (ToString a) => a -> String
... it will still produce a String with 50 chars or less because the same
method is being used for both `ToString` and `ToString_50CharLimit`.
Since the latter imposes more restrictions on the former, the former must
also abide by those restrictions.
If one wanted to avoid this, they should specify a new function in
`ToString_50CharLimit` that manipulates the `ToString`'s `toString` function:

class (ToString a) <= ToString_50CharLimit a where
  toString_limited a = to50OrLess $ show a
-}

-- 2. Some type classes merely combine two or more type classes together:

data Box a = Box a

class Wrap a where
  wrapIntoBox :: a -> Box a

class Unwrap a where
  unwrapFromBox :: Box a -> a

class (Wrap a, Unwrap a) <= Boxable a

-- To create an instance of `Boxable`, we need to define instances
-- for Wrap and Unwrap. Once both of those are satisfied, then
-- Boxable is also satisfied

instance wrapInt :: Wrap Int where
  wrapIntoBox i = Box i

instance unwrapInt :: Unwrap Int where
  unwrapFromBox (Box i) = i

useBoxable :: forall a. (Boxable a) => a -> a
useBoxable a = (unwrapFromBox <<< wrapIntoBox) a
