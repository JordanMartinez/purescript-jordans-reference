module Syntax.Basic.Typeclass.Special.Partial where

-- This function is imported from the `purescript-partial` library.
import Partial.Unsafe (unsafePartial)

-- Normally, the compiler will require a function to always exhaustively
-- pattern match on a given type. In other words, the function is "total."

data TwoValues = Value1 | Value2

renderTwoValues :: TwoValues -> String
renderTwoValues = case _ of
  Value1 -> "Value1"
  Value2 -> "Value2"

-- In the above example, removing the line with `Value2 -> "Value2"`
-- from the source code would result in a compiler error as the function
-- would no longer be "total" but "partial."
-- However, there may be times when we wish to remove that compiler restriction.
-- This can occur when we know that a non-exhaustive pattern match will
-- not fail or when we wish to write more performant code that only works
-- when the function has a valid argument.

-- In such situations, we can add the `Partial` type class constraint
-- to indicate that a function is no longer a "total" function but is now
-- a "partial" function. In othe rwords, the pattern match is no longer
-- exhaustive. If someone calls the function with an invalid invalid argument,
-- it will produce a runtime error.

renderFirstValue :: Partial => TwoValues -> String
renderFirstValue Value1 = "Value1"
        -- There is no `Value2` line here!

-- When we wish to call partial functions, we must remove that `Partial`
-- type class constraint by using the function `unsafePartial`.

-- unsafePartial :: forall a. (Partial a => a) -> a

callWithNoErrors_renderFirstValue :: String
callWithNoErrors_renderFirstValue = unsafePartial (renderFirstValue Value1)

-- Uncomment this code and run it in the REPL. It will produce a runtime error.
callWithRuntimeErrors_renderFirstValue :: String
callWithRuntimeErrors_renderFirstValue =
  unsafePartial (renderFirstValue Value2)
