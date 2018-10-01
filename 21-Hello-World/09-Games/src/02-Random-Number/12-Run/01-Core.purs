module Games.RandomNumber.Run.Core (Game, GAME, game, _game) where

import Prelude
import Data.Symbol (SProxy(..))
import Type.Row (type (+))
import Run (Run, lift, FProxy(..))
import Games.RandomNumber.Core (GameInfo, GameResult, GameF(..), RemainingGuesses)

type GAME r = (game :: FProxy GameF | r)

type Game r = Run (GAME + r)

_game :: SProxy "game"
_game = SProxy

explainRules :: forall r. Game r Unit
explainRules = lift _game (ExplainRules unit)

setupGame :: forall r. Game r GameInfo
setupGame = lift _game (SetupGame identity)

playGame :: forall r. GameInfo -> Game r GameResult
playGame info = lift _game (PlayGame info identity)

-- endGame :: forall r. GameResult -> Game r Unit
-- endGame result = lift _game (EndGame result unit)

game :: forall r. Game r GameResult
game = do
  explainRules
  info <- setupGame
  playGame info
  -- result <- playGame info
  -- endGame result
