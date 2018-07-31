-- Given the following type classes, Eq and Ord

-- | Determines whether two instances of the same type are equal
class Eq a where
  eq :: a -> a -> Boolean


data Ordering = LT | GT | EQ

-- | Determines whether left is less than, greater than, or equal to right
class Ord a where
  compare :: a -> a -> Ordering

-- Original credit: @paf31
-- Link: https://github.com/paf31/24-days-of-purescript-2016/blob/master/3.markdown
-- Changes made: use meta-language to explain type class derivation syntax
--
-- Licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
--   https://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US
data Type
  = First TypeWithEqAndOrdInstance1
  | Second TypeWithEqAndOrdInstance2

-- To create instances of `Eq` and `Ord` for `Type` we'd usually write it by hand:
instance eqType :: Eq Type where
  eq (First a) (First b) = a eq b
  eq (Second a) (Second b) = a eq b
  eq _ _ = false

instance ordType :: Ord Type where
  compare (First a) (First a) = compare a b
  compare (First _) _ = LT
  compare (Second a) (Second b) = compare a b
  compare (Second _) _ = GT

-- Imagine if we added a Third constructor to Type. We'd need to account for
--   that type as well now.
-- This gets tedious and, fortunately, the compiler can figure out what these
-- should be based on the 'shape' of the types. To reduce the boilerplate,
-- we can just add `derive` in front of the instance and not implement
-- the function:

derive instance eqType :: Eq Type
derive instance ordType :: Ord Type

-- In other cases, we can use type class constraints to derive them:
data Box a = Box a
derive instance eqMaybe :: Eq a => Eq (Box a)
derive instance ordMaybe :: Ord a = Ord (Box a)

{-
Note: this works for only two reasons:

First, because TypeWithEqAndOrdInstance1 and TypeWithEqAndOrdInstance2
  both have an Eq and Ord instance. If one of these did not,
  then the compiler would not know how to create them.

Second, because we can only derive typeclasses from a few
  type classes:
  - Data.Eq (from `purescript-prelude`)
  - Data.Ord (from `purescript-prelude`)
  - Data.Functor (from `purescript-prelude`)
  - Data.Newtype (from `purescript-newtype`)
  - Data.Generic.Rep (from `purescript-generics-rep`)
-}
