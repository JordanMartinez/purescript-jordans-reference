module Syntax.Basic.Typeclass.Constraints where

import Prelude

-- Adding a Type Class constraint to a type signature
-- enables usage of the corresponding type class' function in that context:

-- Syntax: Adding constraints on Function's type signature
function :: TypeClass1 Type1 => TypeClass2 Type2 => {- and so on -} Type1 -> ReturnType
function arg = "return result"

-- example

class ToInt a where
  toInt :: a -> Int

data List a
  = Nil               -- end of list
  | Cons a (List a)   -- a head element and the rest of the list (tail)

                      -- 'a' must have an 'ToInt' instance for this to compile
stringList_to_intList :: forall a. ToInt a => List a -> List Int
stringList_to_intList Nil = Nil
stringList_to_intList (Cons head tail) = Cons (toInt head) (stringList_to_intList tail)

-- Coupling this with the `forall` syntax:
function0 :: forall a b. TypeClass1 a => TypeClass2 b => a -> b -> String
function0 a b = "return result"



-- Syntax: Adding constraints on type class instances

-- This type class turns any type into a String so we can
-- print it to the console when needed
class Show_ a where -- this is the same signature for Show found in Prelude
  show_ :: a -> String

-- Problem:
-- Say we have a data type called "Box" that just contains a value:
data Boxx a = Boxx a

-- If we want to implement the `Show` typeclass for it, we are limited to this:
instance showBoxx :: Show (Boxx a) where
  show (Boxx _) = "Box(<unknown value>)"

{-
We would like to also show the 'a' value stored in Box. How do we do that?
  By constraining our types in the Box to also have a Show instance: -}

-- Syntax
instance syntax :: (TypeClass1 a) => {-
                   (TypeClassN a) => -} TypeClass1 (IntanceType a) where
  function1 _ = "body"

data Box a = Box a
{- example: Read the following as:
"I can 'show' a Box only if the type stored in the Box can also be shown."
-}
instance showBox :: (Show a) => Show (Box a) where
  show (Box a) = "Box(" <> show a <> ")"

-- We have names for specific parts of the instance
instance instancePartNames :: (InstanceContext a) => A_TypeClass (InstanceHead a) where
  function2 _ = "body"

-- Implicit Usage: Since we know that the values below are of type "Box Int"
-- We can use "show" without constraining any types.
test1 :: Boolean
test1 =
  show (Box 4) == "Box(4)"

test2 :: Boolean
test2 =
  show (Box (Box 5)) == "Box(Box(5))"

-- Explicit Usage: The only thing we know about 'a' is that it can be shown.
showIt :: forall a. Show a => a -> String
showIt showableThing = show showableThing

-- All of these work because they all have a Show instance.
test3 :: String
test3 = showIt 4

test4 :: String
test4 = showIt (Box 5)

test5 :: String
test5 = showIt (Box (Box (Box 5)))

-- necessary to make file compile

class TypeClass1 a where
  function1 :: a -> String

class InstanceContext a

instance ih :: InstanceContext a

data InstanceHead a = InstanceHead

class A_TypeClass a where
  function2 :: a -> String

instance typeclass1 :: TypeClass1 String where
  function1 a = a

class TypeClass2 a

instance typeclass2 :: TypeClass2 String

type Type1 = String
type Type2 = String
type ReturnType = String
data IntanceType a = InstanceType a
