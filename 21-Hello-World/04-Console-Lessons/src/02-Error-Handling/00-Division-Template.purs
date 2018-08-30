-- | This module exists so we do not need to rewrite the same code
-- | in every file hereafter in this folder. Rather, we can import
-- | the boilerplate written here into the upcoming files and
-- | focus on the point we're tryiing to teach.
module ConsoleLessons.ErrorHandling.DivisionTemplate
  ( showResult
  , askUserForNumerator
  , askUserForDenominator
  -- `mapToValidInt`, `defaultValue`, and `askUserForInt` are not exported
  ) where

import Prelude
import Effect.Aff (Aff)
import Node.ReadLine (Interface)
import Node.ReadLine.CleanerInterface (question, log)


-- | Prints "numerator / denominator == result"
showResult :: Int -> Int -> Int -> String
showResult numerator denominator result =
  (show numerator) <> " / " <> (show denominator) <> " == " <> (show result)

-- | Takes the user's input and maps it to the corresponding Int, or the
-- | defaultValue if input is invalid (e.g. "non-int value")
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

defaultValue :: Int
defaultValue = 0


askUserForNumerator :: Interface -> Aff Int
askUserForNumerator interface = askUserForInt "Numerator: " interface

askUserForDenominator :: Interface -> Aff Int
askUserForDenominator interface = askUserForInt "Denominator: " interface

askUserForInt :: String -> Interface -> Aff Int
askUserForInt message interface = do
  log $ ("Enter an integer between 0 and 9... (invalid entry will be \
        \turned into '" <> show defaultValue <> "')\n")
  i <- mapToValidInt <$> question message interface
  log $ "Value received: " <> show i <> "\n"

  pure i
