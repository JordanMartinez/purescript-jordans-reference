module Syntax.PrimitiveTypesAndKinds where

import Prelude

{-
The following file documents the Prim module. This module is imported
by default into every Purescript file (unless one hides it using Module aliases,
which are described in the Module Syntax folder).

See the full documenation here:
https://pursuit.purescript.org/builtins/docs/Prim

Purescript has a number of different 'kinds'; thus, it uses different
syntax to refer to them. We'll start with the basic and go from there.

Note: To prevent conflicts between the real code and this compileable file,
we're appending underscores to the types. Remove the underscore to get the
real thing in Purescript.

In other words
Purescript:   data Number  :: Type
This example: data Number_ -- Type
-}
data Number_ -- Type -- double-precision float number

exampleNumber :: Number
exampleNumber = 1.0

data Int_ -- Type

exampleInt1 :: Int
exampleInt1 = 1

exampleInt2 :: Int
exampleInt2 = 0x01 -- alternative way to write them

data Boolean_ -- Type

exampleTrue :: Boolean
exampleTrue = true

exampleFalse :: Boolean
exampleFalse = false

data Char_ -- Type -- doesn't support astral plane characters (code points > 0xFFFF)

exampleChar :: Char
exampleChar = 'c'

data String_ -- Type

literal_string_syntax :: String
literal_string_syntax = "literal string value"

-- Syntax sugar for Strings
slashy_string_syntax :: String
slashy_string_syntax =
  "Ignore newline characters \
  \in strings using slashes\
            \regardless of indentation\

    \and regardless of vertical space between them\

    \(though you can't put comments in that blank vertical space)"

triple_quote_string_syntax :: String
triple_quote_string_syntax = """
  Multi-line string syntax that also ignores escaped characters, such as
  * . $ []
  It's useful for regular expressions
  """

-- Higher-Kinded Types
data Array_ -- Type -> Type

arrayOfStrings :: Array String
arrayOfStrings = ["string1", "string2"]

arrayOfInts :: Array Int
arrayOfInts = [0, 1, 2, 3]

-- The "forall a." syntax will be explained later. It's needed here
-- to make this code compile
array_of_one_A :: forall a. a -> Array a
array_of_one_A a = [a]

data Function_ -- Type (parameter type) -> Type (return type)  -> Type
-- In other words, give me the parameter type and the return type,
--   and I'll have a concrete type

function_no_syntax_sugar :: Function Int Int
function_no_syntax_sugar = (\x -> x + 4)

function_with_syntax_sugar :: (Int -> Int)
function_with_syntax_sugar = (\x -> x + 4)

-- Special "Kind" syntax for language features

-- "# Type" is a special kind used to indicate that there will be an
-- N-sized number of types that are known at compile time.
data Record_ -- # Type -> Type

-- For example...
type UnorderedNamedCollection = { field1 :: String, field2 :: (Int -> String) }

-- The Record kind will be examined and explained later.

-- Special kinds for type-level programming are not shown here.
-- They will explained in the Type-Level-Programming-Syntax folder
