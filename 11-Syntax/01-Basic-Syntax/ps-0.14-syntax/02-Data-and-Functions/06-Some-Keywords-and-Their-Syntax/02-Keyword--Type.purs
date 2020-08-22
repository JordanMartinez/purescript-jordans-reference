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
