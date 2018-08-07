-- There are situations where a function in one module
-- may be the same name as a function in another module

-- for example
-- In a separate file named "Module1.purs"
module Module1 (function) where -- ...
-- and in another separate file named "Module2.purs"
module Module2 (function) where -- ...

-- In this file (named "ModuleName.purs"), how do we use both of them?
-- We can use Module aliases
module ModuleName where

import Module1 as M1
import Module2 as M2

myFunction :: forall a b. a -> b
myFunction a = M1.function (M2.function a)

-- In this file (named "ModuleNameAgain.purs"), how do we import both, but
-- only one one of them? We can use the 'hiding' keyword
module ModuleName where

import Module1 (function)
import Module2 hiding (function)

-- now 'function' refers to Module1's function, not Module2's function
myFunction :: forall a b. a -> b
myFunction a = function a
