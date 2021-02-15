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

  -- syntax sugar for 'all constructors'
  -- Either all or none of a type's constructors must be exported
  , ExportDataType2_AndAllOfItsConstructors(..)

  -- Type aliases can also be exported
  , ExportedTypeAlias

  -- When type aliases are aliased using infix notation, one must export
  -- both the type alias, and the infix notation where 'type' must precede
  -- the infix notation
  , ExportedTypeAlias_InfixNotation, type (<|<>|>)

  -- Data constructor alias; exporting the alias requires you
  -- to also export the constructor it aliases
  , ExportedDataType3_InfixNotation(Infix_Constructor), (<||||>)

  , ExportedKind
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

data ExportDataType2_AndAllOfItsConstructors
  = Constructor2A
  | Constructor2B
  | Constructor2C

type ExportedTypeAlias = Int

data ExportedDataType3_InfixNotation = Infix_Constructor Int Int

infixr 4 Infix_Constructor as <||||>

type ExportedTypeAlias_InfixNotation = String

infixr 4 type ExportedTypeAlias_InfixNotation as <|<>|>

data ExportedKind

foreign import data ExportedKindValue :: ExportedKind
