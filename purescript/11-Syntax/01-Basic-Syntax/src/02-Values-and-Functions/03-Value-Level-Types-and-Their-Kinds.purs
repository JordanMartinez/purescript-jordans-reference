module Syntax.PrimitiveTypesAndKinds where

import Prelude
{-
Due to some of its language features, Purescript defines 'kinds' in a few ways.
We'll start basic and build from there.

A kind of "*" is represented using "Type"
Think of it as "kind Type"
-}
data Number -- Type -- double-precision float number
-- 1.0

data Int -- Type
-- 1
-- 0x01 -- alternative way to write Ints

data Boolean -- Type
-- true
-- false

data Char -- Type -- doesn't support astral plane characters (code points > 0xFFFF)
-- 'c'

data String -- Type
-- "literal string syntax" -- String -- *

-- Syntax sugar for Strings
-- TODO: Figure out why this throwing a compiler error...
-- string_syntax_sugar_slashy :: String
-- string_syntax_sugar_slashy =
--   "Ignore newline characters \
--   \in strings using slashes\
--     \regardless of indentation"

-- TODO: Figure out why this throwing a compiler error...
-- string_syntax_sugar_triple_quote :: String
-- string_syntax_sugar_triple_quote = """a"""
--   Multi-line string syntax that also ignores escaped characters
--    It's useful for regular expressions
--   """

{- Note, appending two strings written in the two different syntax via <>
will result in a compiler error:
  "text over newline\
  \ cannot be " <> """appended to this string"""
-}

-- Higher-Kinded Types
-- A kind of "* -> *" is "Type -> Type"
data Array -- Type -> Type
-- ["strings"]  -- Array String
-- [0, 1, 2, 3] -- Array Int

data Function -- Type (parameter type) -> Type (return type)  -> Type (concrete type)
-- (\x -> x + 4) -- Function Int Int

-- Special kinds for language features

-- "# Type" is a special kind used to indicate that there will be an
-- N-sized number of types that are known at compile time.
data Record -- # Type -> Type
-- For example... (The Record type will be explained later.)
type UnorderedNamedCollection = { field1 :: String, field2 :: (Int -> String) }

-- Special kinds for type-level programming are not shown here.
-- They will explained much later in their own folder
