-- License applies to a portion of this document --> Start

-- Original credit: @paf31
-- Link: https://github.com/paf31/24-days-of-purescript-2016/blob/master/4.markdown
-- Changes made: use meta-language to explain newtype class derivation syntax
--
-- Licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
--   https://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

-- Newtypes are used to wrap existing types with more information around them
newtype EmailAddress = EmailAddress String

-- However, defining type class instances for them
-- can get tedious:

instance eqEmailAddress :: Eq EmailAddress where
  eq (EmailAddress s1) (EmailAddress s2) = s1 == s2
-- same for Ord type class

-- same for other newtypes
newtype Phone = Phone String
newtype FirstName = FirstName String
-- etc...

-- This is boilerplate since we unpack the instance and delegate the function
-- to the wrapped type's implementation. It's also inefficient in terms of
-- evaluation. So, we have a better way to do this.

-- 1st approach

derive newtype instance eqEmailAddress :: Eq EmailAddress
derive newtype instance eqPhone :: Eq Phone
derive newtype instance eqFirstName :: Eq FirstName

-- <--- End

-- License applies to a portion of this document --> Start

-- Original credit: @paf31
-- Link: https://github.com/paf31/24-days-of-purescript-2016/blob/master/5.markdown
-- Changes made: use meta-language to explain newtype class derivation syntax
--
-- Licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
--   https://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

-- 2nd approach

-- Another approach is by using the `newtype` library: purescript-newtype
class Newtype new old | new -> old where
  wrap :: old -> new
  unwrap :: new -> old

newtype EmailAddress = EmailAddress String

-- no need to indicate what "_" is since compiler can figure it out
derive instance newtypeEmailAddress :: Newtype EmailAddress _

-- Other functions that Newtype provides:
-- - over / overF
--   (similar to Functor's map but polymorphic on its return type)
-- - under/ underF
--   (takes a value, raises it into a Newtype context,
--    applies a function that takes a newtype argument,
--    and unwraps the resulting value)
-- - collect
-- - traverse
upperEmail :: EmailAddress -> EmailAddress
upperEmail = over EmailAddress toUpper

-- polymorphic example
newtype EmailAddress2 = EmailAddress2 String
derive instance newtypeEmailAddress2 :: Newtype EmailAddress2 _

upperEmail2 :: EmailAddress -> EmailAddress2
upperEmail2 = over EmailAddress toUpper

byDomain :: String -> Array EmailAddress -> Maybe EmailAddress
byDomain domain = overF EmailAddress (find (contains (wrap domain)))
-- <--- End
