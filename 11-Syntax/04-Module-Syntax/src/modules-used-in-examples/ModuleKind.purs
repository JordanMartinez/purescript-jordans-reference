module ModuleKind (kind ImportedKind, ImportedKindValue) where

foreign import kind ImportedKind

foreign import data ImportedKindValue :: ImportedKind
