module Syntax.Basic.Deriving.Newtype where

import Prelude

-- needed for deriving Newtype example
import Data.Newtype (class Newtype, over)

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
-- evaluation. Purescript gives us a way to derive, for newtypes, any instance
-- the boxed type implements, using the following syntax.
-- We use 'derive newtype' in front of the instance:

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

-- Another useful class we can derive from is found in the `newtype` library: purescript-newtype
class Newtype_ new old | new -> old

newtype EmailAddress3 = EmailAddress3 String

-- no need to indicate what "_" is since the compiler can figure it out
derive instance newtypeEmailAddress :: Newtype EmailAddress3 _

-- Data.Newtype provides other useful functions that lets us avoid manually
-- wrapping and unwrapping. For example:
upperEmail :: EmailAddress3 -> EmailAddress3
upperEmail = over EmailAddress3 prefixWithText

-- To see the full list, look at the package's docs:
-- https://pursuit.purescript.org/packages/purescript-newtype/3.0.0/docs/Data.Newtype
-- <--- End

-- needed to compile

-- | prefixes a given string with 'text'
prefixWithText :: String -> String
prefixWithText str = "text" <> str
