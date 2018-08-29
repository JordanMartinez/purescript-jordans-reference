module Syntax.Module.Basic
  (
  -- exports appear here
  exportedFunction
  ) where

-- imports must appear at the top or you'll get a compiler error
import Prelude

-- everything else in the module goes underneath it

exportedFunction :: String -> String
exportedFunction x = x <> "more stuff"

-- an import cannot go here since we are no longer
-- in the "import section" of the file

notExportedValue :: Int
notExportedValue = 3
