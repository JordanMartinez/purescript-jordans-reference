{-
Due to some of its language features, Purescript defines 'kinds' in a few ways.
We'll start basic and build from there.

A kind of "*" is represented using "Type"
-}
data Number :: Type -- double-precision float number
1.0

data Int :: Type
1
0x01 -- alternative way to write Ints

data Boolean :: Type
true
false

data Char :: Type -- doesn't support astral plane characters (code points > 0xFFFF)
'c'

data String :: Type
"literal string syntax" -- String -- *

-- Syntax sugar
"Ignore newline characters \
\in strings using slashes"

          "Also works when there are spaces between the slashes, \
          \such as this case"

"""
Multi-line string syntax that also ignores escaped characters
like . / \ ? ! etc.
>>> It's useful for regular expressions
"""

-- Higher-Kinded Types
-- A kind of "* -> *" is "Type -> Type"
data Array :: Type -> Type
["strings"]  -- Array String
[0, 1, 2, 3] -- Array Int

data Function :: Type -> Type -> Type
                                              {- -- syntax highlighting wasn't working...
data Function :: ParameterType -> ReturnType -> ConcreteType-}
(\x -> x + 4) -- Function Int Int

-- Special kinds for language features

-- "# Type" is a special kind used to indicate that there will be an
-- N-sized number of types that are known at compile time. We'll see why later.
data Record :: # Type -> Type

-- "Symbol" is a special kind used for type-level strings. These will be explained later.
data SProxy (string :: Symbol)
