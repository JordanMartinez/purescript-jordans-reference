module Syntax.TypeLevel.Functions.SingleArgSyntax where

-- Given the following value-level and type-level types/values...

data InputType = InputValue
data OutputType = OutputValue

foreign import kind InputKind
foreign import data InputValueK :: InputKind

foreign import kind OutputKind
foreign import data OutputValueK :: OutputKind

-- ... a value-level function...

-- function's type signature
function :: InputType -> OutputType
-- function's implementation
function InputValue = OutputValue

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
instance implementation :: TypeLevelFunction InputValueK OutputValueK
