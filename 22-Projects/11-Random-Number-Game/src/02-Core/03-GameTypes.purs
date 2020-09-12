module RandomNumber.Core.GameTypes
  ( GameInfo, mkGameInfo
  , GameResult(..)
  ) where

import Prelude
import RandomNumber.Core.Bounded (Bounds, RandomInt)
import RandomNumber.Core.RemainingGuesses (RemainingGuesses)

type GameInfo = { bound :: Bounds
                , number :: RandomInt
                , remaining :: RemainingGuesses
                }

-- | Convenience function for easily creating a GameInfo object
mkGameInfo :: Bounds -> RandomInt -> RemainingGuesses -> GameInfo
mkGameInfo bounds number remaining =
  { bound: bounds, number: number, remaining: remaining }

-- | Sum type that defines the number of remaining guesses
-- | the player had before they won, or the random integer
-- | if they lost.
data GameResult
  = PlayerWins RemainingGuesses
  | PlayerLoses RandomInt

derive instance grE :: Eq GameResult

instance grs :: Show GameResult where
  show (PlayerWins rg) = "PlayerWins(" <> show rg <> ")"
  show (PlayerLoses ri) = "PlayerLoses(" <> show ri <> ")"
