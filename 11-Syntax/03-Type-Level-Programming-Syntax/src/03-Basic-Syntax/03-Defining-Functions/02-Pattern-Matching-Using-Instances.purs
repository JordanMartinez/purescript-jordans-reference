module Syntax.TypeLevel.Functions.PatternMatching.InstancesOnly where

-- To handle more pattern matching, we add more instances of the type class

-- This...
data InputType2
  = InputInstance1
  | InputInstance2
  | InputInstance3

data OutputType2
  = OutputInstance1
  | OutputInstance2
  | OutputInstance3

function2 :: InputType2 -> OutputType2
function2 InputInstance1 = OutputInstance1 -- first pattern match
function2 InputInstance2 = OutputInstance2 -- second pattern match
function2 InputInstance3 = OutputInstance3 -- third pattern match

-- ... converts to...

foreign import kind InputKind
foreign import data InputInstance1 :: InputKind
foreign import data InputInstance2 :: InputKind
foreign import data InputInstance3 :: InputKind

foreign import kind OutputKind
foreign import data OutputInstance1 :: OutputKind
foreign import data OutputInstance2 :: OutputKind
foreign import data OutputInstance3 :: OutputKind

class TypeLevelFunction (input :: InputKind) (output :: OutputKind) | input -> output

instance firstPatternMatch  :: TypeLevelFunction InputInstance1 OutputInstance1
instance secondPatternMatch :: TypeLevelFunction InputInstance2 OutputInstance2
instance thirdPatternMatch  :: TypeLevelFunction InputInstance3 OutputInstance3

--------------------------------------------
-- An example using Boolean and Zero/One
data Boolean_ = True_Value | False_Value
data ZeroOrOne_ = Zero_ | One_

toInt :: Boolean -> ZeroOrOne_
--    input = output
toInt true = One_
toInt false = Zero_

-- converts to

foreign import kind Boolean
foreign import data True :: Boolean
foreign import data False :: Boolean

foreign import kind ZeroOrOne
foreign import data One :: ZeroOrOne
foreign import data Zero :: ZeroOrOne

class ToInt (input :: Boolean) (output :: ZeroOrOne) | input -> output
instance toInt_TrueOne :: ToInt True One
instance toInt_FalseZero :: ToInt False Zero
