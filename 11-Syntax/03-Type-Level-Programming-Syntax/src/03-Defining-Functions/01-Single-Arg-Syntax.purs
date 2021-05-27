module Syntax.TypeLevel.Functions.SingleArgSyntax where

-- Given the following value-level and type-level types/values...

data InputType = InputValue
data OutputType = OutputValue

data InputKind
foreign import data InputValueK :: InputKind

data OutputKind
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
class TypeLevelFunction :: InputKind -> OutputKind -> Constraint
class TypeLevelFunction input output
  -- one function's type signature
  | input -> output

  -- another function's type signature
  , output -> input

-- the implementation for both functions (since this is a simple example)
instance TypeLevelFunction InputValueK OutputValueK
