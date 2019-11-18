module Syntax.Modification.QualifiedDo where

-- we'll import Prelude so that the regular functions (e.g. "pure" "bind")
-- are in scope to prove that they don't cause problems here.
import Prelude


-- Requirement 3: import the module using a module alias, making it possible
-- to use the same function names to refer to different "bind"-like functions
import Syntax.Modification.MonadLikeTypeClasses as I
import Syntax.Modification.MonadLikeTypeClasses (Box)

-- Requirement 4: When we want to use 'qualified do' syntax, we need to call
-- the separate functions above and constrain the types to use IxMonad
doExample :: forall input. Box input input String
doExample = I.do        -- signifies that we're using the "bind" and "discard"
                        --   functions defined in the "MonadLikeTypeClasses"
                        --   module to desugar "<-" and lines that lack it
                        --   (i.e. discard)

  a <- I.pure "test1"   -- signifies that we're using the "pure" function
                        --   defined in the "MonadLikeTypeClasses" module
  b <- I.pure "test2"
  I.pure (a <> b)
