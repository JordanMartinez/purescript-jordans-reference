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
-- | A table:
-- |
-- | | One | Two | Three |
-- | | - | - | - |
-- | | a | b | c
-- |
-- | Some code:
-- | ```purescript
-- | f :: Int
-- | f = 4
-- | ```

-- | Module-level documentation
module Syntax.Documentation where

-- | value documentation
value :: Int
value = 4

-- | function documentation
function :: Int -> String
function _ = "easy"

-- | data documentation
data SomeData = SomeData

-- | type documentation
type MyType = String

-- | newtype documentation
newtype SmallInt = SmallInt Int

-- | type class documentation
class MyClass a b | a -> b where
  -- | Unfortunately, functions/values inside a type class cannot yet
  -- | be documented because of a compiler bug:
  -- | See https://github.com/purescript/purescript/issues/3507
  myFunction :: a -> b

-- | instance documentation
instance example :: MyClass String Int where
  myFunction _ = 4
