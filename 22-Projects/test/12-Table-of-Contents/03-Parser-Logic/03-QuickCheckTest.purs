module Test.ToC.ParserLogic.QuickCheckTest where

import Prelude

import Control.Comonad.Cofree ((:<))
import Data.Tree (showForest)
import Effect (Effect)
import Test.QuickCheck (quickCheck, (<?>))
import Test.ToC.ParserLogic.Generators (MarkdownParserResult(..), PureScriptParserResult(..))
import ToC.Domain.Parser (extractMarkdownHeaders, extractPurescriptHeaders)

main :: Effect Unit
main = do

  quickCheck (\(MarkdownParserResult rec) ->
    let
      actual = extractMarkdownHeaders rec.lines
    in
      rec.expectedHeaders == extractMarkdownHeaders rec.lines <?>
      "Expected:\n" <> showForest rec.expectedHeaders <> "\n\
      \Actual  :\n" <> showForest actual
  )

  -- quickCheck (\(PureScriptParserResult rec) ->
  --   rec.expectedHeaders == extractPurescriptHeaders rec.lines
  -- )
