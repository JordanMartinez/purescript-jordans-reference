module Syntax.QualifiedDo where

-- we'll import Prelude so that the regular functions (e.g. "pure" "bind")
-- are in scope to prove that they don't cause problems here.
import Prelude


-- Requirement 3: import the module using a module alias, making it possible
-- to use the same function names to refer to different "bind"-like functions
import Syntax.MonadLikeTypeClasses as I

-- import the type classes, so we can constrain types
import Syntax.MonadLikeTypeClasses (class IxFunctor, class IxApply, class IxApplicative, class IxBind, class IxMonad)

-- Given a indexed-monadic type (type classes are at end of file)
data Box phantomInput phantomOutput storedValue = Box storedValue

-- Requirement 4: When we want to use 'qualified ado' syntax, we need to call
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

instance ixFunctorBox :: IxFunctor Box where
  imap :: forall a b x. (a -> b) -> Box x x a -> Box x x b
  imap f (Box a) = Box (f a)

instance ixApplyBox :: IxApply Box where
  iapply :: forall a b x y z. Box x y (a -> b) -> Box y z a -> Box x z b
  iapply (Box f) (Box a) = Box (f a)

instance ixApplicativeBox :: IxApplicative Box where
  ipure :: forall a x. a -> Box x x a
  ipure a = Box a

instance ixBindBox :: IxBind Box where
  ibind :: forall a b x y z. Box x y a -> (a -> Box y z b) -> Box x z b
  ibind (Box a) f =
    -- `f a` produces a value with the type, `Box y z b`, which is
    -- not the return type of this function, `Box x z b`.
    --
    -- So, we can either `unsafeCoerce` the result of `f a` or just
    -- rewrap the 'b' value in a new Box. We've chosen to take the
    -- latter option here for simplicity.
    case f a of Box b -> Box b

instance ixMonadBox :: IxMonad Box

instance showBox :: (Show a) => Show (Box x x a) where
  show (Box a) = "Box(" <> show a <> ")"
