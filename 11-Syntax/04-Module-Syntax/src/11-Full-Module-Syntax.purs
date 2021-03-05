module Syntax.Module.FullExample
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

-- imports just the module
import Module

-- import a submodule
import Module.SubModule.SubSubModule

-- import values from a module
import ModuleValues (value1, value2)

-- imports functions from a module
import ModuleFunctions (function1, function2)

-- imports function alias from a module
import ModuleFunctionAliases ((/=), (===), (>>**>>))

-- imports type class from the module
import ModuleTypeClass (class TypeClass)

-- import a type but none of its constructors
import ModuleDataType (DataType)

-- import a type and one of its constructors
import ModuleDataType (DataType(Constructor1))

-- import a type and some of its constructors
import ModuleDataType (DataType(Constructor1, Constructor2))

-- import a type and all of its constructors
import ModuleDataType (DataType(..))

-- resolve name conflicts using "hiding" keyword
import ModuleNameClash1 (sameFunctionName1)
import ModuleNameClash2 hiding (sameFunctionName1)

-- resolve name conflicts using module aliases
import ModuleNameClash1 as M1
import ModuleNameClash2 as M2

-- Re-export modules
import Module1 (anInt1) as Exports
import Module2 (anInt2) as Exports
import Module3 (anInt3) as Exports
import Module4.SubModule1 (someFunction) as Exports

import ModuleKind (ImportedKind, ImportedKindValue) as Exports

import Prelude

import ExportedModule

-- To prevent warnings from being emitted during compilation
-- the above imports have to either be used here or
-- re-exported (explained later in this folder).

value :: Int
value = 3

function :: String -> String
function x = x

infix 4 function as >@>>>

class TypeClass a where
  tcFunction :: a -> a -> a

-- now 'sameFunctionName1' refers to ModuleF1's function, not ModuleF2's function
myFunction1 :: Int -> Int
myFunction1 a = sameFunctionName1 a

myFunction2 :: Int -> Int
myFunction2 a = M1.sameFunctionName1 (M2.sameFunctionName1 a)

dataDifferences :: M1.SameDataName -> M2.SameDataName -> String
dataDifferences M1.Constructor M2.Constructor = "code works despite name clash"

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
