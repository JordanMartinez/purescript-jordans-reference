module Projects.ToC.Domain.BetterParser where

import Prelude

import Control.Alt ((<|>))
import Control.Comonad.Cofree ((:<))
import Data.Either (Either(..))
import Data.Foldable (foldl, intercalate)
import Data.FoldableWithIndex (foldlWithIndex)
import Data.List (catMaybes, reverse)
import Data.List.Types (List(..), (:), NonEmptyList)
import Data.Maybe (Maybe(..), maybe)
import Data.String as String
import Data.Tree (Tree)
import Data.Tree.Zipper (Loc, fromTree, insertAfter, insertChild, lastChild, root, toTree, value)
import Projects.ToC.Core.FileTypes (HeaderInfo)
import Text.Parsing.StringParser (Parser, fail, runParser)
import Text.Parsing.StringParser.CodePoints (regex, string, eof)
import Text.Parsing.StringParser.Combinators (choice, many, many1, sepBy1)

psFileWithMarkdownHeaders :: Parser (List (Tree HeaderInfo))
psFileWithMarkdownHeaders =
  catMaybes $ many $ psParser

psParser :: Parser (Maybe (Tree HeaderInfo))
psParser = do
  -- Need to repeat this multiple times
  -- until eof
  (Just <$> psHeaderTree 1) <|> (Nothing <$ nonHeaderLine)

nonHeaderLine :: Parser Unit
nonHeaderLine = regex "[^\n]+\n"

psHeaderTree :: Int -> Parser (Tree HeaderInfo)
psHeaderTree lineNumber = ado
  root <- psMarkdownHeader lineNumber
  children <- psHeaderChildren (lineNumber + 1)
  in root :< children

psHeaderChildren :: Int -> Parser (List HeaderInfo)
psHeaderChildren lineNumber = do
  many psHeaderTree

psMarkdownHeader :: Maybe Int -> Int -> Parser HeaderInfo
psMarkdownHeader requiredLength ln = ado
  ignorePossibleTabsAndSpaces
  void $ string "--"
  ignorePossibleTabsAndSpaces
  headerLevel <- String.length <$> regex "#{2,}"
  case requiredLength of
    Just depth | headerLevel /= depth ->
      fail $ "Required depth: " <> show depth <> "\n\
             \Actual depth:   " <> show headerLevel
    _ -> pure unit
  ignorePossibleTabsAndSpaces
  headerText <- regex "[^\n]+"
  void $ char '\n'
  in { level: headerLevel, text: headerText, anchor: "#L" <> show ln }

  where
    isR

psLineWithMarkdownHeaders :: Int -> Parser HeaderInfo
psLineWithMarkdownHeaders ln = ado
  -- account for possibility of spaces preceding any text
  ignorePossibleTabsAndSpaces
  -- it is a single-line comment...
  void $ string "--"
  ignorePossibleTabsAndSpaces
  -- that includes a header
  headerLevel <- String.length <$> regex "#{2,}"
  ignorePossibleTabsAndSpaces
  headerText <- regex ".*"
  eof
  in { level: headerLevel, text: headerText, anchor: "#L" <> show ln }

plainTextLinewithMarkdownHeaders :: Parser HeaderInfo
plainTextLinewithMarkdownHeaders = ado
  -- account for possibility of whitespace preceding any text
  ignorePossibleTabsAndSpaces
  -- only include headers with level 2 or more
  headerLevel <- String.length <$> regex "#{2,}"
  ignorePossibleTabsAndSpaces
  headerText <- regex ".*"
  eof
  in { level: headerLevel, text: headerText, anchor: "#" <> produceLink headerText }

produceLink :: String -> String
produceLink headerText =
  case runParser wordParser headerText of
    Left error -> show error
    Right wordList -> intercalate "-" wordList

  where
    -- | Removes all non-whitespace characters that are not
    -- | a letter or number or hyphen and combines the result together
    -- | into a word.
    singleWord :: Parser String
    singleWord = ado
      wordParts <- many1 $ choice
        -- keep alphabetical (case-insensitive) characters or numbers
        [ regex "[a-zA-Z0-9]+"
        -- keep any hyphens and include them in a word
        , string "-"
        -- parse all other non-whitespace characters and return an empty string
        , "" <$ (regex "[^a-zA-Z0-9 \t-]+")
        ]

      -- combine all the characters and hyphens together into a 'word'
      in foldl (\acc next -> acc <> next) "" wordParts

    -- | Find all 'words' that are separated by one or more
    -- | whitespace characters
    wordParser :: Parser (NonEmptyList String)
    wordParser = sepBy1 singleWord (many1 tabOrSpace)

ignorePossibleTabsAndSpaces :: Parser Unit
ignorePossibleTabsAndSpaces = void $ many tabOrSpace

tabOrSpace :: Parser String
tabOrSpace = (string "\t") <|> (string " ")
