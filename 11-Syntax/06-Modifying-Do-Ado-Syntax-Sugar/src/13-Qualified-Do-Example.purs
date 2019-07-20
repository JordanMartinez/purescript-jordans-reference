module Syntax.Notation.QualifiedDoAdo where

-- we'll import Prelude so that the regular functions (e.g. "pure" "bind")
-- are in scope to prove that they don't cause problems here.
import Prelude


-- Requirement 3: import the module using a module alias, making it possible
-- to use the same function names to refer to different "bind"-like functions
import Syntax.Notation.MonadLikeTypeClasses as I

-- import the type classes, so we can constraint types
import Syntax.Notation.MonadLikeTypeClasses (class IxMonad)

-- Requirement 4: When we want to use 'qualified ado' syntax, we need to call the separate
-- function above and constrain the types to use IxMonad
doExample :: forall f x. IxMonad f => f x x String
doExample = I.do        -- signifies that we're using the "bind" function
                        --   defined in the "MonadLikeTypeClasses" module
  a <- I.pure "test1"   -- signifies that we're using the "pure" function
                        --   defined in the "MonadLikeTypeClasses" module
  b <- I.pure "test2"
  I.pure (a <> b)

mixingDosTogether :: String
mixingDosTogether =
  """
  "Qualified do" and "unqualified do" can be mixed together. For examples, see
    - https://github.com/spicydonuts/purescript-react-basic/blob/hooks-qualified-do/examples/counter/src/Counter.purs
    - https://github.com/spicydonuts/purescript-react-basic/blob/hooks-qualified-do/examples/controlled-input/src/ControlledInput.purs
  """
