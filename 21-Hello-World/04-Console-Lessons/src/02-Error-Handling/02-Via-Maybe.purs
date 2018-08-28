module ConsoleLessons.ErrorHandling.ViaMaybe where

import Prelude
import Effect (Effect)
import Effect.Aff (Aff)
import Node.ReadLine (Interface)
import ReadLine.CleanerInterface (createUseCloseInterface, question, log)

{-
We can often turn our partial functions into total functions
by changing the output type from `OuputType` to `Maybe OutputType`:
-}

-- new imports
import Data.Maybe (Maybe(..))

data Maybe_ a   -- a type that indicates an instance of 'a' might exist
  = Nothing_      -- a box with nothing in it (empty box)
  | Just_ a       -- a box with 'just' an instance of "a" in it

{-
`Maybe` is often used in situations where
  - a function might return `null`.
  - we don't need to do anything with the error itself.

Using our example of division:

  | Expression | Explanation   | OO returns | FP returns |
  --------------------------------------------------------
  | 5 / 1      | Valid value   | 5          | Just 5
  | x / 0      | Invalid value | null       | Nothing

The following function, safeDivision, demonstrates this:
-}

safeDivision :: Int -> Int -> Maybe Int
safeDivision _ 0 = Nothing -- x / 0
safeDivision x y = Just (x / y)

main :: Effect Unit
main = createUseCloseInterface (\interface -> do
    log "This program demonstrates how to handle errors using `Maybe a`.\n\
        \Recall that the notation is: 'numerator / denominator'\
        \\n"

    calculateDivision interface
  )
  where
  calculateDivision :: Interface -> Aff Unit
  calculateDivision interface = do
    log $ "Enter two integers between 0 and 9... (invalid entry will be \
          \turned into the number '" <> show defaultValue <> "')\n"
    num   <- mapToValidInt <$> question "Numerator:   " interface
    denom <- mapToValidInt <$> question "Denominator: " interface
    case safeDivision num denom of
      Just result -> log $ showResult num denom result
      Nothing -> log "You divided by zero!"

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
