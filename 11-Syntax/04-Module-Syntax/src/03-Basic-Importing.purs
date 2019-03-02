-- For now, ignore the `module Exports` export
-- and the "import Module (value) as Exports" syntax
-- This will be explained later and is necessary now
-- to prevent the compiler from emitting lots of warnings.
module Syntax.Module.Importing (module Exports) where

-- One never just imports the entire module.
-- Rather, one must specify what is being imported.
-- The following import statements emit a compiler warning:
-- import Module
-- import Module.SubModule.SubSubModule

-- import values from a module
import ModuleValues (value1, value2) as Exports

-- imports functions from a module
import ModuleFunctions (function1, function2) as Exports

-- imports function alias from a module
import ModuleFunctionAliases ((/=), (===), (>>**>>)) as Exports

-- imports type class from the module
import ModuleTypeClass (class TypeClass) as Exports

-- import a type but none of its constructors
import ModuleDataType (DataType) as Exports

-- import a type and one of its constructors
import ModuleDataType (DataType(Constructor1)) as Exports

-- import a type and some of its constructors
import ModuleDataType (DataType(Constructor1, Constructor2)) as Exports

-- import a type and all of its constructors
import ModuleDataType (DataType(..)) as Exports

-- import a kind and its value
import ModuleKind (kind ImportedKind, ImportedKindValue) as Exports

-- To prevent warnings from being emitted during compilation
-- the above imports have to either be used here or
-- re-exported (explained later in this folder).
