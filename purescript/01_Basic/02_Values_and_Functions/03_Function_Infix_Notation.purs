two_arg_function :: Int -> Int -> Int
two_arg_function x y | x < 0 = (x + 1) * (y + 14)
                     | otherwise = y + x

-- infix notation available via backticks
1 `two_arg_function` 2
-- becomes two_arg_function 1 2

type SomeType = forall a b. List a -> Box a

-- Infix Syntax
infix/infixl/infixr precedence functionName as functionAlias
infix/infixl/infixr precedence SomeType as typeAlias

-- Infix is all about where to put the parenthesis
-- where precedence is 0 = do first
--                     n = do after first but before last
--                     9 = do last
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
