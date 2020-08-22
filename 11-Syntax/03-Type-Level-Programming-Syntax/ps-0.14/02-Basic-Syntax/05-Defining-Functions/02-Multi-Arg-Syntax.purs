module Syntax.TypeLevel.Functions.MultiArgSyntax where

-- Given the following value-level and type-level types/values...

data InputType1 = InputValue1
data InputType2 = InputValue2
data OutputType = OutputValue

data InputKind1
foreign import data InputValueK1 :: InputKind1

data InputKind2
foreign import data InputValueK2 :: InputKind2

data OutputKind
foreign import data OutputValueK :: OutputKind

-- ... a value-level function...

-- function's type signature
function :: InputType1 -> InputType2 -> OutputType
-- function's implementation
function InputValue1 InputValue2 = OutputValue

-- ... converts to

-- The relationship
class TypeLevelFunction :: InputKind1 -> InputKind2 -> OutputKind -> Constraint
class TypeLevelFunction input1 input2 output
  -- the functions' type signatures
  | input1 input2 -> output
  , input1 output -> input2
  , input2 output -> input1

-- functions sole implementation
instance implementation ::
  TypeLevelFunction InputValueK1 InputValueK2 OutputValueK
