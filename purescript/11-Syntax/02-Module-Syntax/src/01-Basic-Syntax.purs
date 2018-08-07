module Syntax.Module.Basic (exportedFunction) where

-- imports (by convention) appear at the top
import Prelude

-- everything else in the module (by convention) goes underneath it

exportedFunction :: String -> String
exportedFunction x = x <> "more stuff"

notExportedValue :: Int
notExportedValue = 3
