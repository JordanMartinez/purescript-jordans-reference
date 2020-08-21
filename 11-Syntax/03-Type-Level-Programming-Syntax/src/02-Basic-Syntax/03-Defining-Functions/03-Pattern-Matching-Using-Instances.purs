module Syntax.TypeLevel.Functions.PatternMatching.InstancesOnly where

-- To handle more pattern matching, we add more values of the type class

-- This...
data InputType2
  = InputValue1
  | InputValue2
  | InputValue3

data OutputType2
  = OutputValue1
  | OutputValue2
  | OutputValue3

function2 :: InputType2 -> OutputType2
function2 InputValue1 = OutputValue1 -- first pattern match
function2 InputValue2 = OutputValue2 -- second pattern match
function2 InputValue3 = OutputValue3 -- third pattern match

-- ... converts to...

foreign import kind InputKind
foreign import data InputValue1 :: InputKind
foreign import data InputValue2 :: InputKind
foreign import data InputValue3 :: InputKind

foreign import kind OutputKind
foreign import data OutputValue1 :: OutputKind
foreign import data OutputValue2 :: OutputKind
foreign import data OutputValue3 :: OutputKind

-- the relationship
class TypeLevelFunction (input :: InputKind) (output :: OutputKind)
  -- the functions' type signatures
  | input -> output
  , output -> input

-- the implementations via pattern matching
instance firstPatternMatch  :: TypeLevelFunction InputValue1 OutputValue1
instance secondPatternMatch :: TypeLevelFunction InputValue2 OutputValue2
instance thirdPatternMatch  :: TypeLevelFunction InputValue3 OutputValue3

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
