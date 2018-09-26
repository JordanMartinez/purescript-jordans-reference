module Games.RandomNumber.Domain
  ( GameInfo(..), mkGameInfo, getRandomInt
  , GameResult(..)
  , GameF(..), Game
  , game
  ) where

import Prelude
import Data.Tuple (Tuple(..))
import Games.RandomNumber.Core (Bounds, RandomInt, Guess, Count)
import Control.Monad.Free (Free, liftF)

newtype GameInfo
  = GameInfo { bound :: Bounds
             , number :: RandomInt
             }

-- | Convenience function for easily creating a GameInfo object
mkGameInfo :: Bounds -> RandomInt -> GameInfo
mkGameInfo b r =
  GameInfo { bound: b, number: r }

getRandomInt :: GameInfo -> RandomInt
getRandomInt (GameInfo { bound: _, number: n }) = n

-- | Sum type that defines the number of remaining guesses
-- | the player had before they won, or the random integer
-- | if they lost.
data GameResult
  = PlayerWins Count
  | PlayerLoses RandomInt

-- | High-level overview of our game's control flow
data GameF a
  = ExplainRules a
  | SetupGame (Tuple GameInfo Count -> a)
  | PlayGame GameInfo Count (GameResult -> a)
  | EndGame GameResult a

type Game = Free GameF

explainRules :: Game Unit
explainRules = liftF $ (ExplainRules unit)

setupGame :: Game (Tuple GameInfo Count)
setupGame = liftF $ (SetupGame identity)

playGame :: GameInfo -> Count -> Game GameResult
playGame info count = liftF $ (PlayGame info count identity)

endGame :: GameResult -> Game Unit
endGame result = liftF $ (EndGame result unit)

game :: Game Unit
game = do
  explainRules
  Tuple info count <- setupGame
  result <- playGame info count
  endGame result
