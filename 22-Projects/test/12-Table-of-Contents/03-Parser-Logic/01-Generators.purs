module Test.ToC.ParserLogic.Generators
  ( MarkdownParserResult(..)
  , PureScriptParserResult(..)

  ) where

import Prelude

import Control.Alt ((<|>))
import Control.Comonad.Cofree (head, tail, (:<))
import Control.Monad.Gen (chooseBool, oneOf)
import Control.Monad.Rec.Class (Step(..), tailRecM)
import Data.Array (cons, foldl)
import Data.Array.ST.Iterator (next)
import Data.Char.Gen (genAlpha, genDigitChar, genUnicodeChar)
import Data.Char.Unicode (isAlphaNum, isControl)
import Data.Foldable (fold)
import Data.List (List(..), filter, intercalate, (:))
import Data.Monoid (power)
import Data.NonEmpty ((:|))
import Data.String.Gen (genString)
import Data.Tree (Forest, Tree)
import Data.Tuple (Tuple(..))
import Test.QuickCheck (class Arbitrary)
import Test.QuickCheck.Gen (Gen, chooseInt, frequency, listOf, suchThat, vectorOf, shuffle)
import ToC.Core.FileTypes (HeaderInfo)

newtype MarkdownParserResult =
  MarkdownParserResult { expectedHeaders :: Forest HeaderInfo
                       , lines :: Array String
                       }

instance arbitraryMarkdownParserResult :: Arbitrary MarkdownParserResult where
  arbitrary = do
    headerList <- genHeaderForest
    lines <- genRenderedMarkdownLines headerList
    pure $ MarkdownParserResult { expectedHeaders: headerList
                                , lines: lines
                                }

newtype PureScriptParserResult =
  PureScriptParserResult { expectedHeaders :: Forest HeaderInfo
                         , lines :: Array String
                         }

instance arbitraryPureScriptParserResult :: Arbitrary PureScriptParserResult where
  arbitrary = do
    headerList <- genHeaderForest
    lines <- genPureScriptLines headerList
    pure $ PureScriptParserResult { expectedHeaders: headerList
                                  , lines: lines
                                  }

data AnchorFragment
  = Word String
  | Hyphen
  | WhiteSpace String
  | NonAnchorContent String

renderHeaderText :: AnchorFragment -> String
renderHeaderText = case _ of
  Word x -> x
  Hyphen -> "-"
  WhiteSpace x -> x
  NonAnchorContent x -> x

renderAnchorText :: AnchorFragment -> String
renderAnchorText = case _ of
  Word x -> x
  Hyphen -> "-"
  WhiteSpace _ -> "-"
  NonAnchorContent _ -> ""

genWordFragment :: Gen AnchorFragment
genWordFragment = do
    totalChars <- chooseInt 1 5
    wordList <- listOf totalChars $
      genString $
        oneOf $ genAlpha :| [genDigitChar]
    pure $ Word $ fold wordList

genHyphen :: Gen AnchorFragment
genHyphen = pure Hyphen

genWhiteSpaceAnchorSeparator :: Gen AnchorFragment
genWhiteSpaceAnchorSeparator = do
  WhiteSpace <$> genWhitespace

genNonAnchorContent :: Gen AnchorFragment
genNonAnchorContent = do
    totalChars <- chooseInt 1 4
    somethingElseList <- listOf totalChars $ genString genNonAnchorChar
    pure $ NonAnchorContent $ fold somethingElseList
  where
    genNonAnchorChar :: Gen Char
    genNonAnchorChar =
      genUnicodeChar `suchThat` (\c ->
        not ( isControl c
           || isAlphaNum c
           || c == ' '
           || c == '-'
            )
      )

genAnchorFragment :: Gen AnchorFragment
genAnchorFragment =
  frequency $   Tuple 4.0 genWordFragment
           :| ( Tuple 3.0 genNonAnchorContent
              : Tuple 2.0 genWhiteSpaceAnchorSeparator
              : Tuple 1.0 genHyphen
              : Nil
              )

genWhitespace :: Gen String
genWhitespace = do
  totalChars <- chooseInt 1 4
  fold <$> (listOf totalChars $ oneOf $ pure " " :| [pure "\t"])

