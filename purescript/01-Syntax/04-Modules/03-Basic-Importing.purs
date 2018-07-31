module ModuleName where

-- imports just the module
import Module

-- import a submodule
import Module.SubModule.SubSubModule

-- import values from a module
import ModuleValues (value1, value2)

-- imports functions from a module
import ModuleFunctions (function1, function2, function3)

-- imports function alias from a module
import ModuleFunctionAliases ((/=), (===), (>>**>>))

-- imports type class from the module
import ModuleTypeClass (class TypeClass)

-- import a type but none of its constructors
import ModuleDataKeyword (DataType)

-- import a type and one of its constructors
import ModuleDataKeyword (DataType(Constructor1))

-- import a type and some of its constructors
import ModuleDataKeyword (DataType(Constructor1, Constructor2))

-- import a type and all of its constructors
import ModuleDataKeyword (DataType(..))
