module Syntax.KindsExplained where

import Prelude

function :: Int -> String
function x = show x
-- ... translates to, "I cannot give you a concrete value (String)
-- until you give me an Int value"

data Box0 a = Box0 a
-- ... translates to, "I cannot give you a concrete type (e.g. Box0 Int)
-- until you tell me what 'a' is."

{-
Kinds = "How many more types (usually indicated by '*') do I need defined
         before I have a 'concrete' type?"

Special Name        | # of types | Their "Kind"
                      that still
                      need to be
                      defined
Concrete Types      | 0          | *
Higher-Kinded Types | 1          | * -> *
Higher-Kinded Types | 2          | * -> * -> *
-- etc.

Concrete types can usually be written with literal values: -}
-- Examples of Kind: *
-- (1 :: Int)
-- ("a literal string" :: String)
-- ([1, 2, 3] :: Array Int)

-- Higher-kinded types are those that still need one or more types to be
-- defined.
-- Example using Box (kind: * -> *) because it needs only one type defined

data Box a = Box a

-- As we can see, there can be many different 'Box' types
-- depending on what 'a' is:
boxedInt :: Box Int
boxedInt = Box 4

boxedString :: Box String
boxedString = Box "string"

boxedBoxedInt :: Box (Box Int)
boxedBoxedInt = Box boxedInt

-- Example using a commonly-used data type
data Either a b
  = Left a
  | Right b
-- It has kind * -> * -> *
-- Why? Because it cannot become a concrete type until both 'a' and 'b' types
-- are defined.