genHeaderInfo :: Int -> Gen HeaderInfo
genHeaderInfo level = do
    totalFragments <- chooseInt 1 6
    startingFragment <- genWordFragment
    remainingFragments <- vectorOf totalFragments genAnchorFragment
    let fragments = startingFragment `cons` remainingFragments
    let anchor = fold $ renderAnchorText <$> fragments
    let headerText = fold $ renderHeaderText <$> fragments

    pure $ { anchor: "#" <> anchor, text: headerText, level: level }

genHeaderInfoTree :: Int -> Int -> Gen (Tree HeaderInfo)
genHeaderInfoTree maxPossibleDepth headerLevel
  | maxPossibleDepth == headerLevel =
      (\header -> header :< Nil) <$> (genHeaderInfo headerLevel)
  | otherwise = do
      header <- genHeaderInfo headerLevel
      children <- ifM chooseBool
        (do
          amount <- chooseInt 1 4
          listOf amount $ genHeaderInfoTree maxPossibleDepth (headerLevel + 1)
          )
        (pure Nil)
      pure $ header :< children

genHeaderForest :: Gen (Forest HeaderInfo)
genHeaderForest = do
  amount <- chooseInt 1 2
  maxPossibleDepth <- chooseInt 1 2
  listOf amount $ genHeaderInfoTree (maxPossibleDepth + 1) 2

genRenderedMarkdownLines :: Forest HeaderInfo -> Gen (Array String)
genRenderedMarkdownLines forest =
  tailRecM renderForest { forest: forest, array: [] }
  where
    renderForest :: { forest :: Forest HeaderInfo, array :: Array String }
                 -> Gen (Step { forest :: Forest HeaderInfo, array :: Array String } (Array String))
    renderForest { forest: Nil, array: array } = pure $ Done array
    renderForest { forest: (head:remaining), array: array } = do
      section <- renderSection head
      pure $ Loop { forest: remaining, array: array <|> section }

    renderSection :: Tree HeaderInfo -> Gen (Array String)
    renderSection headerTree = do
      randomContentBefore <- genLinesWithRandomContent

      wsSeparator <- genWhitespace
      let headerLine = renderHeader (head headerTree) wsSeparator

      randomContentAfter <- genLinesWithRandomContent

      let initialValue = { forest: tail headerTree, array: [] }
      renderedChildHeaderSections <- tailRecM renderForest initialValue

      pure $ randomContentBefore <|> (headerLine `cons` (randomContentAfter <|> renderedChildHeaderSections))

    renderHeader :: HeaderInfo -> String -> String
    renderHeader header wsSeparator =
      let
        headerPrefix = power "#" header.level
      in
        headerPrefix <> wsSeparator <> header.text


genLinesWithRandomContent :: Gen (Array String)
genLinesWithRandomContent = do
    numberOfContentBlocks <- chooseInt 0 8
    array_of_array <- vectorOf numberOfContentBlocks $ oneOf $
                 genBlankLine
            :| [ genBulletListSection
               , genCodeBlockSection
               , genLineOfGibberish
               ]
    let flattenedArray = join array_of_array
    pure $ flattenedArray
  where
    genBlankLine :: Gen (Array String)
    genBlankLine = pure [""]

    genBulletListSection :: Gen (Array String)
    genBulletListSection = do
      listSize <- chooseInt 1 4
      vectorOf listSize do
        gibberish <- genGibberishPhrase
        pure $ "- " <> gibberish

    genGibberishWord :: Gen String
    genGibberishWord = do
      numberOfChars <- chooseInt 1 15
      charList <- listOf numberOfChars $ genString
        (genUnicodeChar `suchThat` \c ->
          not ( isControl c
             || c == '#'
              )
        )
      pure $ fold charList

    genGibberishPhrase :: Gen String
    genGibberishPhrase = do
      numberOfWords <- chooseInt 1 15
      (intercalate " ") <$> listOf numberOfWords genGibberishWord

    genCodeBlockSection :: Gen (Array String)
    genCodeBlockSection = do
      numberOfLines <- chooseInt 1 8
      gibberishLines <- vectorOf numberOfLines genGibberishPhrase

      pure $ ["```"] <|> gibberishLines <|> ["```"]

    genLineOfGibberish :: Gen (Array String)
    genLineOfGibberish = vectorOf 1 genGibberishPhrase

genPureScriptLines :: Forest HeaderInfo -> Gen (Array String)
genPureScriptLines forest = pure []
