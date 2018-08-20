-- There are situations where a function in one module
-- may be the same name as a function in another module

-- for example
-- module ModuleNameClash1 (sameFunctionName1) where -- ...
-- module ModuleNameClash2 (sameFunctionName1) where -- ...

-- In this file, how do we use both of them?
-- We can use the 'hiding' keyword
module Syntax.Module.ResolvingNamingConflicts.ViaHiding where

import ModuleNameClash1 (sameFunctionName1)
import ModuleNameClash2 hiding (sameFunctionName1)

-- now 'sameFunctionName1' refers to ModuleNameClash1's function,
-- not ModuleNameClash2's function
myFunction1 :: Int -> Int
myFunction1 a = sameFunctionName1 a
