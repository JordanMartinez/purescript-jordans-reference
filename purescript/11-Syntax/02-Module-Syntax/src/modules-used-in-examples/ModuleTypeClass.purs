module ModuleTypeClass (class TypeClass, functionName) where

import Prelude

class TypeClass a where
  functionName :: a -> String
