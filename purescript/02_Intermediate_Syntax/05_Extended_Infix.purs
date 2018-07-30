-- Original credit: @paf31
-- Link: https://github.com/paf31/24-days-of-purescript-2016/blob/master/1.markdown
-- Changes made: use meta-language to explain syntax of extended infix notation
--
-- Licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
--   https://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

-- regular infix
function1 :: Type1 -> Type2 -> ReturnType
function1 a b = ...

a `function1` b

-- extended infix
function2 :: forall a. (a -> a -> a) -> a -> a -> a
function2 f a b = ...

a `function2 f` b

-- Be careful about using this style of coding
-- as it can quickly lead to unreadable code
