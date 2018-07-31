-- This file simply shows the syntax for how to define
-- values and types

-- A zero-arg function cannot exist in FP programming*
-- Thus, it counts as a static value
valueName :: ValueType
valueName = "3"

one_arg_function :: ParameterType -> ReturnType
one_arg_function argument = bodyThatReturnsType

-- * function :: Unit -> ReturnType is as close as one can get to a
-- zero-arg function in functional programming. Unit will be explained later
-- in the Prelude library.

two_arg_function :: ParameterType1 -> ParameterType2 -> ReturnType
two_arg_function argument1 argument2 = bodyThatReturnsType

n_arg_function :: ParameterType1 -> {- ... ParameterTypeN -> ... -} ReturnType
n_arg_function arg1 {- arg2 arg3 ... argN -} = bodyThatReturnsType

-- INLINE FUNCTIONS
\arg1 arg2 argN -> bodyOfFunction

-- example
\x = x.value
\int1 int2 = int1 + int2
--
                                         {- function -}
function_that_takes_a_function :: Int -> (Int -> String) -> String
function_that_takes_a_function i f = f i

-- example
function_that_takes_a_function 3 (\x -> show x)
