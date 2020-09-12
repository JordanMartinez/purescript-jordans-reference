module Test.ToC.ParserLogic.QuickCheckTest where

import Prelude

import Data.Foldable (intercalate)
import Data.FoldableWithIndex (forWithIndex_)
import Data.Traversable (for_)
import Data.Tree (showForest)
import Effect (Effect)
import Effect.Console (log)
import Test.QuickCheck (quickCheck, (<?>))
import Test.QuickCheck.Gen (randomSample')
import Test.ToC.ParserLogic.Generators (MarkdownParserResult(..), PureScriptParserResult(..), genMarkdownParserResult)
import ToC.Domain.Parser (extractMarkdownHeaders, extractPurescriptHeaders)

main :: Effect Unit
main = do
  -- uncomment this line to see examples of the randomly-generated data
  -- showSample 1

  runMarkdownTest

showSample :: Int -> Effect Unit
showSample numberOfSamples = do
  array <- randomSample' numberOfSamples genMarkdownParserResult
  forWithIndex_ array (\i (MarkdownParserResult rec) -> do
    log "=============================================="
    log $ "Sample #" <> show i
    log "Lines:"
    for_ rec.lines log
    log "----------------------------------------------"
    log "Headers:"
    log $ showForest rec.expectedHeaders
  )

runMarkdownTest :: Effect Unit
runMarkdownTest = do
  -- Swap out these lines to change how many tests are run
  -- quickCheck' 500 (\(MarkdownParserResult rec) ->
  quickCheck (\(MarkdownParserResult rec) ->
    let
      actual = extractMarkdownHeaders rec.lines
    in
      rec.expectedHeaders == actual <?>
        "Expected:\n" <>
        showForest rec.expectedHeaders <>
        "\n\
        \Actual  :\n" <>
        showForest actual <>
        "\n\
        \Text:\n" <>
        (intercalate "\n" rec.lines)
  )

-- TODO: This test does not yet work!
-- The data generators just generate empty values for each label in the record
runPureScriptTest :: Effect Unit
runPureScriptTest = do
  -- quickCheck (\(PureScriptParserResult rec) ->
  quickCheck (\(PureScriptParserResult rec) ->
    let
      actual = extractPurescriptHeaders rec.lines
    in
      rec.expectedHeaders == actual <?>
        "Expected:\n" <>
        showForest rec.expectedHeaders <>
        "\n\
        \Actual  :\n" <>
        showForest actual <>
        "\n\
        \Text:\n" <>
        (intercalate "\n" rec.lines)
  )
