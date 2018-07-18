valueName :: ValueType
valueName = "3"

-- BASIC FUNCTIONS
one_arg_function :: ParameterType -> ReturnType
one_arg_function argument = returnType

two_arg_function :: ParameterType1 -> ParameterType2 -> ReturnType
two_arg_function argument1 argument2 = returnType

n_arg_function :: ParameterType1 -> {- ... ParameterTypeN -> ... -} ReturnType

-- INLINE FUNCTIONS
\arg1 arg2 argN -> body of function
\x = x.value == _.value
--
                                         {- function -}
function_that_takes_a_function :: Int -> (Int -> String) -> String
function_that_takes_a_function i f = f i

-- example
function_that_takes_a_function 3 (\x -> show x)
