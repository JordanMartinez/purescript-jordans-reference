{-
There are situations where a function in one module
may be the same name as a function in another module

For example
  module ModuleNameClash1 (sameFunctionName1) where -- ...
  module ModuleNameClash2 (sameFunctionName1) where -- ...

This can also arise when data type share the same name:
  module ModuleNameClash1 (SameDataName(..)) where
  module ModuleNameClash2 (SameDataName(..)) where

In this file, how do we use both of them?
We can use Module aliases -}
module Syntax.Module.ResolvingNamingConflicts.ViaModuleAliases where

import ModuleNameClash1 as M1
import ModuleNameClash2 as M2

myFunction2 :: Int -> Int
myFunction2 a = M1.sameFunctionName1 (M2.sameFunctionName1 a)

dataDifferences :: M1.SameDataName -> M2.SameDataName -> String
dataDifferences M1.Constructor M2.Constructor = "code works despite name clash"
