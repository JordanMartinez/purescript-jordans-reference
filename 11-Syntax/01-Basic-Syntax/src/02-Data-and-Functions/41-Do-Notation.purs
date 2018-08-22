module Syntax.Notation.Do where

import Prelude

{-
WARNING: THe following code requires understanding what
a Monad is and the `bind`/>>= function. Come back to this
 only after you understand those two functions.

In imperative programming, one often writes some sequential code like:
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

do1_1Line :: Box Unit
do1_1Line = get4 >>= (\x -> add4To x >>= (\y -> toString y >>= (\z -> print z)))
-- which is better understood as
do1_indented :: Box Unit
do1_indented =
  get4 >>= (\x ->
    -- only call `add4To x` if `get4` actually produces something
    add4To x >>= (\y ->
      toString y >>= (\z ->
        print z
      )
    )
  )
-- which is better understood and more readable as
do1_do_notation :: Box Unit
do1_do_notation = do
  x     <- get4
  -- only call `add4To x` if `get4` actually produces something
  y     <- add4To x
  z     <- toString y
  -- last line in do notation must not end with `value <- expression`
  -- but should just end in `expression`
  print z

do2_indented :: Box Unit
do2_indented =
  get4 >>= (\x ->
      -- This let-in syntax is not very readable either here...
      let y = x + 4
      in toString y >>= (\z -> print z)
    )
-- but we can write it better as
do2_do_notation :: Box Unit
do2_do_notation = do
  x <- get4
  let y = x + 4   -- no need to have a corresponding `in` statement
  z <- toString y
  print z

do_ignore_syntax_indented :: Box Unit
do_ignore_syntax_indented =
  get4 >>= (\x -> takeValueAndIgnoreResult x >>= (\_ -> print x))

do_ignore_syntax :: Box Unit
do_ignore_syntax = do
  x     <- get4
  unit_ <- takeValueAndIgnoreResult x
  -- ... can be written...
  _     <- takeValueAndIgnoreResult x
  -- ... since we don't use its return value.
  -- We can remove the "_ <-" syntax completely and write:
  takeValueAndIgnoreResult x

  print x

do_full_syntax :: Box Unit
do_full_syntax = do
  x <- get4
  takeValueAndIgnoreResult x
  let y = x + 4
  z <- toString y
  -- last line in do notation must not end with `value <- expression`
  -- but should just end in `expression`
  print z

-- needed to make this file compile
data Box a = Box a

derive instance boxFunctor :: Functor Box

instance boxApply :: Apply Box where
  apply (Box f) (Box a) = Box (f a)

instance boxApplicative :: Applicative Box where
  pure a = Box a

instance boxBind :: Bind Box where
  bind (Box a) f = f a

get4 :: Box Int
get4 = Box 4

add4To :: Int -> Box Int
add4To i = Box (i + 4)

toString :: Int -> Box String
toString i = Box (show i)

takeValueAndIgnoreResult :: forall a. a -> Box Unit
takeValueAndIgnoreResult _ = Box unit

print :: forall a. a -> Box Unit
print _ = Box unit
