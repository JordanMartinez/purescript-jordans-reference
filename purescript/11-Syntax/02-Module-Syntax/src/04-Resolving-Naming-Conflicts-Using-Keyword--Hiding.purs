-- There are situations where a function in one module
-- may be the same name as a function in another module

-- for example
-- module ModuleF1 (sameFunctionName1) where -- ...
-- module ModuleF2 (sameFunctionName1) where -- ...

-- In this file, how do we use both of them?
-- We can use the 'hiding' keyword
module Syntax.Module.ResolvingNamingConflicts.ViaHiding where

import ModuleF1 (sameFunctionName1)
import ModuleF2 hiding (sameFunctionName1)

-- now 'sameFunctionName1' refers to ModuleF1's function, not ModuleF2's function
myFunction1 :: Int -> Int
myFunction1 a = sameFunctionName1 a
