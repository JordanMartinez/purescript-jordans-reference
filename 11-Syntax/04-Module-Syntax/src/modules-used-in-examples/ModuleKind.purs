-- PureScript 0.13.x
module ModuleKind (kind ImportedKind, ImportedKindValue) where

-- PureScript 0.14.x
-- module ModuleKind (ImportedKind, ImportedKindValue) where

-- PureScript 0.13.x
foreign import kind ImportedKind
-- PureScript 0.14.x
-- data ImportedKind

foreign import data ImportedKindValue :: ImportedKind
