module Syntax.Basic.InfixNotation.Extended where

-- Original credit: @paf31
-- Link: https://github.com/paf31/24-days-of-purescript-2016/blob/master/1.markdown
-- Changes made: use meta-language to explain syntax of extended infix notation
--
-- Licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
--   https://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

-- regular infix
-- function1 :: Type1 -> Type2 -> ReturnType
-- function1 a b = ...
--
-- a `function1` b

-- Given a function with this signature...
function2 :: String -> String -> String -> String
function2 first second third = "result"

example :: String
example = "second" `function2 "first"` "third"

-- This can be useful for combining function if it reads well
--    list1 `combineUsing concat` list2
-- But it can also quickly lead to unreadable code
-- Be careful and selective when using it.
