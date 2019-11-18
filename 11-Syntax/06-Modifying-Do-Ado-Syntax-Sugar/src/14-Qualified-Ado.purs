module Syntax.Modification.QualifiedAdo where

-- we'll import Prelude so that the regular functions (e.g. "map" "apply")
-- are in scope to prove that they don't cause problems here.
import Prelude


-- Requirement 3: import the module using a module alias, making it possible
-- to use the same function names to refer to different "apply"-like functions
import Syntax.Modification.MonadLikeTypeClasses as I
import Syntax.Modification.MonadLikeTypeClasses (Box)

-- Requirement 4: When we want to use 'qualified ado' syntax, we need to call the separate
-- function above and constrain the types to use IxApplicative
adoExample :: forall x. Box x x String
adoExample = I.ado       -- signifies that we're using the "apply" and "map"
                         --   functions defined in the "MonadLikeTypeClasses"
                         --   module to desugar "<-" and "in <function>"
                         --   notation.

  a <- I.pure "test1"    -- signifies that we're using the "pure" function
                         --   defined in the "MonadLikeTypeClasses" module
  b <- I.pure "test2"
  in twoArgFunction a b

twoArgFunction :: String -> String -> String
twoArgFunction a b = a <> b

mixingAdosTogether :: String
mixingAdosTogether =
  """
  I think "qualified ado" and "unqualified ado" can be mixed together,
  but I don't know of any examples
  """
