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

  -- The type is exported, but no one can create an value of it
  -- outside of this module
  , ExportDataType1_ButNotItsConstructors

  -- The type is exported and only one of its constructors is exported. Thus,
  -- everyone else can create a `Constructor2A' value but not a
  -- `Constructor2B` value. That one can only be created inside this module.
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

  , module Exports

  -- export all entities in this module by exporting itself
  , module Syntax.Module.FullExample

  -- Kinds require the `kind` keyword to precede them
  , kind ExportedKind
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

-- import a kind and its value
import ModuleKind (kind ImportedKind, ImportedKindValue)

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
