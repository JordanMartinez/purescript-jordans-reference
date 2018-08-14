module Syntax.Notation.Do where

{-
In imperative programming, one often writes:
  x = 4
  y = x + 4
  z = toString x
  print z

Since each line depends on the line before it,
  this implies sequential computation, or Monads. We have "do" notation
  to imitate this style of code
-}

-- example:
-- computation >>= (\result -> newComputationUsing result)
-- get4 >>= (\x -> add4To x >>= (\y >>= toString y >>= (\z -> print z)))
-- The above code can be changed to a much more readible...
-- do
--   x    <- get4
--   y    <- add4To x
--   z    <- toString y {-
--   unit <- print z -- actual type
--   _    <- print z -- what we'd write since we don't care for it -}
--           print z -- or better yet, just omit the "_ <-" syntax altogether


-- We can also use 'let' if we want to define some value
-- that doesn't require using bind. Note that there is
-- no corresponding "in" here
-- do
--   x <- get4
--   let y = x + 4
--   z <- toString y
--   print z
-- -- desugars into
-- get4 >>= (\x ->
--     let y = x + 4
--     in toString y >>= (\z -> print z)
--   )
