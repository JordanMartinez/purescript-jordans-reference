two_arg_function :: Int -> Int -> Int
two_arg_function x y | x < 0 = (x + 1) * (y + 14)
                     | otherwise = y + x

-- infix notation available via backticks
1 `two_arg_function` 2
-- becomes two_arg_function 1 2

-- Some types given here to make things easier...
type TypeAlias = forall a b. List a -> Box a
data DataType = Constructor Int Int

-- Infix Syntax where 'precedence' is a number (0..9)
infix/infixl/infixr precedence function/dataType/constructor as alias
-- or for type aliases:
infix/infixl/infixr precedence type TypeName as alias

-- Example
infixl 4 two_arg_function as >o_o>
infixr 4 DataType as :-->
infix  2 Constructor as ?->
infix  4 type TypeAlias as :$>

-- Infix is all about where to put the parenthesis as indicated by precedence:
-- precedence is 0 = group first
--               n = group after first but before last
--               9 = group last
--
-- Each type of infix will be shown by reducing it to its final call

-- make depth small (like a tree)
infix 0 functionName as alias
{-  1 alias 2  alias  3 alias 4
== (1 alias 2) alias (3 alias 4))
== (alias 1 2) alias (alias 3 4))
== functionName (functionName 1 2) (functionName 3 4)  -- desugared
-}

infixl 9 functionName as |>>|
{-    1 |>>| 2 |>>| 3   |>>| 4
==   (1 |>>| 2) |>>| 3  |>>| 4
==  ((1 |>>| 2) |>>| 3) |>>| 4
== |>>| ((1 |>>| 2) |>>| 3) 4
== |>>| (|>>| (1 |>>| 2) 3) 4
== |>>| (|>>| (|>>| 1 2) 3) 4
== functionName (functionName (functionName 1 2) 3) 4
-}

infixr 7 functionName as |<<|
{- 1 |<<|  2 |<<|  3 |<<| 4
== 1 |<<|  2 |<<| (3 |<<| 4)
== 1 |<<| (2 |<<| (3 |<<| 4))
== |<<| 1 (2 |<<| (3 |<<| 4))
== |<<| 1 (|<<| 2 (3 |<<| 4))
== |<<| 1 (|<<| 2 (|<<| 3 4))
== functionName 1 (functionName 2 (functionName 3 4))
-}
