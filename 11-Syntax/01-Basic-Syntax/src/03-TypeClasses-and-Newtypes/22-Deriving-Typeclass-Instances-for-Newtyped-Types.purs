module Syntax.Basic.Deriving.Newtype where

import Prelude

-- needed for 2nd approach
import Data.Newtype (class Newtype)

-- License applies to a portion of this document --> Start

-- Original credit: @paf31
-- Link: https://github.com/paf31/24-days-of-purescript-2016/blob/master/4.markdown
-- Changes made: use meta-language to explain newtype typeclass derivation syntax
--
-- Licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
--   https://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

-- Newtypes are used to wrap existing types with more information around them
newtype EmailAddress1 = EmailAddress1 String

-- However, defining type class instances for them
-- can get tedious:

instance eqEmailAddress1 :: Eq EmailAddress1 where
  eq (EmailAddress1 s1) (EmailAddress1 s2) = s1 == s2
-- same for Ord type class

-- same for other newtypes
newtype Phone = Phone String
newtype FirstName = FirstName String
-- etc...

-- This is boilerplate since we unpack the instance and delegate the function
-- to the wrapped type's implementation. It's also inefficient in terms of
-- evaluation. So, we have a better way to do this.
-- We use add 'derive newtype' in front of the instance:

-- 1st approach
newtype EmailAddress2 = EmailAddress2 String

derive newtype instance eqEmailAddress2 :: Eq EmailAddress2
derive newtype instance eqPhone :: Eq Phone
derive newtype instance eqFirstName :: Eq FirstName

-- <--- End

-- License applies to a portion of this document --> Start

-- Original credit: @paf31
-- Link: https://github.com/paf31/24-days-of-purescript-2016/blob/master/5.markdown
-- Changes made: use meta-language to explain Newtype typeclass derivation syntax
--
-- Licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
--   https://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

-- 2nd approach

-- Another approach is by using the `newtype` library: purescript-newtype
class Newtype_ new old | new -> old where
  wrap_ :: old -> new
  unwrap_ :: new -> old

newtype EmailAddress3 = EmailAddress3 String

-- no need to indicate what "_" is since the compiler can figure it out
derive instance newtypeEmailAddress :: Newtype EmailAddress3 _

-- Newtype provides other useful functions.
-- To see the full list, look at the package's docs:
-- https://pursuit.purescript.org/packages/purescript-newtype/3.0.0/docs/Data.Newtype
-- <--- End
