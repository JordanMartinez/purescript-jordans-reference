module Syntax.TypeLevel.Functions.MultiArgSyntax where

-- Given the following value-level and type-level types/instances...

data InputType1 = InputInstance1
data InputType2 = InputInstance2
data OutputType = OutputInstance

foreign import kind InputKind1
foreign import data InputInstanceK1 :: InputKind1

foreign import kind InputKind2
foreign import data InputInstanceK2 :: InputKind2

foreign import kind OutputKind
foreign import data OutputInstanceK :: OutputKind

-- ... a value-level function...

-- function's type signature
function :: InputType1 -> InputType2 -> OutputType
-- function's implementation
function InputInstance1 InputInstance2 = OutputInstance

-- ... converts to

-- The relationship
class TypeLevelFunction
  (input1 :: InputKind1) (input2 :: InputKind2) (output :: OutputKind)

  -- the functions' type signatures
  | input1 input2 -> output
  , input1 output -> input2
  , input2 output -> input1

-- functions sole implementation
instance implementation ::
  TypeLevelFunction InputInstanceK1 InputInstanceK2 OutputInstanceK
