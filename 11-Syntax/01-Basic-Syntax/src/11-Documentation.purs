-- | This is a single-line documentation.

-- | This
-- | is
-- | a
-- | multi-line
-- | documentation block, not a comment.
-- | Because it appears above the module declaration below,
-- | it will be combined with the next few documentation blocks.

-- | One can use markdown inside of documentation:
-- |
-- | Look an unordered list:
-- | - item 1
-- | - item 2
-- |
-- | An ordered list:
-- | 1. Item
-- | 2. Item
-- | 3. Item
-- |
-- | Unfortunately, markdown tables don't work...:
-- |
-- | | One | Two | Three |
-- | | --- | --- | ----- |
-- | | a   | b   | c     |
-- |
-- | # Headers level 1 work
-- |
-- | ## Headers level 2 work
-- |
-- | ### Headers level 3 work
-- |
-- | #### Headers level 4 work
-- |
-- | ##### Headers level 5 work
-- |
-- | ###### Headers level 6 work
-- |
-- | Some code:
-- | ```purescript
-- | f :: Int
-- | f = 4
-- | ```

-- | Documentation on a given module
module Syntax.Basic.Documentation where

-- | Documentation on a value
value :: Int
value = 4

-- | Documentation on a function
function :: Int -> String
function _ = "easy"

-- | Documentation on a given data type
data SomeData
  -- | Documentation on a particular data constructor
  = SomeData

-- | Documentation on a given type alias
type MyType = String

-- | Documentation on a given newtype
newtype SmallInt = SmallInt Int

-- | Documentation on a given type class
class MyClass a b | a -> b where
  -- | Documentation for a particular function/value
  -- | defined in a type class
  myFunction :: a -> b

-- | Documentation for a particular instance of a type class
instance example :: MyClass String Int where
  myFunction _ = 4
