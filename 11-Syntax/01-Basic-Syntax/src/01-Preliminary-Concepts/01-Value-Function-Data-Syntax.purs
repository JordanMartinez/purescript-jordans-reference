module Syntax.Meta where

-- This file simply shows enough syntax so that the
-- explanation on Kinds (next) makes sense.
--
-- entity_name :: Type Signature
-- entity_name = definition

integer_value :: Int
integer_value = 5

string_value :: String
string_value = "this is text"

-- | In other words...
-- | ```
-- | var one_arg_function = function (argument) {
-- |   return bodyThatReturnsType;
-- | };
-- | ```
one_arg_function :: ParameterType -> ReturnType
one_arg_function argument = bodyThatReturnsType

-- Below is an Algebraic Data Type. We'll explain these more later.
--
-- Here, we declare a type called `Type_Used_In_Functions_Type_Signatures`,
-- which has two implementations. The type is used in an entity's
-- Type Signatures while the implementations are used in an entity's
-- definition
data Type_Used_In_Functions_Type_Signatures
  = Constructor1_of_Type
  | Constructor2_of_Type

example1 :: Type_Used_In_Functions_Type_Signatures
example1 = Constructor1_of_Type

example2 :: Type_Used_In_Functions_Type_Signatures
example2 = Constructor2_of_Type

-- A "box" that can store only Ints
data Box_That_Stores_Ints = Box Int

example3 :: Box_That_Stores_Ints
example3 = Box 4

example4 :: Int -> Box_That_Stores_Ints
example4 x = Box x

-- A "box" type that can store values of another type.
data Box_That_Stores anotherType = Box_Storing anotherType

example5 :: Box_That_Stores Int
example5 = Box_Storing 4

example6 :: Int -> Box_That_Stores Int
example6 x = Box_Storing x

-- Look! An outer Box that stores an inner Box, that stores an Int
example7 :: Box_That_Stores (Box_That_Stores Int)
example7 = Box_Storing (Box_Storing 4)

-- The "forall someType." syntax will be explained later. It's needed here
-- to make this code compile. You can read example8's type signature as
-- "If you give me a value that has a given type, which I'll refer to as
-- `someType`, then I can give you back a Box that stores a value of
-- `someType`."
example8 :: forall someType. someType -> Box_That_Stores someType
example8 valueWhoseTypeIs_'someType' = Box_Storing valueWhoseTypeIs_'someType'

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
