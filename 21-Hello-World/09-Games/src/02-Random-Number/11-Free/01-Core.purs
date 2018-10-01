module Games.RandomNumber.Free.Core (Game, game) where

import Prelude
import Control.Monad.Free (Free, liftF)
import Data.Tuple (Tuple(Tuple))
import Games.RandomNumber.Core (GameInfo, GameResult, GameF(..), RemainingGuesses)

type Game = Free GameF

explainRules :: Game Unit
explainRules = liftF $ (ExplainRules unit)

setupGame :: Game GameInfo
setupGame = liftF $ (SetupGame identity)

playGame :: GameInfo -> Game GameResult
playGame info = liftF $ (PlayGame info identity)

-- endGame :: GameResult -> Game Unit
-- endGame result = liftF $ (EndGame result unit)

game :: Game GameResult
game = do
  explainRules
  info <- setupGame
  playGame info
  -- result <- playGame info
  -- endGame result
