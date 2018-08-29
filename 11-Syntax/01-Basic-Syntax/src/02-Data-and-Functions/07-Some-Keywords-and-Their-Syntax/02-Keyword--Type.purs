module Keyword.Type where

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

-- required to get this to compile correctly
data RunTimeType
