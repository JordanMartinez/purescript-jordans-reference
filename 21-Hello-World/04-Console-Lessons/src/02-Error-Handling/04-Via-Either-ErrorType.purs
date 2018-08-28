module ConsoleLessons.ErrorHandling.ViaEitherErrorType where

import Prelude
import Effect (Effect)
import Effect.Aff (Aff)
import Data.Either (Either(..))
import Node.ReadLine (Interface)
import ReadLine.CleanerInterface (createUseCloseInterface, question, log)

{-
The previous file demonstrates how to use Either for error handling.
However, we needed to modify the error message, so that the user
would know which input, the numerator or the denominator,
was the invalid entry. Moreover, we had two different error types in
the same function. Below is a copy of what we wrote:
-}

-- safeDivision using Strings
safeDiv :: Either String Int -> Either String Int -> String
                            -- valid text input error: message is modified...
safeDiv (Left invalidNum) _ = "Numerator " <> invalidNum
                            -- valid text input error: message is modified...
safeDiv _ (Left invalidDenom) = "Denominator " <> invalidDenom
                            -- division error: unrelated to above 2 errors
safeDiv (Right _) (Right 0) = "Error: Attempted to divide by zero!"
safeDiv (Right x) (Right y) = showResult x y (x / y)

{-
The problem with this approach is that it isn't type-safe. Why use Strings
in the first place when we could define our own types that prevent the program
from compiling unless they are correct? Additionally, we get
self-documenting errors.

We'll define three new types that are self-explanatory:
-}
data DivisionPosition
  = Numerator
  | Denominator

data TextInputError = InvalidInput DivisionPosition

data DivisionError = DividedByZero

-- Then we'll define their `Show` instances so they can be
-- outputted to the console:
instance divPosShow :: Show DivisionPosition where
  show Numerator = "Numerator"
  show Denominator = "Denominator"

instance textInputErrorShow :: Show TextInputError where
  show (InvalidInput divPos) = "Error: User inputted text that was not an \
                               \integer between 0 and 9 for 'safeDivion's " <>
                               show divPos <>" position."

instance divisionErrorShow :: Show DivisionError where
  show DividedByZero = "Error: you attempted to divide by zero!"

-- and now we can update the functions to account for these new changes:
--
-- `mapToValidInt` should return an `Either TextInputError Int`. Since
-- we don't know which `DivisionPosition` is being used for the text input,
-- we'll require the caller to know by adding it as an argument.
mapToValidInt :: String -> DivisionPosition -> Either TextInputError Int
mapToValidInt = case _, _ of
  "0", _ -> Right 0
  "1", _ -> Right 1
  "2", _ -> Right 2
  "3", _ -> Right 3
  "4", _ -> Right 4
  "5", _ -> Right 5
  "6", _ -> Right 6
  "7", _ -> Right 7
  "8", _ -> Right 8
  "9", _ -> Right 9
  _, divPos -> Left $ InvalidInput divPos

{-
`safeDivision` has to receive `Either TextInputError Int` as its arguments now.
We'll continue to output either the error message or the result of division.
-}
safeDivision :: Either TextInputError Int
             -> Either TextInputError Int
             -> String
safeDivision (Left invalidNum) _ = show invalidNum
safeDivision _ (Left invalidDenom) = show invalidDenom
safeDivision (Right _) (Right 0) = show DividedByZero
safeDivision (Right x) (Right y) = showResult x y (x / y)

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
    numerator   <- mapToValidNum   <$> question "Numerator:   " interface
    denominator <- mapToValidDenom <$> question "Denominator: " interface
    log $ safeDivision numerator denominator

  -- Convenience functions that provide the correct `DivisionPosition` instance
  mapToValidNum :: String -> Either TextInputError Int
  mapToValidNum s = mapToValidInt s Numerator

  mapToValidDenom :: String -> Either TextInputError Int
  mapToValidDenom s = mapToValidInt s Denominator

showResult :: Int -> Int -> Int -> String
showResult numerator denominator result =
  (show numerator) <> " / " <> (show denominator) <> " == " <> (show result)
