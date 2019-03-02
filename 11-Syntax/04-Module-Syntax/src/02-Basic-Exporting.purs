module Syntax.Module.Exporting
  -- exports go here by just writing the name
  ( value

  , function, (>@>>>) -- aliases must be wrapped in parenthesis

  -- when exporting type classes, there are two rules:
  -- - you must precede the type class name with the keyword 'class'
  -- - you must also export the type class' function (or face compilation errors)
  , class TypeClass, tcFunction

  -- when exporting modules, you must precede the module name with
  -- the keyword 'module'
  , module ExportedModule

  -- The type is exported, but no one can create a value of it
  -- outside of this module
  , ExportDataType1_ButNotItsConstructors

  -- The type is exported and only one of its constructors is exported. Thus,
  -- everyone else can create a `Constructor2A' value but not
  -- `Constructor2B`. That one can only be created inside this module.
  , ExportDataType2_AndOneOfItsConstructors(Constructor2A)

  -- The type is exported and some of its constructors are exported. Thus,
  -- everyone else can create a `Constructor3A' value
  -- and a `Constructor3B` value, but not a `Constructor3C` value, which
  --  can only be created inside this module.
  , ExportDataType3_AndSomeOfItsConstructors(Constructor3A, Constructor3B)

  , ExportDataType4_AndAllOfItsConstructors(..) -- syntax sugar for 'all constructors'

  -- Type aliases can also be exported
  , ExportedTypeAlias

  -- When type aliases are aliased using infix notation, one must export
  -- both the type alias, and the infix notation where 'type' must precede
  -- the infix notation
  , ExportedTypeAlias_InfixNotation, type (<|<>|>)

  -- Data constructor alias; exporting the alias requires you
  -- to also export the constructor it aliases
  , ExportedDataType4_InfixNotation(Infix_Constructor), (<||||>)

  -- Kinds require the `kind` keyword to precede them
  , kind ExportedKind
  , ExportedKindValue
  ) where

-- imports go here
import ExportedModule

value :: Int
value = 3

function :: String -> String
function x = x

infix 4 function as >@>>>

class TypeClass a where
  tcFunction :: a -> a -> a

data ExportDataType1_ButNotItsConstructors = Constructor1A

data ExportDataType2_AndOneOfItsConstructors
  = Constructor2A
  | Constructor2B

data ExportDataType3_AndSomeOfItsConstructors
  = Constructor3A
  | Constructor3B
  | Constructor3C

data ExportDataType4_AndAllOfItsConstructors
  = Constructor4A
  | Constructor4B
  | Constructor4C

type ExportedTypeAlias = Int

data ExportedDataType4_InfixNotation = Infix_Constructor Int Int

infixr 4 Infix_Constructor as <||||>

type ExportedTypeAlias_InfixNotation = String

infixr 4 type ExportedTypeAlias_InfixNotation as <|<>|>

foreign import kind ExportedKind

foreign import data ExportedKindValue :: ExportedKind
