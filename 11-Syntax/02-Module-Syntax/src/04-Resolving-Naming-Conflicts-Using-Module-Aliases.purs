-- There are situations where a function in one module
-- may be the same name as a function in another module

-- for example
-- module ModuleF1 (sameFunctionName1) where -- ...
-- module ModuleF2 (sameFunctionName1) where -- ...

-- In this file, how do we use both of them?
-- We can use Module aliases
module Syntax.Module.ResolvingNamingConflicts.ViaModuleAliases where

import ModuleF1 as M1
import ModuleF2 as M2

myFunction2 :: Int -> Int
myFunction2 a = M1.sameFunctionName1 (M2.sameFunctionName1 a)
