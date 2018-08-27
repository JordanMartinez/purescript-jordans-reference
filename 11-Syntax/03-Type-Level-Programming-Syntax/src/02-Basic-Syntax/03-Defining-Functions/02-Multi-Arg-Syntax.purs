module Syntax.TypeLevel.Functions.MultiArgSyntax where

-- Given the following value-level and type-level types/instances...

data InputType1 = InputInstance1
data InputType2 = InputInstance2
data OutputType = OutputInstance

foreign import kind InputKind1
foreign import data InputInstanceK1 :: InputKind

foreign import kind InputKind2
foreign import data InputInstanceK2 :: InputKind

foreign import kind OutputKind
foreign import data OutputInstanceK :: OutputKind

-- ... a value-level function...

-- function's type signature
function :: InputType1 -> InputType2 -> OutputType
-- function's implementation
function InputInstance1 InputInstance2 = OutputInstance

-- ... converts to

-- function's type signature
class TypeLevelFunction
  (input1 :: InputKind1)
  (input2 :: InputKind2)
  (output :: OutputKind) | input1 input2 -> output
-- function's implementation
instance implementation ::
  TypeLevelFunction InputInstanceK1 InputInstanceK2 OutputInstanceK

{-
Note: the functional dependency listed above may include more than
what I wrote depending on what the function does.

I've seen a one, some, or all of the following functional dependencies
in various "real-world" libraries:
  - input1 input2 -> output
  - input1 output -> input2
  - input2 output -> input1
  - output -> input1
  - output -> input2
  - output -> input1 input2

As of this writing, I haven't done enough type-level programming
to know when to use one or the other.
-}
