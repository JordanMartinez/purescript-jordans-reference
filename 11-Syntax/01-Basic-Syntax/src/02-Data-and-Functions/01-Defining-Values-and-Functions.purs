module Syntax.Basic.ValuesAndFunctions where

import Prelude

-- This file simply shows the syntax for how to define
-- values and types

-- A zero-arg function cannot exist in FP programming*
-- Thus, it counts as a static value
literal_value :: ValueType
literal_value = "literal value"

-- * function :: Unit -> ReturnType is as close as one can get to a
-- zero-arg function in functional programming. Unit will be explained later
-- in the "Hello World" folder.

result_of_function :: Int
result_of_function = 4 + 5 -- 9

one_arg_function :: ParameterType -> ReturnType
one_arg_function argument = bodyThatReturnsType

two_arg_function :: ParameterType1 -> ParameterType2 -> ReturnType
two_arg_function argument1 argument2 = bodyThatReturnsType

n_arg_function :: ParameterType1 -> {- ... ParameterTypeN -> ... -} ReturnType
n_arg_function arg1 {- arg2 arg3 ... argN -} = bodyThatReturnsType

function_using_inline_syntax :: (Int -> Int)
function_using_inline_syntax = (\x -> x + 4)

                                         {- function  -}
function_that_takes_a_function :: Int -> (Int -> String) -> String
function_that_takes_a_function i f = f i

                                           {- function -}
function_that_returns_a_function :: Int -> (Int -> Int)
function_that_returns_a_function x = (\y -> y + x)

-- Note: a "higher order function" either takes a function as an argument
-- or returns a function

-- examples
takes_a_function :: String
takes_a_function =
  function_that_takes_a_function 3 (\x -> show x)
  -- show: converts `Int` to `String`
  -- outputs: "3"

returns_a_function :: Int
returns_a_function =
  (function_that_returns_a_function 4) 10
  -- outputs: 14
  -- reason: (\10 -> 10 + 4)

-- necessary to make this file compile

type ValueType = String
type ParameterType = String
type ParameterType1 = String
type ParameterType2 = String
type ReturnType = String

bodyThatReturnsType :: ReturnType
bodyThatReturnsType = "return value"

bodyOfFunction :: ReturnType
bodyOfFunction = "body of inline function"
