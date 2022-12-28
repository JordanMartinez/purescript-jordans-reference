module Syntax.Basic.Deriving.NewtypedTypes where

import Prelude

-- License applies to a portion of this document --> Start

-- Original credit: @paf31
-- Link: https://github.com/paf31/24-days-of-purescript-2016/blob/master/4.markdown
-- Changes made: 
-- - use meta-language to explain newtype typeclass derivation syntax
-- - added example of `Box a`
-- - added `example1` and `example2`
--
-- Licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
--   https://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

-- Newtypes are used to wrap existing types with more information around them
newtype EmailAddress1 = EmailAddress1 String

-- However, defining type class instances for them
-- can get tedious:

instance Eq EmailAddress1 where
  eq (EmailAddress1 s1) (EmailAddress1 s2) = s1 == s2

-- same for Ord type class

-- same for other newtypes
newtype Phone = Phone String
newtype FirstName = FirstName String
-- etc...

-- This is boilerplate since we unpack the instance and delegate the function
-- to the wrapped type's implementation. It's also inefficient in terms of
-- evaluation. Purescript gives us a way to derive, for newtypes, any instance
-- the boxed type implements, using the following syntax.
-- We use 'derive newtype' in front of the instance:

newtype EmailAddress2 = EmailAddress2 String

derive newtype instance Eq EmailAddress2
derive newtype instance Eq Phone
derive newtype instance Eq FirstName

-- And now we can use it:
example1 :: EmailAddress2 -> EmailAddress2 -> Boolean
example1 email1 email2 = email1 == email2

-- If we have a type that takes a type paramter (i.e. the `a`)
data Box a = Box a

derive instance (Eq a) => Eq (Box a)

-- and we newtype that value
newtype SpecialBox a = SpecialBox (Box a)

-- then we need to add the `Eq a` constraint
-- before it will compile.
derive newtype instance (Eq a) => Eq (SpecialBox a)

example2 :: SpecialBox Int -> SpecialBox Int -> Boolean
example2 a b = a == b

-- <--- End
