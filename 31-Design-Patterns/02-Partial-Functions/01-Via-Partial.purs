module PartialFunctions.ViaPartial where

import Prelude

-- new imports
-- Used when a function cannot return a valid value
import Partial (crash)

-- Used to indicate that one is using a partial function
-- in a (hopefully) safe way by passing only valid arguments to it.
-- In our example below, we will be passing invalid arguments to it.
import Partial.Unsafe (unsafePartial)

-- Run this program and divide by zero to see what happens.
unsafeDivision :: Partial => Int -> Int -> String
unsafeDivision _ 0 = crash "You divided by zero!"
unsafeDivision x y = showResult x y (x / y)
