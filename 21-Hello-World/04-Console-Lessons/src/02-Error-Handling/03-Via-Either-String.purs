module ConsoleLessons.ErrorHandling.ViaEitherString where

import Prelude
import Effect (Effect)
import Effect.Aff (Aff)
import Node.ReadLine (Interface)
import ReadLine.CleanerInterface (createUseCloseInterface, question, log)

-- new imports
import Data.Either (Either(..))

-- `Maybe` is useful when we don't care about the error.
-- However, what if we do? In such cases, we use `Either:`

data Either_ a b  -- a type that is either 'a' or 'b'
  = Left_ a         -- the 'a' / failure type
  | Right_ b        -- the 'b' / success type

{-
Returning to our previous example, let's focus on the `mapToInt` function.

mapToValidInt :: String -> Int
mapToValidInt = case _ of
  "0" -> 0
  ...
  "9" -> 9
  _   -> 10

What if we wanted to tell the user why the input was invalid?
We could map the user's input (String) into an `Either a Int` where the 'a'
is a String that says what is wrong with the user's input.
-}

mapToValidInt :: String -> Either String Int
mapToValidInt = case _ of
  "0" -> Right 0
  "1" -> Right 1
  "2" -> Right 2
  "3" -> Right 3
  "4" -> Right 4
  "5" -> Right 5
  "6" -> Right 6
  "7" -> Right 7
  "8" -> Right 8
  "9" -> Right 9
  _ -> Left "Error: User inputted text that was not an integer between 0 and 9"

{-
This means we'll need to update the type signature of `safeDivision` to accept
`Either String Int` as its argument.

To make it easier to print to the screen in the `calculateDivision` function,
we'll also change `safeDivision`'s output type to `String`
and return the error message or the result of the division.
-}

safeDivision :: Either String Int -> Either String Int -> String
safeDivision (Left invalidNum) _ = "Numerator " <> invalidNum
safeDivision _ (Left invalidDenom) = "Denominator " <> invalidDenom
safeDivision (Right _) (Right 0) = "Error: Attempted to divide by zero!"
safeDivision (Right x) (Right y) = showResult x y (x / y)

main :: Effect Unit
main = createUseCloseInterface (\interface -> do
    log "This program demonstrates how to handle errors using `Either a b` \
        \and Strings to indicate errors.\n\
        \Recall that the notation is: 'numerator / denominator'\
        \\n"

    calculateDivision interface
  )
  where
  calculateDivision :: Interface -> Aff Unit
  calculateDivision interface = do
    log $ "Enter two integers between 0 and 9... (invalid entry will be \
          \turned into an error message and printed to the console)\n"
    numerator <- mapToValidInt <$> question "Numerator:   " interface
    denominator <- mapToValidInt <$> question "Denominator: " interface
    log $ safeDivision numerator denominator

showResult :: Int -> Int -> Int -> String
showResult numerator denominator result =
  (show numerator) <> " / " <> (show denominator) <> " == " <> (show result)
