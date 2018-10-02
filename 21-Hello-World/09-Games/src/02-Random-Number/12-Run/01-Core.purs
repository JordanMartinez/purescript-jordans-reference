module Games.RandomNumber.Run.VOne.Core
  ( ExplainRulesF(..), EXPLAIN_RULES, _explainRules, explainRules
  , SetupGameF(..), SETUP_GAME, _setupGame, setupGame
  , PlayGameF(..), PLAY_GAME, _playGame, playGame

  , game
  ) where

import Prelude
import Data.Symbol (SProxy(..))
import Type.Row (type (+))
import Run (Run, lift, FProxy)
import Games.RandomNumber.Core (GameInfo, GameResult)

{-
data CoreLanguage a
  = ExplainRules a
  | SetupGame (GameInfo -> a)
  | PlayGame GameInfo (GameResult -> a)
-}

data ExplainRulesF a = ExplainRulesF a
derive instance erf :: Functor ExplainRulesF

_explainRules :: SProxy "explainRules"
_explainRules = SProxy

type EXPLAIN_RULES r = (explainRules :: FProxy ExplainRulesF | r)

explainRules :: forall r. Run (EXPLAIN_RULES + r) Unit
explainRules = lift _explainRules (ExplainRulesF unit)

data SetupGameF a = SetupGameF (GameInfo -> a)
derive instance sgf :: Functor SetupGameF

_setupGame :: SProxy "setupGame"
_setupGame = SProxy

type SETUP_GAME r = (setupGame :: FProxy SetupGameF | r)

setupGame :: forall r. Run (SETUP_GAME + r) GameInfo
setupGame = lift _setupGame (SetupGameF identity)

data PlayGameF a = PlayGameF GameInfo (GameResult -> a)
derive instance pgf :: Functor PlayGameF

_playGame :: SProxy "playGame"
_playGame = SProxy

type PLAY_GAME r = (playGame :: FProxy PlayGameF | r)

playGame :: forall r. GameInfo -> Run (PLAY_GAME + r) GameResult
playGame info = lift _playGame (PlayGameF info identity)
--
-- -- endGame :: forall r. GameResult -> Game r Unit
-- -- endGame result = lift _endGame (EndGame result unit)
--
game :: forall r. Run (EXPLAIN_RULES + SETUP_GAME + PLAY_GAME + r) GameResult
game = do
  explainRules
  info <- setupGame
  playGame info
  -- result <- playGame info
  -- endGame result
