-- A type class can have more than just a single parameter as its type.

-- Syntax
class MultiParameterTypeClass type1 type2 {- typeN -} where
  functionName :: type1 -> type2 -> {- typeN -> -} ReturnType

-- Again, a parameter could be the return type
class MultiParameterTypeClass type1 type2 {- typeN -} where
  functionName :: Int -> type1 -> {- typeN -> -} type2

-- example (not practical, but gets the idea across)
class ConvertFromAToB a b where
  convert :: a -> b

instance convertBoolToString :: ConvertFromAToB Boolean String where
  convert true = "true"
  convert false = "false"

instance convertBoolToInt :: ConvertFromAToB Boolean Int where
  convert true = 1
  convert false = 0

toString :: forall a. ConvertFromAToB a String => a -> String
toString a = convert a

(toString true) == "true"
