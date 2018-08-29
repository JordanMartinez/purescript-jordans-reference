-- To get the "import RootModule.SubModule.SubModule" syntax
module Syntax.Module.ExportingModules
  ( module ModuleAlias
  ) where

-- We can use module alises to export multiple things
-- (e.g. types, constructors, functions, values)
-- from multiple modules conveniently

import Module1 (anInt1) as ModuleAlias
import Module2 (anInt2) as ModuleAlias
import Module3 (anInt3) as ModuleAlias

-- By convention, this is usually "Exports"
import Module4.SubModule1 (someFunction) as ModuleAlias

{-
This enables the syntax:
import Syntax.Module.ExportingModules (anInt, anInt2, anInt3, someFunction)

-- or we can use module aliases
import Syntax.Module.ExportingModules as EM

-- in code
EM.anInt
EM.someFunction
-}
