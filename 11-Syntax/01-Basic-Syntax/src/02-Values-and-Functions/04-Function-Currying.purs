module Syntax.Function.Currying where

import Prelude

-- Remember this function?
two_arg_function :: ParameterType1 -> ParameterType2 -> ReturnType
two_arg_function argument1 argument2 = bodyThatReturnsType

-- This is doing currying in the background. In reality, the function's
-- type signature is:
--    two_arg_function :: ParameterType1 -> (ParameterType2 -> ReturnType)

{-
In other words, give me an argument (ParameterType1) and I'll return a
  function (ParameterType2 -> ReturnType). If you give that function
  a parameter (ParameterType2), then it'll give you the ReturnType.
Since this happens in the background, we don't usually need to think about
  it, but it is an important distinction to make. as it creates the following
  Javascript code:

two_arg_function = function (ParameterType1) -> {
  return function (ParameterType2) -> {
    return bodyThatReturnsType;
  }
}
-}

type ParameterType1 = String
type ParameterType2 = String
type ReturnType = String

bodyThatReturnsType :: String
bodyThatReturnsType = "body"
