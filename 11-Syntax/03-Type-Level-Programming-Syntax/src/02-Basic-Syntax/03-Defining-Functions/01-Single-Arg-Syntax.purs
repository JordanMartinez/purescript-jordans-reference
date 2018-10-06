module Syntax.TypeLevel.Functions.SingleArgSyntax where

-- Given the following value-level and type-level types/instances...

data InputType = InputInstance
data OutputType = OutputInstance

foreign import kind InputKind
foreign import data InputInstanceK :: InputKind

foreign import kind OutputKind
foreign import data OutputInstanceK :: OutputKind

-- ... a value-level function...

-- function's type signature
function :: InputType -> OutputType
-- function's implementation
function InputInstance = OutputInstance

-- ... can be converted to a type-level function using
--   - type classes
--   - functional dependencies

-- the relationship
class TypeLevelFunction (input :: InputKind) (output :: OutputKind)
  -- one function's type signature
  | input -> output

  -- another function's type signature
  , output -> input

-- the implementation for both functions (since this is a simple example)
instance implementation :: TypeLevelFunction InputInstanceK OutputInstanceK
