module ConsoleLessons.ErrorHandling.ViaPartial where

import Prelude
import Effect (Effect)
import Node.ReadLine.CleanerInterface (createUseCloseInterface, log)
import ConsoleLessons.ErrorHandling.DivisionTemplate (showResult, askUserForNumerator, askUserForDenominator)

{-
A total function is a function that ALWAYS outputs a value
for every input it can receive

A partial function is a function that SOMETIMES outputs a value
for every input it can receive. In other words, sometimes
it cannot return a value when given specific arguments.
In such situations, it usually returns `null` or throws an Error/Exception.

A good example is division:

  | Expression | Outputs
  -----------------------------
  | 5 / 1      | Valid value
  | x / 0      | ???
-}
-- new imports
-- Used when a function cannot return a valid value
import Partial (crash)

-- Used to indicate that one is using a partial function
-- in a (hopefully) safe way by passing only valid arguments to it.
-- In our example below, we will be passing invalid arguments to it.
import Partial.Unsafe (unsafePartial)


unsafeDivision :: Partial => Int -> Int -> String
unsafeDivision _ 0 = crash "You divided by zero!"
unsafeDivision x y = showResult x y (x / y)

-- Run this program and divide by zero to see what happens.
main :: Effect Unit
main = createUseCloseInterface (\interface ->
  do
    log "This program demonstrates how partial functions create unreliable \
        \code via the problem of division.\n\
        \Recall that the notation is: 'numerator / denominator'\
        \\n"

    num <- askUserForNumerator interface
    denom <- askUserForDenominator interface

    -- to call a Partial function, we need to precede it with `unsafePartial`
    log $ unsafePartial $ unsafeDivision num denom
  )
