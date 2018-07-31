-- Original credit: @paf31 / @kritzcreek
-- Link: https://github.com/paf31/24-days-of-purescript-2016/blob/master/23.markdown
-- Changes made: use meta-language to explain syntax and give a very simple example
--
-- Licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
--   https://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US

-- Sometimes, when writing code, we sort of know what we should write
-- but not all of what we should write.

-- In such cases, we can use a hole and the compiler might be able
-- to suggest which function / value we should use:

-- syntax
?placeholderName -- put this in place of the function/value
                 -- whose type you're unsure of

intToString :: Int -> String
intToString x = ?function x
