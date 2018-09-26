-- | This modules defines compiler-time types to enable
-- | the compiler to catch any accidental misuse of the
-- | respective arguments (i.e. the Core)
-- |
-- | Rather than allowing anyone to create these objects
-- | by exporting their data constructors, we export smart constructors.
-- | One must use the `mk[TypeName]` function to create a validated object
-- | and the `un[TypeName]` function to use the validated object.
-- | Thus, data validation is handled correctly in this module as well
-- | (i.e. the Domain)
module Games.RandomNumber.Core
  ( Bounds, mkBounds, unBounds, showTotalPossibleGuesses
  , BoundsCreationError(..), BoundsCheckError(..)

  , RandomInt, mkRandomInt

  , Guess, mkGuess
  , guessEqualsRandomInt, (==#)

  , Count, mkCount, decrement, outOfGuesses
  , CountCreationError(..)
  )
  where

import Prelude
import Data.Ord (abs)
import Data.Either(Either(..))

------ Bounds ------

-- | An object whose `lower` value is always less than its `upper` value
newtype Bounds = Bounds { lower :: Int
                        , upper :: Int }
instance bs :: Show Bounds where
  show (Bounds {lower: l, upper: u}) =
    show l <> " and " <> show u

data BoundsCreationError = EmptyBoundaryRange Int Int
instance bes :: Show BoundsCreationError where
  show (EmptyBoundaryRange x y) =
    "The defined boundares, " <> show x <> " and " <> show y <>
    ", are equal, which means the random number is no longer random."

-- | Creates a Bounds object only if the two Ints are unequal. This
-- | function accounts for `x < y` and `x > y`.
mkBounds :: Int -> Int -> Either BoundsCreationError Bounds
mkBounds x y
  | x < y = Right $ Bounds { lower: x, upper: y}
  | x > y = Right $ Bounds { lower: y, upper: x}
  | otherwise = Left $ EmptyBoundaryRange x y

unBounds :: forall a. Bounds -> (Int -> Int -> a) -> a
unBounds (Bounds {lower: l, upper: u}) f = f l u

showTotalPossibleGuesses :: Bounds -> String
showTotalPossibleGuesses (Bounds {lower: l, upper: u}) =
  show $ (abs $ u - l) + 1

data BoundsCheckError = NotWithinBounds Bounds Int
instance bces :: Show BoundsCheckError where
  show (NotWithinBounds b i) =
    "Integer, " <> show i <> ", is not within the bounds, " <> show b

-- | Helper function for validating an Int.
withinBounds :: Bounds -> Int -> Either BoundsCheckError Int
withinBounds bounds@(Bounds {lower: l, upper: u}) i
  | between l u i = Right i
  | otherwise = Left $ NotWithinBounds bounds i

------ Random Int ------

newtype RandomInt = RandomInt Int
instance ris :: Show RandomInt where
  show (RandomInt i) = show i

mkRandomInt :: Bounds -> Int -> Either BoundsCheckError RandomInt
mkRandomInt bounds randomInt =
  -- If the value returned is `Right i`, change it to `Right $ RandomInt i`
  RandomInt <$> withinBounds bounds randomInt

------ Guess ------

newtype Guess = Guess Int
instance gs :: Show Guess where
  show (Guess i) = show i

mkGuess :: Bounds -> Int -> Either BoundsCheckError Guess
mkGuess bounds i = Guess <$> withinBounds bounds i

guessEqualsRandomInt :: Guess -> RandomInt -> Boolean
guessEqualsRandomInt (Guess i) (RandomInt r) = i == r

-- since this is basically `Eq` between two types,
-- we're using the same precedence as Eq's eq/== function
infix 4 guessEqualsRandomInt as ==#

------ Count ------

-- | Newtype wrapper for wrapping the remaining guesses the player has
-- | until the player loses the game. Note, rather than defining `unCount`,
-- | one should use `useGuess`, which reduces the count by one automatically.
newtype Count = Count Int
instance cs :: Show Count where
  show (Count i) = show i

data CountCreationError = NotPositiveInteger
instance cces :: Show CountCreationError where
  show _ = "User did not input a positive integer."

mkCount :: Int -> Either CountCreationError Count
mkCount i | i <= 0    = Left NotPositiveInteger
          | otherwise = Right $ Count i

decrement :: Count -> Count
decrement (Count n) = Count (n - 1)

outOfGuesses :: Count -> Boolean
outOfGuesses (Count i) = i == 0
