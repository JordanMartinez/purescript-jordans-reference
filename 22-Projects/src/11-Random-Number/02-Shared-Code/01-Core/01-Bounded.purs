module RandomNumber.Core.Bounded
  ( Bounds, mkBounds, unBounds, totalPossibleGuesses
  , BoundsCreationError(..), BoundsCheckError(..)

  , RandomInt, mkRandomInt

  , Guess, mkGuess
  , guessEqualsRandomInt, (==#)
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

totalPossibleGuesses :: Bounds -> Int
totalPossibleGuesses (Bounds {lower: l, upper: u}) = (abs $ u - l) + 1

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
derive newtype instance riE :: Eq RandomInt
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
