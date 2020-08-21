module Syntax.Basic.Function.Currying where

-- Remember this function?
one_arg_function_syntax_sugar :: ParameterType -> ReturnType
one_arg_function_syntax_sugar argument = bodyThatReturnsType

-- it's syntax sugar for
one_arg_function_no_syntax_sugar :: Function ParameterType ReturnType
one_arg_function_no_syntax_sugar argument = bodyThatReturnsType

-- Which means this function...
two_arg_function0 :: ParameterType1 -> ParameterType2 -> ReturnType
two_arg_function0 argument1 argument2 = bodyThatReturnsType

-- is in a "curried" form. In reality, it's
two_arg_function1 :: ParameterType1 -> (ParameterType2 -> ReturnType)
two_arg_function1 argument1 argument2 = bodyThatReturnsType
-- or without syntax sugar
two_arg_function2 :: Function ParameterType1 (ParameterType2 -> ReturnType)
two_arg_function2 argument1 argument2 = bodyThatReturnsType
-- and removing the last one
two_arg_function3 :: Function ParameterType1 (Function ParameterType2 ReturnType)
two_arg_function3 argument1 argument2 = bodyThatReturnsType

{-
In other words, give me an argument (ParameterType1) and I'll return a
  function (ParameterType2 -> ReturnType). If you give that function
  a parameter (ParameterType2), then it'll give you the ReturnType.
Since this happens in the background, we don't usually need to think about
  it, but it is an important distinction to make as it creates the following
  Javascript code:

two_arg_function = function (ParameterType1) -> {
  return function (ParameterType2) -> {
    return bodyThatReturnsType;
  }
}
-}

-- necessary to compile

type ParameterType = String
type ParameterType1 = String
type ParameterType2 = String
type ReturnType = String

bodyThatReturnsType :: String
bodyThatReturnsType = "body"
