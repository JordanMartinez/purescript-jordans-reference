module Games.RandomNumber.Free.Core (Game, game) where

import Prelude
import Control.Monad.Free (Free, liftF)
import Data.Tuple (Tuple(Tuple))
import Games.RandomNumber.Core (GameInfo, GameResult, GameF(..), RemainingGuesses)

type Game = Free GameF

explainRules :: Game Unit
explainRules = liftF $ (ExplainRules unit)

setupGame :: Game (Tuple GameInfo RemainingGuesses)
setupGame = liftF $ (SetupGame identity)

playGame :: GameInfo -> RemainingGuesses -> Game GameResult
playGame info remaining = liftF $ (PlayGame info remaining identity)

endGame :: GameResult -> Game Unit
endGame result = liftF $ (EndGame result unit)

game :: Game Unit
game = do
  explainRules
  Tuple info total <- setupGame
  result <- playGame info total
  endGame result
