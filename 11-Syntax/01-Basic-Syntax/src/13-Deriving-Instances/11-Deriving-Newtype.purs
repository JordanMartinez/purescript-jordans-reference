module Syntax.Basic.Deriving.ClassNewtype where

import Prelude

import Data.Newtype (class Newtype, over)

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

-- no need to indicate what "_" is (hint: it's `String`)
-- since the compiler can figure it out
derive instance Newtype EmailAddress3 _

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
