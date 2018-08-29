module ConsoleLessons.ErrorHandling.ViaPartial where

import Prelude
import Effect (Effect)
import Effect.Aff (Aff)
import Node.ReadLine (Interface)
import Node.ReadLine.CleanerInterface (createUseCloseInterface, question, log)

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

-- Used to indicate that one is using an partial function
-- in a (hopefully) safe way by passing only valid arguments to it.
-- In our example below, we will be passing invalid arguments to it.
import Partial.Unsafe (unsafePartial)


unsafeDivision :: Partial => Int -> Int -> String
unsafeDivision _ 0 = crash "You divided by zero!"
unsafeDivision x y = showResult x y (x / y)

showResult :: Int -> Int -> Int -> String
showResult numerator denominator result =
  (show numerator) <> " / " <> (show denominator) <> " == " <> (show result)

main :: Effect Unit
main = createUseCloseInterface (\interface -> do
    log "This program demonstrates how partial functions create unreliable \
        \code via the problem of division.\n\
        \Recall that the notation is: 'numerator / denominator'\
        \\n"

    calculateDivision interface
  )
  where
  calculateDivision :: Interface -> Aff Unit
  calculateDivision interface = do
    log $ "Enter two integers between 0 and 9... (invalid entry will be \
          \turned into '" <> show defaultValue <> "')\n"
    num <- mapToValidInt <$> question "Numerator:   " interface
    denom <- mapToValidInt <$> question "Denominator: " interface

    -- to call this function, we need to precede it with `unsafePartial`
    log $ unsafePartial $ unsafeDivision num denom

  defaultValue :: Int
  defaultValue = 0

  mapToValidInt :: String -> Int
  mapToValidInt = case _ of
    "0" -> 0
    "1" -> 1
    "2" -> 2
    "3" -> 3
    "4" -> 4
    "5" -> 5
    "6" -> 6
    "7" -> 7
    "8" -> 8
    "9" -> 9
    _ -> defaultValue
