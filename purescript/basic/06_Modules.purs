module ModuleName
  -- things that can be imported by others
  ( function  -- via "import ModuleName (function)""
  , DataName -- via "import ModuleName (dataName)"

  -- exports a type, but not its constructors
  , TypeName -- via import ModuleName (TypeName)

  , TypeNameWithAllConstructors(..)
  , TypeNameAndOneConstructor(Constructor1B)

  -- if exporting a type class, must also export functions
  , class TypeClass, typeClassfunctionName
  , kind KindName
  , module Module -- re-export Module that is imported below
  , module UsefulModules -- re-export multiple modules using only one name
  ) where

-- imports just the module
import Module
import Module.SubModule.SubSubModule
-- imports functions from the module
import ModuleFunctions (function1, function2, function3)
-- imports type class from the module
import ModuleTypeClass (class TypeClass)
-- alias to the module
import ModuleName as ModuleAlias
-- prevent import conflicts
import ConflictingModule1 (sameFunctionName) -- imported
import ConflictingModule2 hiding (sameFunctionName) -- not imported
-- import all data constructor for a given type
import Module (TypeConstructor(..))

import HelperFunctionsModule as UsefulModules
import HelperDatatypesModule as UsefulModules

import TotalModule (DataOrTypeAliasName, functionName, class TypeClassName)

data DataName = Data

type TypeName = Int

data TypeNameWithAllConstructors
  = Constructor1A
  | Constructor2A

data TypeNameAndOneConstructor
  = Constructor1B
  | Constructor2B

function :: String -> String
function x = x

class TypeClass a where
  typeClassFunctionName :: a -> String
