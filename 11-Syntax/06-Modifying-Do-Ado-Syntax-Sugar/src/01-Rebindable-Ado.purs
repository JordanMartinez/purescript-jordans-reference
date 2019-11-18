module Syntax.Modification.RebindableAdo where

-- I assume you are already familiar with how 'ado notation' desugars.
-- If not, go read through that explanation again.

import Prelude

-- We'll use a qualified import to make it easier to see
-- when we're referring to the REAL 'apply' and 'map' as defined
-- in Prelude and not our customized versions.
import Data.Functor as NormalMap
import Control.Apply as NormalApply

-- Given this monad (type class instances are at bottom of file)
data Box a = Box a

{-
"ado notation" works by
- desugaring the "<-" notation via the "apply" function within scope
- desugaring the "in <function>" notation via the "map" function within scope

Thus, to change how these two things desugar, we change what 'apply' and 'map'
mean via a let binding or a where clause.

Note: rebinding 'ado' will produce the following compiler warnings:
"Name `apply` was shadowed."
"Name `map` was shadowed."
-}

-- This is how we would use "rebindable syntax" via a 'let binding'
-- to write normal "ado notation" (i.e. apply and map are unchanged)
normalApply_let_in :: Box Int
normalApply_let_in =
  let
    {-
    These do not work

    -- Compiler error: "The value of apply is undefined here,
    -- so this reference is not allowed."
    -- The compiler thinks 'apply' is defined as itself.
    apply :: forall f a b. Apply f => f (a -> b) -> f a -> f b
    apply = apply
    -}

    -- These do work.
    -- apply :: forall f a b. Apply f => f (a -> b) -> f a -> f b
    apply = NormalApply.apply

    -- map :: forall f a b. Functor f => (a -> b) -> f a -> f b
    map = NormalMap.map
  in ado
    three <- Box 3
    two <- Box 2
    in three + two

-- Redefining them in a 'where' clause is more readable.
normalApply_where :: Box Int
normalApply_where = ado
  three <- Box 3
  two <- Box 2
  in three + two
  where
    apply :: forall f a b. Apply f => f (a -> b) -> f a -> f b
    apply = NormalApply.apply

    map :: forall f a b. Functor f => (a -> b) -> f a -> f b
    map = NormalMap.map

-- Now, let's change how `<-` gets desugared by actuallying changing how
-- `apply` is defined. Whenever `apply` gets called, it will add 1
-- to the result of apply by using `map (_ + 1)`.
plusApply_where :: Box Int
plusApply_where = ado
  three <- Box 3
  two <- Box 2
  in three + two
  where
    -- Our modified 'apply' will add 1 each time it gets called.
    -- To support this modification, we'll modify the type signature
    -- to force this to only work on boxes of Ints.
    apply :: forall f. Apply f => f (Int -> Int) -> f Int -> f Int
    apply boxedF boxedArg =
      NormalMap.map (_ + 1) (NormalApply.apply boxedF boxedArg)         {-
                             ^ Warning: if we used `apply` here instead of
                               `NormalApply.apply`, we would have
                               created an infinite loop                  -}

    -- Since `map` isn't defined here, the closest "in-scope" definition
    -- is the `map` that is imported from Data.Functor in the 'import Prelude'
    -- line.

{-
Here's the graph reduction of the above `plus1Apply` code:
ado
  three <- Box 3
  two <- Box 2
  in three + two

((\three two -> three + two)
  `NormalMap.map` Box 3)
  `apply` Box 2 -- i.e. our modified apply

(NormalMap.map (\three two -> three + two) (Box 3)) `apply` Box 2

Box (\two -> 3 + two) `apply` Box 2

apply (Box (\two -> 3 + two)) (Box 2)

-- now reduces 'apply' with our modified definition
-- Note that "<*>" refers to the normal apply definition.

map (_ + 1) (NormalApply.apply (Box (\two -> 3 + two)) (Box 2))
map (_ + 1) (                  (Box (\2   -> 3 + 2  ))        )
map (_ + 1) (                  (Box (        5      ))        )
map (_ + 1) (Box 5)
Box 6
-}

-- Applicative types allow us to use things like `*>` and `<*`
-- Why not rebind ado notation to use that for apply?
realWorldExample :: Box Int
realWorldExample = ado
  three <- Box 3
  two <- Box 2
  in three + two
  where
    -- Our modified `apply` will run the normal computation
    -- and then return the result, Box 4, rather than the actual computation.
    -- A better example would be using "ado notation" to validate
    -- data and use something like, `boxedF <*> boxedArg <* pure unit`,
    -- to reduce boilerplate.
    apply :: forall f. Applicative f => f (Int -> Int) -> f Int -> f Int
    apply boxedF boxedArg = boxedF <*> boxedArg *> pure 4

{-
The above graph reduction is:
ado
  three <- Box 3
  two <- Box 2
  in three + two

(\three two -> three + two)
  `NormalMap.map` (Box 3)
  `apply` (Box 2)

NormalMap.map (\three two -> three + two) (Box 3) `apply` (Box 2)

Box (\two -> 3 + two) `apply` (Box 2)

-- here we use replace 'apply' with our modified definition

Box (\two -> 3 + two) <*> (Box 2) *> Box 4
NormalApply.apply (Box (\two -> 3 + two)) <*> (Box 2) *> Box 4
                  (Box (\    -> 3 + 2  ))             *> Box 4
                  (Box          5       )             *> Box 4
                  applyRight (Box 5) (Box 4)

applyRight (Box 5) (Box 4)
(\left right -> right) <$> (Box 5) <*> (Box 4)
Box 4
-}

-- I don't have an example of remapping `map` because I couldn't find a way
-- to do that without getting a compiler error.
-- Still, this file demonstrates how to do this.

{-
Lastly, one can change `apply` multiple times throughout the 'ado notation'
if one were to use lets. For example,

ado
  -- apply not set, so use normal definition
  a <- someA
  let apply = definition -- apply now uses modified version
  b <- someB
  c <- someC
  let apply = definition2 -- apply now uses a second modified version
  d <- someD
  in computation a b c d

For readability, this is not recommended. I only include it here to be
complete in this explanation.

-}

-- Type class instances

instance functorBox :: Functor Box where
  map :: forall a b. (a -> b) -> Box a -> Box  b
  map f (Box a) = Box (f a)

instance applyBox :: Apply Box where
  apply :: forall a b. Box (a -> b) -> Box a -> Box  b
  apply (Box f) (Box a) = Box (f a)

instance applicativeBox :: Applicative Box where
  pure :: forall a. a -> Box a
  pure a =  Box a

instance showBox :: (Show a) => Show (Box a) where
  show (Box a) = "Box(" <> show a <> ")"
