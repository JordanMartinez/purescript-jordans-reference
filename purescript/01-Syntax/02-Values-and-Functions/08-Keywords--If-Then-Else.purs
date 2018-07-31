-- There's support for if-then-else statements
test :: Boolean -> String
test a = if a then "true" else "c"

-- can also be written like this, but why not pattern match at this point?
test :: forall a. (a -> Boolean) -> (a -> Boolean) -> a -> String
test condition1 condition2 a =
  if condition1 a then "first path"
  else if condition2 a then "second path"
  else "default path"
