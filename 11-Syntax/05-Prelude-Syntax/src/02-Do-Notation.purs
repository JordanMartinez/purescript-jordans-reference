module Syntax.Prelude.Notation.Do where

import Prelude

{-
In imperative programming, one often writes some sequential code like:
  x = 4
  y = x + 4
  z = toString x
  print z

Since each line depends on the line before it,
  this implies sequential computation, or Monads. We have "do" notation
  to imitate this style of code

Recall the type signature of `bind`...
      bind :: m a -> (a -> m b) -> m b
... and that ">>=" is an alias for `bind`

Thus, these two expressions are the same:
    bind computation (\result -> newComputationUsing result)
    computation >>= (\result -> newComputationUsing result)
-}

do1_bind :: Box Unit
do1_bind =
  bind get4 (\x ->
    bind (add4To x) (\y ->
      bind (toString y) (\z ->
        print z
      )
    )
  )
-- which is better understood by replacing `bind` with ">>=" as
do1_alias :: Box Unit
do1_alias =
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
  y     <- add4To x
  z     <- toString y
  -- last line in do notation must not end with `value <- computation`
  -- but should just end in `computation`
  print z

-- Just like in regular functions, we could use 'let-in` syntax
do2_bind :: Box Unit
do2_bind =
  bind get4 (\x ->
      let y = x + 4
      in bind (toString y) (\z -> print z)
    )
-- which is better understood by replacing `bind` with ">>=" as
do2_alias :: Box Unit
do2_alias =
  get4 >>= (\x ->
      -- While replacing 'bind' with '>>=' is better,
      -- this let-in syntax is still not very readable here...
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

do3_ignoreValue_bind :: Box Unit
do3_ignoreValue_bind =
  bind get4 (\x ->
    bind (takeValueAndIgnoreResult x) (\_ {- this underscore is 'unit' -} ->
      print x
    )
  )
-- which is better understood by replacing `bind` with ">>=" as in
do3_ignoreValue_alias :: Box Unit
do3_ignoreValue_alias =
  get4 >>= (\x -> takeValueAndIgnoreResult x >>= (\_ -> print x))
-- gets turned into...
do3_ignoreValue_do_notation :: Box Unit
do3_ignoreValue_do_notation = do
  x     <- get4
  _     <- takeValueAndIgnoreResult x

  print x

do4_discard_bind :: Box Unit
do4_discard_bind =
  bind (Box unit) (\unit_ ->
    bind (Box unit) (\unit__ ->
      print 5
    )
  )
-- which is better understood by replacing `bind` with ">>=" as in
do4_discard_alias :: Box Unit
do4_discard_alias =
  (Box unit) >>= (\unit_ ->
    (Box unit) >>= (\unit__ ->
        print 5
    )
  )
-- can be written as...
do4_discard_syntax :: Box Unit
do4_discard_syntax = do                                           {-
  When we omit the "binding <-" syntax, as in

      four <- Box 4   -- line 1
              Box a   -- line 2
      five <- Box 5   -- line 3

  the compiler translates `line 2` to
      "discard (Box a) (\_ -> (Box 5) >>= (\five -> ... ))"

  This is fine if the argument to the next function would be Unit

      four <- Box 4
      unit <- Box unit  -- here, we could omit the "unit <-" syntax
      five <- Box 5
              Box unit -- same thing

  If we had accidentally written code that amounted to this...

      four <- Box 4
              Box 10 -- notice how there is no "10 <-" fragment
      five <- Box 5

  ... the compiler would notify us that we had discarded a non-unit value
      (i.e. 10):
        "Could not find instance of Discard for Int"

  Why does it do this? To highlight that we have accidentally dropped the
  result of the computation. If you want to intentionally drop a result,
  use `void $ monad` or the "_ <- computation" syntax                         -}
  x <- (Box 5)
  (Box unit) -- since it returns unit, it's ok to use discard here

  -- rather than write this...
  map (\_ -> unit) (Box 5)

  -- or even this...
  (\_ -> unit) <$> (Box 5)

  -- we write this:
  void $ Box 5

  print 5

do_full_syntax :: Box Unit
do_full_syntax = do
  x <- get4

  _ <- takeValueAndIgnoreResult x

  (Box unit)
  void $ takeValueAndIgnoreResult x

  let y = x + 4
  z <- toString y
  -- last line in do notation must NOT end with `value <- expression`
  -- but should just end in `expression`
  print z

-- needed to make this file compile
data Box a = Box a

derive instance functorBox :: Functor Box

instance applyBox :: Apply Box where
  apply (Box f) (Box a) = Box (f a)

instance applicativeBox :: Applicative Box where
  pure a = Box a

instance bindBox :: Bind Box where
  bind (Box a) f = f a

get4 :: Box Int
get4 = Box 4

add4To :: Int -> Box Int
add4To i = Box (i + 4)

toString :: Int -> Box String
toString i = Box (show i)

takeValueAndIgnoreResult :: forall a. a -> Box a
takeValueAndIgnoreResult a = Box a

print :: forall a. a -> Box Unit
print _ = Box unit
