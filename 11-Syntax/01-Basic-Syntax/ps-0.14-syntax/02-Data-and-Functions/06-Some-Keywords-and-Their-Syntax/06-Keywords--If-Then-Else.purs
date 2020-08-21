module Syntax.Basic.Keyword.IfThenElse where

-- There's support for if-then-else statements
test1 :: Boolean -> String
test1 condition = if condition then "true path" else "false path"

-- Or write it like this
test2 :: Boolean -> String
test2 condition =
  if condition
  then "true path"
  else "false path"

-- Or this
test3 :: Boolean -> String
test3 condition =
  if
    condition
  then
    "true path"
  else
    "false path"

-- One can also write nested if-then-else-if-then-else statements
test4 :: forall a. (a -> Boolean) -> (a -> Boolean) -> a -> String
test4 condition1 condition2 a =
  if condition1 a then "first path"
  else if condition2 a then "second path"
  else "default path"
