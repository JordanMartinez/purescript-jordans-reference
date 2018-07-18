-- INFIX NOTATION
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
-- where precedence is 9 = do first
--                     n = do after first but before last
--                     0 = do last
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


-- Useful Functions
-- Composition
f :: Int -> Int
f x = x + 1

g :: Int -> Int
g x = x * 4

f(g(a)) == (f <<< g)(a) -- Haskell: (f . g)(a)
g(f(a)) == (f >>> g)(a) -- Haskell: (g . f)(a)
