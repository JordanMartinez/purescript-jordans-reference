module Keyword.IfThenElse where

-- There's support for if-then-else statements
test1 :: Boolean -> String
test1 condition = if condition then "true path" else "false path"

-- can also be written like this, but why not pattern match at this point?
test2 :: forall a. (a -> Boolean) -> (a -> Boolean) -> a -> String
test2 condition1 condition2 a =
  if condition1 a then "first path"
  else if condition2 a then "second path"
  else "default path"
