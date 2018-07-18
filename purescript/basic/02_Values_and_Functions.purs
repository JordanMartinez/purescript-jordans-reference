valueName :: ValueType
valueName = "3"

--
one_arg_function :: ParameterType -> ReturnType
one_arg_function argument = returnType

two_arg_function :: ParameterType1 -> ParameterType2 -> ReturnType
two_arg_function argument1 argument2 = returnType

n_arg_function :: ParameterType1 -> {- ... ParameterTypeN -> ... -} ReturnType

-- Inline functions
\arg1 arg2 argN -> body of function
\x = x.value == _.value
--
                                         {- function -}
function_that_takes_a_function :: Int -> (Int -> String) -> String
function_that_takes_a_function i f = f i

-- example
function_that_takes_a_function 3 (\x -> show x)

--
universallyQuantifiedTypes :: forall a. ArgThatMayUse a -> ReturnType {-
universallyQuantifiedTypes ::           ArgThatMayUse a -> ReturnType -- Compiler error -}

-- Useful Functions
-- Composition
f :: Int -> Int
f x = x + 1

g :: Int -> Int
g x = x * 4

f(g(a)) == (f <<< g)(a) -- Haskell: (f . g)(a)
g(f(a)) == (f >>> g)(a) -- Haskell: (g . f)(a)


-- abbreviated form of a function
-- when the argument will be appended to the body
abbreviatedFunction :: Int -> Int
abbreviatedFunction {- i -} = 3 + {- i -}
abbreviatedFunction = 3 +

(abbreviatedFunction 4) == 7

-- using where
whereFunction :: Int -> Int -> String
whereFunction arg1 arg2 = madeUpFunction arg1
  where
    madeUpFunction :: Int -> String
    madeUpFunction i = show (arg2 - i)

-- using let..in syntax
let_in_function :: Int -> Int -> String
let_in_function arg1 arg2 =
  let binding = expression
  in bodyThatUses binding
