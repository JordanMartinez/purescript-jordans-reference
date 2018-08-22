module Syntax.Meta where

import Prelude

-- This file simply shows the syntax for how to define
-- values, functions, and basic data types. It gives
-- enough context for the `Kind` explanation next.

-- A zero-arg function cannot exist in FP programming*
-- Thus, it counts as a static value
valueName :: ValueType
valueName = "literal value or the result of some function call"

one_arg_function :: ParameterType -> ReturnType
one_arg_function argument = bodyThatReturnsType

-- * function :: Unit -> ReturnType is as close as one can get to a
-- zero-arg function in functional programming. Unit will be explained later
-- in the "Hello World" folder.

two_arg_function :: ParameterType1 -> ParameterType2 -> ReturnType
two_arg_function argument1 argument2 = bodyThatReturnsType

n_arg_function :: ParameterType1 -> {- ... ParameterTypeN -> ... -} ReturnType
n_arg_function arg1 {- arg2 arg3 ... argN -} = bodyThatReturnsType

function_using_inline_syntax :: (Int -> Int)
function_using_inline_syntax = (\x -> x + 4)

-- Declares a type that is used in a function's type signatures
-- and its implementations.
data Type_Used_In_Functions_Type_Signatures
  = Type_Implementation1
  | Type_Implementation2

example1 :: Type_Used_In_Functions_Type_Signatures
example1 = Type_Implementation1

example2 :: Type_Used_In_Functions_Type_Signatures
example2 = Type_Implementation2

-- A "box" that can store only Ints
data Box_That_Stores_Ints = Box Int

example3 :: Box_That_Stores_Ints
example3 = Box 4

example4 :: Int -> Box_That_Stores_Ints
example4 x = Box x

-- A "box" type that can store many different types
data Box_That_Stores aType = Box_Storing aType

example5 :: Box_That_Stores Int
example5 = Box_Storing 4

example6 :: Int -> Box_That_Stores Int
example6 x = Box_Storing x

-- The "forall someType." syntax will be explained later. It's needed here
-- to make this code compile
example7 :: forall someType. someType -> Box_That_Stores someType
example7 someType = Box_Storing someType

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
