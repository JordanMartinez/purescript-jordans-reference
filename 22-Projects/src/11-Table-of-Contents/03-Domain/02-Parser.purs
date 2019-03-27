module Projects.ToC.Domain.Parser (extractPurescriptHeaders, extractMarkdownHeaders) where

import Prelude

import Control.Alt ((<|>))
import Control.Comonad.Cofree ((:<))
import Data.Either (Either(..))
import Data.Foldable (foldl, intercalate)
import Data.FoldableWithIndex (foldlWithIndex)
import Data.List (reverse)
import Data.List.Types (List(..), (:), NonEmptyList)
import Data.Maybe (Maybe(..), maybe)
import Data.String as String
import Data.Tree (Tree)
import Data.Tree.Zipper (Loc, fromTree, insertAfter, insertChild, lastChild, root, toTree, value)
import Projects.ToC.Core.FileTypes (HeaderInfo)
import Text.Parsing.StringParser (Parser, runParser)
import Text.Parsing.StringParser.CodePoints (regex, string, eof)
import Text.Parsing.StringParser.Combinators (choice, lookAhead, many, many1, sepBy1)

extractPurescriptHeaders :: Array String -> List (Tree HeaderInfo)
extractPurescriptHeaders = extractHeaders (\lineNumber -> psLineWithMarkdownHeaders lineNumber)

extractMarkdownHeaders :: Array String -> List (Tree HeaderInfo)
extractMarkdownHeaders = extractHeaders (\_ -> plainTextLinewithMarkdownHeaders)

extractHeaders :: (Int -> Parser HeaderInfo) -> Array String -> List (Tree HeaderInfo)
extractHeaders parser lines =
  let
    result = foldlWithIndex (\index acc nextLine ->
        case runParser (parser index) nextLine of
          Left _ -> acc
          Right header ->
            -- If the accumulator does not yet have a 'current header',
            -- Then store the just-parsed header as the 'current header'.
            -- Otherwise, attempt to nest the just-parsed header with
            -- the current header.
            maybe
              (acc { loc = Just $ fromTree (header :< Nil) })
              (\loc' -> attemptHeaderNesting acc.list loc' header _.level)
              acc.loc
        ) { list: Nil, loc: Nothing } lines
    listOfLocs = maybe result.list (\loc -> loc : result.list) result.loc

  in toTree <$> (reverse listOfLocs)

attemptHeaderNesting :: forall a. List (Loc a) -> Loc a -> a -> (a -> Int) -> { list :: List (Loc a), loc :: Maybe (Loc a) }
attemptHeaderNesting list stored next getHeaderLevel =
  -- If the next header's level is less than or equal to the current one,
  -- then it can't be nested, so add the current header to the real
  -- accumulator (list) and set the next header to the current header value.
  -- Otherwise, check whether the current header has a child.
  -- If it does not, then the next header is the only child of the current one.
  -- Otherwise, continue to the next level of the current header and try
  -- to further nest the header.
  if (getHeaderLevel next) <= (getHeaderLevel $ value stored)
    then { list: stored : list
         , loc: Just $ fromTree (next :< Nil)
         }
    else
         { list: list
         , loc: Just $ root $
            case lastChild stored of
              Nothing -> insertChild (next :< Nil) stored
              Just child -> recursivelyNestHeader child next getHeaderLevel
         }

recursivelyNestHeader :: forall a. Loc a -> a -> (a -> Int) -> Loc a
recursivelyNestHeader stored next getHeaderLevel =
  -- Same as above, except that in the first case (header cannot be nested),
  -- we add it as another child to the current header's list of children.
  if (getHeaderLevel next) <= (getHeaderLevel $ value stored)
    then insertAfter (next :< Nil) stored
    else
      case lastChild stored of
        Nothing -> insertChild (next :< Nil) stored
        Just child -> recursivelyNestHeader child next getHeaderLevel

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
  -- capture header text without changing the position of where we are
  -- in the string
  headerText <- lookAhead $ regex ".*"
  -- extract all the 'words' from the header text and change the position
  headerAnchor <- wordParser
  -- ensure this is the end of the line
  eof
  in { level: headerLevel, text: headerText, anchor: "#" <> (intercalate "-" headerAnchor) }

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
