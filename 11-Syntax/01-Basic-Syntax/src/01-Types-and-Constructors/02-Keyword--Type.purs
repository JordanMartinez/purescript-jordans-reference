module Keyword.Type where

import Prelude

-- Syntax
type TypeAliasForCompileTime = RunTimeType

-- examples
type Age = Int
type ComplexFunction = Int -> (forall a b. a -> (forall c. c-> b) -> b)

{-
functionName :: ParamType1 -> ReturnType -}
functionName :: Age        -> String
            -- 'Age' is a more descriptive type name than 'Int'
functionName age = "body"

-- required to get this to compile correctly
data RunTimeType
