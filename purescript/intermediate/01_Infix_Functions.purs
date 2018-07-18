two_arg_function :: Int -> Int -> Int
two_arg_function x y | x < 0 = (x + 1) * (y + 14)
                     | otherwise = y + x

-- INFIX NOTATION
-- infix notation available via backticks
1 `two_arg_function` 2
-- becomes two_arg_function 1 2

-- Infix is all about where to put the parenthesis
-- infix/infixl/infixr precedence functionName as functionAlias
-- where precedence is 9 = do first
--                     n = do after first but before last
--                     0 = do last

-- make depth small (like a tree)
infix 0 functionName as functionAlias
{-  1 functionAlias 2  functionAlias  3 functionAlias 4
== (1 functionAlias 2) functionAlias (3 functionAlias 4))
== (functionAlias 1 2) functionAlias (functionAlias 3 4))
== functionAlias (functionAlias 1 2) (functionAlias 3 4)  -- desugared
(takes 3 funciton calls to reduce desugared call to final result)
-}
--
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
{- 1 |<<| 2 |<<| (3 |<<| 4)
== 1 |<<| (2 |<<| (3 |<<| 4))
== |<<| 1 (2 |<<| (3 |<<| 4))
== |<<| 1 (|<<| 2 (3 |<<| 4))
== |<<| 1 (|<<| 2 (|<<| 3 4))
== functionName 1 (functionName 2 (functionName 3 4))
-}
