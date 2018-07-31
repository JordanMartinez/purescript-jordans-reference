-- To get the "import RootModule.SubModule.SubModule" syntax
module ModuleName
  ( module M
  ) where

-- We can use module alises to export multiple modules conveniently

import Module1 as M
import Module2 as M
import Module3 as M
import Module4.SubModule1 as M
