module ConsoleLessons.ErrorHandling.ViaEitherString where

import Prelude
import Effect (Effect)
import Effect.Aff (Aff)
import Node.ReadLine (Interface)
import Node.ReadLine.CleanerInterface (createUseCloseInterface, question, log)

-- new imports
import Data.Either (Either(..))

-- `Maybe` is useful when we don't care about the error.
-- However, what if we do? In such cases, we use `Either:`

data Either_ a b  -- a type that is either 'a' or 'b'
  = Left_ a         -- the 'a' / failure type
  | Right_ b        -- the 'b' / success type

{-
In this next example, we'll use a different way to notify the user
that the user attempted to divide by zero. Rather than returning `Nothing`
for the "divide by zero" error, we'll return a String with the error message.
-}

safeDivision :: Int -> Int -> Either String Int
safeDivision _ 0 = Left "Error: Attempted to divide by zero!"
safeDivision x y = Right (x / y)

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
    case safeDivision numerator denominator of
      Left error -> log error
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
