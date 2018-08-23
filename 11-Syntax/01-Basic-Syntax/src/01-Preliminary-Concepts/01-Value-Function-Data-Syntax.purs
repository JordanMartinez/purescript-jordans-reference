module Syntax.Meta where

-- This file simply shows enough syntax so that the
-- explanation on Kinds (next) makes sense.

one_arg_function :: ParameterType -> ReturnType
one_arg_function argument = bodyThatReturnsType

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
