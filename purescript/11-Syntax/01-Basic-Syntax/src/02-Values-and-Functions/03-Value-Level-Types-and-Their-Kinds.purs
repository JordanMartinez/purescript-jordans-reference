module Syntax.PrimitiveTypesAndKinds where

{-
Due to some of its language features, Purescript defines 'kinds' in a few ways.
We'll start basic and build from there.

A kind of "*" is represented using "Type"
Think of it as "kind Type"

Note: To prevent conflicts between the real code and this compileable file,
we're appending underscores to the types. Remove the underscore to get the
real thing in Purescript.
-}
data Number_ -- Type -- double-precision float number
-- 1.0

data Int_ -- Type
-- 1
-- 0x01 -- alternative way to write Ints

data Boolean_ -- Type
-- true
-- false

data Char_ -- Type -- doesn't support astral plane characters (code points > 0xFFFF)
-- 'c'

data String_ -- Type
-- "literal string syntax" -- String -- *

-- Syntax sugar for Strings
string_syntax_sugar_slashy :: String
string_syntax_sugar_slashy =
  "Ignore newline characters \
  \in strings using slashes\
            \regardless of indentation\

    \and regardless of vertical space between them\

    \(though you can't put comments in that blank vertical space)"

string_syntax_sugar_triple_quote :: String
string_syntax_sugar_triple_quote = """
  Multi-line string syntax that also ignores escaped characters, such as
  * . $ []
  It's useful for regular expressions
  """

{- Note, appending two strings written in the two different syntax via <>
will result in a compiler error:
  "text over newline\
  \ cannot be " <> """appended to this string"""
-}

-- Higher-Kinded Types
-- A kind of "* -> *" is "Type -> Type"
data Array_ -- Type -> Type
-- ["strings"]  -- Array String
-- [0, 1, 2, 3] -- Array Int

data Function_ -- Type (parameter type) -> Type (return type)  -> Type (concrete type)
-- (\x -> x + 4) -- Function Int Int

-- Special kinds for language features

-- "# Type" is a special kind used to indicate that there will be an
-- N-sized number of types that are known at compile time.
data Record_ -- # Type -> Type
-- For example... (The Record type will be explained later.)
type UnorderedNamedCollection = { field1 :: String, field2 :: (Int -> String) }

-- Special kinds for type-level programming are not shown here.
-- They will explained much later in their own folder
