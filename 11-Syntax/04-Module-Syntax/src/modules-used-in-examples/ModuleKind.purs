module ModuleKind (kind ImportedKind, ImportedKindInstance) where

foreign import kind ImportedKind

foreign import data ImportedKindInstance :: ImportedKind
