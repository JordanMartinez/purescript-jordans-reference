module ModuleNameClash2 (sameFunctionName1, SameDataName(..)) where

import Prelude

sameFunctionName1 :: Int -> Int
sameFunctionName1 x = x + 4

data SameDataName = Constructor
