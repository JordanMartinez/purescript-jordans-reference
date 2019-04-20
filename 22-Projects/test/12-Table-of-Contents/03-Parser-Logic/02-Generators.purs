module Test.ToC.ParserLogic.Generators
  ( MarkdownParserResult(..)
  , genMarkdownParserResult
  , PureScriptParserResult(..)

  ) where

import Prelude

import Control.Alt ((<|>))
import Control.Comonad.Cofree (head, tail, (:<))
import Control.Monad.Gen (chooseBool, oneOf)
import Control.Monad.Rec.Class (Step(..), tailRecM)
import Data.Array (cons, foldM)
import Data.Char.Gen (genAlpha, genAsciiChar, genDigitChar, genUnicodeChar)
import Data.Char.Unicode (isAlphaNum, isControl)
import Data.Foldable (fold, foldl)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.List (List(..), intercalate, reverse, (:))
import Data.Monoid (power)
import Data.NonEmpty ((:|))
import Data.String.Gen (genString)
import Data.Tree (Forest, Tree)
import Data.Tuple (Tuple(..))
import Test.QuickCheck (class Arbitrary)
import Test.QuickCheck.Gen (Gen, chooseInt, frequency, listOf, shuffle, suchThat, vectorOf)
import ToC.Core.FileTypes (HeaderInfo)

newtype MarkdownParserResult =
  MarkdownParserResult { expectedHeaders :: Forest HeaderInfo
                       , lines :: Array String
                       }

instance arbitraryMarkdownParserResult :: Arbitrary MarkdownParserResult where
  arbitrary = genMarkdownParserResult

genMarkdownParserResult :: Gen MarkdownParserResult
genMarkdownParserResult = do
  headerForest <- genMarkdownHeaderForest
  lines <- genRenderedMarkdownLines headerForest
  pure $ MarkdownParserResult { expectedHeaders: headerForest
                              , lines: lines
                              }

newtype PureScriptParserResult =
  PureScriptParserResult { expectedHeaders :: Forest HeaderInfo
                         , lines :: Array String
                         }

-- TODO: The generators for this data type require keeping track of the
-- number of lines that precede a given header
instance arbitraryPureScriptParserResult :: Arbitrary PureScriptParserResult where
  arbitrary = genPureScriptParserResult

-- TODO: The generators for this data type require keeping track of the
-- number of lines that precede a given header
genPureScriptParserResult :: Gen PureScriptParserResult
genPureScriptParserResult = do
    pure $ PureScriptParserResult { expectedHeaders: Nil
                                  , lines: []
                                  }


data AnchorFragment
  = Word String
  | Hyphen
  | UnderScore
  | WhiteSpace String
  | NonAnchorContent String

derive instance genericAnchorFragment :: Generic AnchorFragment _

instance showAnchorFragment :: Show AnchorFragment where
  show x = genericShow x

-- | Unboxes the AnchorFragment data constructor
renderHeaderText :: AnchorFragment -> String
renderHeaderText = case _ of
  Word x -> x
  Hyphen -> "-"
  UnderScore -> "_"
  WhiteSpace x -> x
  NonAnchorContent x -> x

-- | Unboxes the AnchorFragment data constructor except for NonAnchorContent,
-- | which is not rendered
renderAnchorText :: AnchorFragment -> String
renderAnchorText = case _ of
  Word x -> x
  Hyphen -> "-"
  UnderScore -> "_"
  WhiteSpace _ -> "-"
  NonAnchorContent _ -> ""

-- | Generates a alphanumerical String
genWordFragment :: Gen AnchorFragment
genWordFragment = do
    totalChars <- chooseInt 1 5
    wordList <- listOf totalChars $
      genString $
        oneOf $ genAlpha :| [genDigitChar]
    pure $ Word $ fold wordList

-- | Generates symbolic characters and non-alphanum non-whitespace characters
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
           || c == '\t'
           || c == '-'
           || c == '_'
            )
      )

-- | Generates the non-whitespace characters
genAnchorFragmentContent :: Gen AnchorFragment
genAnchorFragmentContent =
  frequency $   Tuple 4.0 genWordFragment
           :| ( Tuple 2.0 genNonAnchorContent
              : Tuple 2.0 (pure Hyphen)
              : Tuple 1.0 (pure UnderScore)
              : Nil
              )

-- | Generates a sequence of 1 or more spaces and/or tabs
genWhitespace :: Gen String
genWhitespace = do
  totalChars <- chooseInt 1 4
  fold <$> (listOf totalChars $ oneOf $ pure " " :| [pure "\t"])

-- | Generates 1 header for a Markdown file
genMarkdownHeaderInfo :: Int -> Gen HeaderInfo
genMarkdownHeaderInfo level = do
    -- generate all anchor fragments
    guaranteeAtLeastOneWord <- genWordFragment
    totalFragments <- chooseInt 0 6
    allOtherFragments <- vectorOf totalFragments genAnchorFragmentContent
    fragmentContents <- shuffle (guaranteeAtLeastOneWord `cons` allOtherFragments)

    -- add some whitespace between them
    fragments <- intercalateGen (WhiteSpace <$> genWhitespace) fragmentContents

    -- create the corresponding anchor and text info
    let rec = foldl (\acc next ->
          { anchor: acc.anchor <> renderAnchorText next
          , text: acc.text <> renderHeaderText next
          }) { anchor: "", text: "" } fragments

    pure { anchor: "#" <> rec.anchor, text: rec.text, level: level }
  where
    -- | Simulates 'intercalate whiteSpaceSeparation arrayOfGeneratedContent'
    -- | by building up the list backwards (for speed)
    -- | and then reversing the final output (for correct order)
    intercalateGen :: Gen AnchorFragment -> Array AnchorFragment -> Gen (List AnchorFragment)
    intercalateGen genSeparator foldable = do
      result <- foldM (\acc next ->
          if acc.init
            then
              pure { init: false, entity: next : acc.entity }
            else do
              separation <- genSeparator
              pure $ acc { entity = next : separation : acc.entity }

        ) { init: true, entity: Nil } foldable
      pure $ reverse result.entity

-- | Recursively generates a tree of markdown headers that may
-- | or may not have children. However, the tree's depth is guaranteed
-- | to be at least less than the max depth.
genMarkdownHeaderInfoTree :: Int -> Int -> Gen (Tree HeaderInfo)
genMarkdownHeaderInfoTree maxPossibleDepth headerLevel
  | maxPossibleDepth == headerLevel =
      (genMarkdownHeaderInfo headerLevel) <#> (\headerInfo -> headerInfo :< Nil)
  | otherwise = do
      header <- genMarkdownHeaderInfo headerLevel
      children <- ifM chooseBool
        (do
          amount <- chooseInt 1 4
          listOf amount $ genMarkdownHeaderInfoTree maxPossibleDepth (headerLevel + 1)
        )
        (pure Nil)
      pure $ header :< children

genMarkdownHeaderForest :: Gen (Forest HeaderInfo)
genMarkdownHeaderForest = do
  amount <- chooseInt 1 6
  maxPossibleDepth <- chooseInt 1 4
  -- since we only parse headers that are level 2 or higher
  -- we increase `maxPossibleDepth` by one
  listOf amount $ genMarkdownHeaderInfoTree (maxPossibleDepth + 1) 2

genRenderedMarkdownLines :: Forest HeaderInfo -> Gen (Array String)
genRenderedMarkdownLines forest =
  tailRecM renderForest { forest: forest, array: [] }
  where
    renderForest ::           { forest :: Forest HeaderInfo, array :: Array String }
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
    pure flattenedArray
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
        (genAsciiChar `suchThat` \c ->
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
