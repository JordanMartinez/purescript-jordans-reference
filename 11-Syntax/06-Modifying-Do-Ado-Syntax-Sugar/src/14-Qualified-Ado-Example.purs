module Syntax.Notation.QualifiedAdoExample where

-- we'll import Prelude so that the regular functions (e.g. "map" "apply")
-- are in scope to prove that they don't cause problems here.
import Prelude


-- Requirement 3: import the module using a module alias, making it possible
-- to use the same function names to refer to different "apply"-like functions
import Syntax.Notation.MonadLikeTypeClasses as I

-- import the type classes, so we can constraint types
import Syntax.Notation.MonadLikeTypeClasses (class IxApplicative)

-- Requirement 4: When we want to use 'qualified ado' syntax, we need to call the separate
-- function above and constrain the types to use IxApplicative
adoExample :: forall f x. IxApplicative f => f x x String
adoExample = I.ado       -- signifies that we're using the "apply" function
                         --   defined in the "MonadLikeTypeClasses" module
  a <- I.pure "test1"    -- signifies that we're using the "pure" function
                         --   defined in the "MonadLikeTypeClasses" module
  b <- I.pure "test2"
  in twoArgFunction a b  -- signifies that we're using the "map" function
                         --   defined in the "MonadLikeTypeClasses" module

twoArgFunction :: String -> String -> String
twoArgFunction a b = a <> b

mixingAdosTogether :: String
mixingAdosTogether =
  """
  I think "qualified ado" and "unqualified ado" can be mixed together,
  but I don't know of any examples
  """
