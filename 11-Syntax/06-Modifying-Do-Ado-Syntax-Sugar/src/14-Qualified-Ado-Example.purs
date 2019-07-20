module Syntax.QualifiedAdo where

-- we'll import Prelude so that the regular functions (e.g. "map" "apply")
-- are in scope to prove that they don't cause problems here.
import Prelude


-- Requirement 3: import the module using a module alias, making it possible
-- to use the same function names to refer to different "apply"-like functions
import Syntax.MonadLikeTypeClasses as I

-- import the type classes, so we can constraint types
import Syntax.MonadLikeTypeClasses (class IxFunctor, class IxApply, class IxApplicative)

-- Given a indexed-monadic type (type classes are at end of file)
data Box phantomInput phantomOutput storedValue = Box storedValue

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

-- type class instances

instance functor :: IxFunctor Box where
  imap :: forall a b x. (a -> b) -> Box x x a -> Box x x b
  imap f (Box a) = Box (f a)

instance apply :: IxApply Box where
  iapply :: forall a b x y z. Box x y (a -> b) -> Box y z a -> Box x z b
  iapply (Box f) (Box a) = Box (f a)

instance applicative :: IxApplicative Box where
  ipure :: forall a x. a -> Box x x a
  ipure a = Box a

instance showBox :: (Show a) => Show (Box x x a) where
  show (Box a) = "Box(" <> show a <> ")"
