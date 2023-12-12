module Syntax.Basic.VisibleTypeApplications.OrderMatters where

-- When we write the following function...
basicFunction :: Int -> String -> Boolean -> String
basicFunction _i _s _b = "returned value"

-- ... we know that the order of the arguments matters.
-- The below usage is valid
usage :: String
usage = basicFunction 1 "foo" false

-- whereas this one is not because the first argument must be an `Int`
--    usage2 :: String
--    usage2 = basicFunction "foo" 1 false

-- Similarly, because functions are curried, 
-- when we apply just one argument, we get back a function
-- that takes the remaining arguments

basicFunction' :: String -> Boolean -> String
basicFunction' = basicFunction 1

-- These same ideas apply to VTAs. Notice below that VTA support is only added
-- to the second and fourth type variable.
vtaFunction
  :: forall first @second third @fourth
   . first
  -> second
  -> third
  -> fourth
  -> String
vtaFunction _first _second _third _fourth = "returned value"

-- Type-level arguments (e.g. VTAs) are always applied before value-level arguments.
-- Why? Because those arguments appear earlier in the function.
-- If we want to use VTAs to specify which types `second` and `fourth` are,
-- we must apply those type arguments BEFORE applying any value arguments. In other words,
-- the below code is correct:

usage3 :: String
usage3 = vtaFunction @Int @Int "first" 2 "third" 4

-- whereas this code would be incorrect:
--    usage3 :: String
--    usage3 = vtaFunction "first" @Int 2 "third" @Int 4

-- Put differently, we can define a new function by only applying a single type argument.

vtaFunction'
  :: forall first third fourth
   . first
  -> Int
  -> third
  -> fourth
  -> String
vtaFunction' = vtaFunction @Int -- force `second` to be `Int`

-- Or by type-applying multiple arguments
vtaFunction''
  :: forall first third
   . first
  -> Int
  -> third
  -> Int
  -> String
vtaFunction'' = vtaFunction @Int @Int -- force `second` and `fourth` to be `Int`

-- Note: the astute reader will have noticed that the `@` characters don't appear in
-- `vtaFunction'` and `vtaFunction''`. Since this is opt-in syntax, one must
-- opt-in every time a new function is defined, even if that function
-- is derived from applying one argument to a multi-argument curried function.
