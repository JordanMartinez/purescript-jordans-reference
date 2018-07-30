-- Original credit: @paf31
-- Link: https://github.com/paf31/24-days-of-purescript-2016/blob/master/3.markdown
-- Changes made: use meta-language to explain type class derivation syntax
--
-- Licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
--   https://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US
data Type
  = First TypeWithEqAndOrdInstance1
  | Second TypeWithEqAndOrdInstance2

-- To create type classes for `Eq` and `Ord`, we'd usually write it by hand:

instance eqType :: Eq Type where
  eq (First a) (First b) = a == b
  eq (Second a) (Second b) = a == b
  eq _ _ = false

instance ordType :: Ord Type where
  compare (First a) (First a) = compare a b
  compare (First _) _ = LT
  compare (Second a) (Second b) = compare a b
  compare (Second _) _ = GT

-- Fortunately, the compiler can figure out what these should be based on
-- the 'shape' of the types. To reduce the boilerplate, we can just add `derive`
-- in front of the instance and not implement the function:

derive instance eqType :: Eq Type
derive instance ordType :: Ord Type

-- These work only because TypeWithEqAndOrdInstance1 and 
-- TypeWithEqAndOrdInstance2 both have an Eq and Ord instance.
-- If one of these did not, then the compiler would not know how to
-- create them.

-- In other cases, we can use constraTypeWithEqAndOrdInstance2s to derive them:
derive instance eqMaybe :: Eq a => Eq (Maybe a)
derive instance ordMaybe :: Ord a = Ord (Maybe a)
