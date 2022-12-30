module Syntax.Basic.PrimitiveTypesAndKinds where

import Prelude

{-
The following file documents the Prim module. This module is imported
by default into every PureScript file (unless one hides it using Module aliases,
which are described in the Module Syntax folder) and is embedded in the
compiler itself to provide value literals for certain types and syntax sugar.

See the full documenation here:
https://pursuit.purescript.org/builtins/docs/Prim

This file will document all the types whose kind signature is `Type`.
Their kind signatures aren't that important at this level in your understanding.

Note: To prevent conflicts between the real code and this compileable file,
we're appending underscores to the types. Remove the underscore to get the
real thing in Purescript.

In other words
Purescript:        DataType  :: Kind
This example: data DataType_ -- Kind
-}
data Number_ -- Type -- double-precision float number

exampleNumber1 :: Number
exampleNumber1 = 1.0

-- negative values must be wrapped in parenthesis:
exampleNumber2 :: Number
exampleNumber2 = (-1.0)

data Int_ -- Type

exampleInt1 :: Int
exampleInt1 = 1

exampleInt2 :: Int
exampleInt2 = 0x01 -- alternative way to write them

exampleInt3 :: Int
exampleInt3 = 1_000_000 -- use underscores for thousands character

-- negative values must be wrapped in parenthesis:
exampleInt4 :: Int
exampleInt4 = (-1)

exampleInt5 :: Int
exampleInt5 = (-0x01)

exampleInt6 :: Int
exampleInt6 = (-1_000_000)

data Boolean_ -- Type

exampleTrue :: Boolean
exampleTrue = true

exampleFalse :: Boolean
exampleFalse = false

{-
Note: The Boolean data type is used via true/false literal values instead of
True/False constructors as one might expect, especially those coming from Haskell
where such a simple data type would be defined as:

data Boolean = True | False

In Purescript, having Javascript as the main compilation target, the decision was
made to use true/false literal values for the Boolean data type instead of
having it be defined as a simple Algebric Data Type (ADT) as is the case in Haskell.
-}

data Char_ -- Type -- doesn't support astral plane characters (code points > 0xFFFF)

exampleChar :: Char
exampleChar = 'c'

unicodeA :: Char
unicodeA = '\x0061'

-- Astral plane characters (i.e. those with code point values greater than
-- `0xFFFF`) cannot be represented as `Char` values.
unicodeChar :: Char
unicodeChar = '\xFFFF'

unicodeChar2 :: Char
unicodeChar2 = '\xffff'

data String_ -- Type

literal_string_syntax :: String
literal_string_syntax = "literal string value"

-- Follows this regex pattern: \x[0-9a-fA-F]{1,6}
unicode_hex_escape_syntax :: String
unicode_hex_escape_syntax = "\xa4"

-- Syntax sugar for Strings
slashy_string_syntax :: String
slashy_string_syntax =
  "Enables multi-line strings that \
  \use slashes \
            \regardless of indentation \

    \and regardless of vertical space between them \

    \(though you can't put comments in that blank vertical space)"
    {-
    "This will fail \
    -- oh look a comment that breaks this!
    \to compile."
    -}

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

function_with_syntax_sugar1 :: (Int -> Int)
function_with_syntax_sugar1 = (\x -> x + 4)

function_with_syntax_sugar2 :: Int -> Int
function_with_syntax_sugar2 = (\x -> x + 4)

function_with_syntax_sugar3 :: Int -> Int
function_with_syntax_sugar3 x = x + 4
