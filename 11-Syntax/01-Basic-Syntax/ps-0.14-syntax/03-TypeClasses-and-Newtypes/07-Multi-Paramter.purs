module Syntax.Basic.Typeclass.MultiParameters where

import Prelude

-- A type class can have more than just a single parameter as its type.

-- Syntax
class MultiParameterTypeClass1 type1 type2 {- typeN -} where
  functionName1 :: type1 -> type2 -> {- typeN -> -} ReturnType

-- Again, a parameter could be the return type
class MultiParameterTypeClass2 type1 type2 {- typeN -} where
  functionName2 :: Int -> type1 -> {- typeN -> -} type2

-- example (not practical, but gets the idea across)
class ConvertFromAToB a b where
  convert :: a -> b

instance convertFromAToBBooleanString :: ConvertFromAToB Boolean String where
  convert true = "true"
  convert false = "false"

instance convertFromAToBBooleanInt :: ConvertFromAToB Boolean Int where
  convert true = 1
  convert false = 0

toString :: forall a. ConvertFromAToB a String => a -> String
toString a = convert a

test :: Boolean
test = (toString true) == "true"

-- necessary to make file compile
type ReturnType = String
