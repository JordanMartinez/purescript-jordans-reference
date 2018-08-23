module ModuleNameClash1 (sameFunctionName1, SameDataName(..)) where

import Prelude

sameFunctionName1 :: Int -> Int
sameFunctionName1 x = x + 2

data SameDataName = Constructor
