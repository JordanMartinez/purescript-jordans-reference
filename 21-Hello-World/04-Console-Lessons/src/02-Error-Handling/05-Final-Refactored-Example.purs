module ConsoleLessons.ErrorHandling.FinalExample where

import Prelude
import Effect (Effect)
import Effect.Aff (Aff)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Node.ReadLine (Interface)
import Node.ReadLine.CleanerInterface (createUseCloseInterface, question, log)

-- (DivisionPosition, TextInputerror and DivisionError are at the bottom
-- of the file since we've already seen them and they aren't our current focus.)

{-
The beauty of FP programming is that one can look at the name
and type signature of a function and usually figure out what
the function's body is. As we've added more to our code,
`safeDivision` and its type signature has gotten farther
from this principle.

Beforehand, it was:
  Int -> Int -> Maybe Int

Now it is:
  Either TextInputError Int -> Either TextInputError Int -> String

Ideally, it should be
  Int -> Int -> Either DivisionError Int

Let's make that type signature our goal and change everything
else to account for it.

You probably already know what `safeDivision`'s implementation is going
to be just by the types.
-}

safeDivision :: Int-> Int -> Either DivisionError Int
safeDivision _ 0 = Left DividedByZero
safeDivision x y = Right $ x / y

{-
The source of our problem lies with `mapToValidInt`: it doesn't
check the user's input to insure that the user inputted a valid Int value
every time we query the user. Rather, it pushes the unchecked input
into `safeDivision` and expects that function to handle it. This is poor
programming because `safeDivision` is doing more than it should.

In our refactored approach, we will check the user's input and determine
how to progress from there:
  If the user's input is invalid (Either's Left instance), we have 2 options:
    Option 1. Ask the user again until we receive a valid input
    Option 2. Notify the user that input was invalid and stop the program
  If the user's input is valid, we continue executing the program.

For our example, we'll use Option 1 via the function `askUserForInt`
-}

askUserForInt :: String -> Interface -> Aff Int
askUserForInt prompt interface = do
  maybeInt <- mapToMaybeInt <$> question prompt interface
  case maybeInt of
    Just i -> do
      -- put the 'i' into the Aff monad, so we get it back out
      -- when we use "i <- askUserForInt args..." notation
      pure i
    Nothing -> do
      log "I'm sorry, but that is not a valid input. Please try again."
      -- loop until we get a valid answer.
      askUserForInt prompt interface

  where
  mapToMaybeInt :: String -> Maybe Int
  mapToMaybeInt = case _ of
    "0" -> Just 0
    "1" -> Just 1
    "2" -> Just 2
    "3" -> Just 3
    "4" -> Just 4
    "5" -> Just 5
    "6" -> Just 6
    "7" -> Just 7
    "8" -> Just 8
    "9" -> Just 9
    _   -> Nothing

main :: Effect Unit
main = createUseCloseInterface (\interface -> do
    log "This program demonstrates how to handle errors using `Either a b` \
        \and custom types that indicate errors. It uses a refactored \
        \version of `safeDivision`.\n\
        \Recall that the notation is: 'numerator / denominator'\
        \\n"

    calculateDivision interface
  )
  where
  calculateDivision :: Interface -> Aff Unit
  calculateDivision interface = do
    log $ "Enter two integers between 0 and 9... (invalid entry will be \
          \turned into an error message and printed to the console)\n"
    numerator   <- askUserForInt "Numerator:   " interface
    denominator <- askUserForInt "Denominator: " interface
    case safeDivision numerator denominator of
      Right result -> log $ showResult numerator denominator result
      Left error -> log $ show error

showResult :: Int -> Int -> Int -> String
showResult numerator denominator result =
  (show numerator) <> " / " <> (show denominator) <> " == " <> (show result)

-- We see through this approach that we no longer need
-- `DivisionPosition` or `TextInputError`. They have been removed entirely.

data DivisionError = DividedByZero

instance divisionErrorShow :: Show DivisionError where
  show DividedByZero = "Error: you attempted to divide by zero!"
