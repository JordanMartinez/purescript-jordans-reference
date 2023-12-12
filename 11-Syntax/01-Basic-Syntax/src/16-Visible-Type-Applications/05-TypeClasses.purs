module Syntax.Basic.VisibleTypeApplications.TypeClasses where

-- When it comes to functions, VTA-support is opt-in.
-- But for type classes, VTAs are always supported for the
-- type variables in the class head.

class MyClass typeVariableInClassHead where
  toString :: typeVariableInClassHead -> String

instance MyClass String where
  toString x = x

instance MyClass Int where
  toString _ = "foo"

-- The type of `toString` is `forall @a. MyClass a => a -> String`.
-- So, we can choose which instance to use by using VTAs

stringExample1 = toString @String "foo"
intExample1 = toString @Int 1

-- Again, the type signature of `multi` here is
-- `multi :: forall @a @b @c. Multi a b c => a -> b -> c -> String`
class Multi a b c where
  multi :: a -> b -> c -> String

instance Multi Int Int String where
  multi _ _ _ = "string"

instance Multi Int Int Int where
  multi _ _ _ = "int"

-- So, using it here looks like
stringExample2 = multi @Int @Int @String 1 2 "3"
intExample2 = multi @Int @Int @Int 1 2 3

-- Before PureScript 0.15.13, the following type class was invalid.

class UniqueValue a where
  uniqueValue :: String

-- The compiler uses the arguments passed to a type class member
-- (e.g. `uniqueValue`) to determine which types specify the
-- type variables in the type class head. But because the
-- type variable in the class head (i.e. `a`) never appears in the
-- type signature of `uniqueValue`, there was no way for the compiler
-- to figure out which instance should be used. So, it would fail
-- with a compiler error. Thus, the compiler prevented one
-- from even writing such a class.

-- Now that we have VTAs, this class is only valid because the compiler
-- assumes one will use VTAs to select the instance.
-- The full type signature of `uniqueValue` is now
--    `uniqueValue :: forall @a. UniqueValue a => String`

instance UniqueValue Int where
  uniqueValue = "Int"
instance UniqueValue String where
  uniqueValue = "String"

stringExample3 :: String
stringExample3 = uniqueValue @String

intExample3 :: String
intExample3 = uniqueValue @Int

-- VTAs are useful because they allow us to specify which type class 
-- instance to use in a concise way. This is more apparent when
-- we use type classes to derive functions from their members.

-- Moreover, now that VTAs are supported, `Proxy` arguments 
-- are no longer needed. `Proxy` arguments are covered in 
-- more detail in the type-level programming syntax folder.
