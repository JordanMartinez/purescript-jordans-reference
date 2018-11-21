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

-- the relationship
class TypeLevelFunction (input :: InputKind) (output :: OutputKind)
  -- the functions' type signatures
  | input -> output
  , output -> input

-- the implementations via pattern matching
instance firstPatternMatch  :: TypeLevelFunction InputInstance1 OutputInstance1
instance secondPatternMatch :: TypeLevelFunction InputInstance2 OutputInstance2
instance thirdPatternMatch  :: TypeLevelFunction InputInstance3 OutputInstance3

--------------------------------------------
-- An example using YesNo and Zero/One
data YesNo     = Yes  | No
data ZeroOrOne = Zero | One

toInt :: YesNo -> ZeroOrOne
--    input = output
toInt Yes = One
toInt No = Zero

-- converts to

foreign import kind YesNoKind
foreign import data YesK :: YesNoKind
foreign import data NoK  :: YesNoKind

foreign import kind ZeroOrOneKind
foreign import data OneK  :: ZeroOrOneKind
foreign import data ZeroK :: ZeroOrOneKind

class ToInt (input :: YesNoKind) (output :: ZeroOrOneKind) | input -> output
instance toInt_YesOne :: ToInt YesK OneK
instance toInt_NoZero :: ToInt NoK  ZeroK
