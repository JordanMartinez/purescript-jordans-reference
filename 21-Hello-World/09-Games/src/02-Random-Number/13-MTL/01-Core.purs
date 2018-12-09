module Games.RandomNumber.MTL.Core
  ( class ExplainRules, explainRules
  , class SetupGame, setupGame
  , class PlayGame, playGame

  , game
  ) where

import Prelude
import Games.RandomNumber.Core (GameInfo, GameResult)

game :: forall m.
        ExplainRules m =>
        SetupGame m =>
        PlayGame m =>
        m GameResult
game = do
  explainRules
  info <- setupGame
  playGame info

class (Monad m) <= ExplainRules m where
  explainRules :: m Unit

class (Monad m) <= SetupGame m where
  setupGame :: m GameInfo

class (Monad m) <= PlayGame m where
  playGame :: GameInfo -> m GameResult
