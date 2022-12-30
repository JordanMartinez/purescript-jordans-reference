module Syntax.Basic.Keyword.Type where

-- Syntax
type TypeAliasForCompileTime = RunTimeType

-- Example
type ComplexFunction = Int -> (forall a b. a -> (forall c. c-> b) -> b)

-- and then use it here:
-- someFunction :: String -> ComplexFunction -> ReturnType

-- One could also do this...
----------------------
type Age = Int

{-
functionName :: ParamType1 -> ReturnType -}
functionName :: Age        -> String
            -- 'Age' is a more descriptive type name than 'Int'
functionName age = "body"

----------------------
-- ... but to do the above, one should use `newtype` instead,
--   which is explained later.

-- a type alias can also take a type parameter
type ConvertAToString a = (a -> String)

example :: forall a. a -> ConvertAToString a -> String
example a convertAToString = convertAToString a

-- There's a difference between these two types
type ConvertBToString1 b = (b -> String)
type ConvertBToString2 = forall b. b -> String

bToString1 :: forall b.  b  -> ConvertBToString1 b       -> String
bToString1 value toString = toString value

bToString2 :: forall b.  b  -> ConvertBToString2         -> String                      {-
bToString2 :: forall b1. b1 -> (forall b2. b2 -> String) -> String                      -}
bToString2 b1 b2ToString = 
  """
  Whenever a type alias is used, the alias is replaced with its
  right-hand side. Thus, using `b2ToString b1` here to try
  to produce a `String` value would result in a compiler error
  because the type for `b1` is different than `b2`.
  """

-- Type aliases also have kind signatures. The above examples have
-- implicit kind signatures. The below example has an explicit one:
data Pair a b = Pair a b

-- kind signature (implicit): Type -> Type
-- reason: the `a` needs to be defined before we have a "concrete" type alias
type IntAnd a = Pair Int a

type IntAnd_ExplicitKindSignature :: Type -> Type
type IntAnd_ExplicitKindSignature a = Pair Int a

type SomeTypeAndInt :: Type -> Type
type SomeTypeAndInt a = Pair a Int

-- required to get this to compile correctly
data RunTimeType
