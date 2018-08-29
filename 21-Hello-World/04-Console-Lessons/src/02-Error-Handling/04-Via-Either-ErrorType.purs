module ConsoleLessons.ErrorHandling.ViaEitherErrorType where

import Prelude
import Effect (Effect)
import Effect.Aff (Aff)
import Data.Either (Either(..))
import Node.ReadLine (Interface)
import Node.ReadLine.CleanerInterface (createUseCloseInterface, question, log)

{-
The previous file demonstrates how to use "Either String a" for error handling.
The problem with this approach is that error type isn't type-safe.
In other words, why use Strings when we could define our own error types?

Creating our own error types has these benefits:
  - Less bugs / runtime errors: the program works or it fails to compile
  - Self-documenting errors: all possible errors (instances) are grouped
      under a human-readable type, not an error number that requires a lookup,
      or a String that is subject to modification

Thus, we'll define a type for our DivisionError:
-}

data DivisionError = DividedByZero

-- Then we'll make it printable to the screen
instance divisionErrorShow :: Show DivisionError where
  show DividedByZero = "Error: you attempted to divide by zero!"

-- We'll update `safeDivision` to return the error type rather than a String
safeDivision :: Int -> Int -> Either DivisionError Int
safeDivision _ 0 = Left DividedByZero
safeDivision x y = Right (x / y)

main :: Effect Unit
main = createUseCloseInterface (\interface -> do
    log "This program demonstrates how to handle errors using `Either a b` \
        \and custom types that indicate errors.\n\
        \Recall that the notation is: 'numerator / denominator'\
        \\n"

    calculateDivision interface
  )
  where
  calculateDivision :: Interface -> Aff Unit
  calculateDivision interface = do
    log $ "Enter two integers between 0 and 9... (invalid entry will be \
          \turned into an error message and printed to the console)\n"
    numerator   <- mapToValidInt <$> question "Numerator:   " interface
    denominator <- mapToValidInt <$> question "Denominator: " interface
    case safeDivision numerator denominator of
      Left error -> log $ show error
      Right result -> log $ showResult numerator denominator result

  defaultValue :: Int
  defaultValue = 10

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

showResult :: Int -> Int -> Int -> String
showResult numerator denominator result =
  (show numerator) <> " / " <> (show denominator) <> " == " <> (show result)
