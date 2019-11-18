module Syntax.Modification.RebindableDo where

-- I assume you are already familiar with how 'do notation' desugars.
-- If not, go read through that explanation again.

import Prelude

-- We'll use a qualified import to make it easier to see
-- when we're referring to the REAL 'bind` defined
-- in Prelude and not our customized version.
import Control.Bind as NormalBind

-- Given this monad (type class instances are at bottom of file)
data Box a = Box a

{-
"do notation" works by
- desugaring a line with the "<-" notation via the "bind" function within scope
- desugaring a line without the "<-" notation via the "discard" function within scope

Thus, to change how these two things desugar, we change what 'bind' and 'discard'
mean via a let binding or a where clause.
However, since `discard = void $ bind`, we almost never need to remap `discard`
to a different definition. While one could, I don't know why one would.

Note: rebinding 'do' will produce the following compiler warnings:
"Name `bind` was shadowed."
"Name `discard` was shadowed."
-}

-- While 'bind' has been imported above, we don't have to use that 'bind' explicitly
normalBind_let_in :: Box Int
normalBind_let_in =
  let
    bind = NormalBind.bind

    -- this isn't necessary, but we'll include it here anyway.
    discard = NormalBind.discard
  in do
    three <- Box 3
    Box unit
    two <- Box 2
    pure (three + two)


-- Redefining them in a where clause is more readable.
normalBind_where :: Box Int
normalBind_where = do
  three <- Box 3
  two <- Box 2
  pure (three + two)
  where
    bind = NormalBind.bind

    -- Again, this isn't necessary, but we'll include it here anyway.
    discard = NormalBind.discard

-- Similar to `ado notation`, we can rebind `do notation` to use a different
-- implementation than the default `bind`.
plusBind_where :: Box Int
plusBind_where = do
  three <- Box 3
  two <- Box 2
  pure (three + two)
  where
    bind boxedArg aToMB =
      NormalBind.bind boxedArg aToMB >>= \result -> pure (result + 1)        {-
      ^ Warning: using `bind` here would lead to an infinite loop during
        runtime that will stack overflow. We need to refer to the normal
        bind using `NormalBind.bind` or `>>=`                                   -}

    -- discard is not included here because the next closest discard definition
    -- in scope is the one imported via "import Prelude"

{-
The above code's graph reduction is:
do
  three <- Box 3
  two <- Box 2
  pure (three + two)

bind (Box 3) (\three ->
  bind (Box 2) (\three ->
    pure (three + two)
  )
)

let firstBindResult = NormalBind.bind (Box 3) (\x -> pure (x + 1))
in NormalBind.bind firstBindResult (\three ->
  bind (Box 2) (\three ->
    pure (three + two)
  )
)

let firstBindResult =                         (\3 -> pure (3 + 1))
in NormalBind.bind firstBindResult (\three ->
  bind (Box 2) (\three ->
    pure (three + two)
  )
)

let firstBindResult =                         (      pure 4     )
in NormalBind.bind firstBindResult (\three ->
  bind (Box 2) (\three ->
    pure (three + two)
  )
)

let firstBindResult = Box 4
in NormalBind.bind firstBindResult (\three ->
  bind (Box 2) (\three ->
    pure (three + two)
  )
)

NormalBind.bind (Box 4) (\three ->
  bind (Box 2) (\two ->
    pure (three + two)
  )
)
                        (\4 ->
  bind (Box 2) (\two ->
    pure (4 + two)
  )
)

bind (Box 2) (\two ->
  pure (4 + two)
)

let secondBindResult = NormalBind.bind (Box 2) (\y -> pure (y + 1))
in NormalBind.bind secondBindResult (\two ->
  pure (4 + two)
)

let secondBindResult =                         (\2 -> pure (2 + 1))
in NormalBind.bind secondBindResult (\two ->
  pure (4 + two)
)

let secondBindResult =                         (      pure 3      )
in NormalBind.bind secondBindResult (\two ->
  pure (4 + two)
)

let secondBindResult = Box 3
in NormalBind.bind secondBindResult (\two ->
  pure (4 + two)
)

NormalBind.bind (Box 3) (\two ->
  pure (4 + two)
)

                        (\3 ->
  pure (4 + 3)
)

pure (4 + 3)

Box 7

-}

{-
This example would require using a monad that supports MonadWriter.
One could rebind `bind` to log the argument before continuing the computation.

For example, someting like:
  bind computation aToMB =
    computation >>= (\result ->
      -- log what the argument was here via `tell`
      tell result >>= (\_ ->
        -- then continue the computation like normal
        aToMB result
      )
-}

-- Type class instances

instance functor :: Functor Box where
  map :: forall a b. (a -> b) -> Box a -> Box  b
  map f (Box a) = Box (f a)

instance apply :: Apply Box where
  apply :: forall a b. Box (a -> b) -> Box a -> Box  b
  apply (Box f) (Box a) = Box (f a)

instance bind :: Bind Box where
  bind :: forall a b. Box a -> (a -> Box b) -> Box b
  bind (Box a) f = f a

instance applicative :: Applicative Box where
  pure :: forall a. a -> Box a
  pure a =  Box a

instance monad :: Monad Box

instance showBox :: (Show a) => Show (Box a) where
  show (Box a) = "Box(" <> show a <> ")"
