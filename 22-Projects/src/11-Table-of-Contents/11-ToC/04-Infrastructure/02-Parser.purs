module Projects.ToC.Parser (extractAllCodeHeaders, extractAllMarkdownHeaders) where

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
import Projects.ToC.Core.Paths (WebUrl)
import Projects.ToC.Domain.Markdown (indentedBulletList, hyperLink)
import Text.Parsing.StringParser (Parser, runParser)
import Text.Parsing.StringParser.CodePoints (regex, string, eof)
import Text.Parsing.StringParser.Combinators (choice, many, many1, sepBy1)

type MarkdownHeaderInfo = { level :: Int
                          , text :: String
                          , anchor :: String
                          }
type CodeHeaderInfo = { level :: Int
                      , lineNumber :: Int
                      , text :: String
                      }

extractAllCodeHeaders :: WebUrl -> Array String -> List (Tree HeaderInfo)
extractAllCodeHeaders absoluteFileUrl lines =
  let
    result = foldlWithIndex (\index acc nextLine ->
        case runParser codeLineWithMarkdownHeaders nextLine of
          Left _ -> acc
          Right createCodeHeader ->
            let codeHeader = createCodeHeader (index + 1)
            in maybe
                (acc { loc = Just $ fromTree (codeHeader :< Nil) })
                (\loc' -> recursiveCheck acc.list loc' codeHeader _.level)
                acc.loc
        ) { list: Nil, loc: Nothing } lines
    listOfLocs = maybe result.list (\loc -> loc : result.list) result.loc
  in (reverse listOfLocs) <#> (\loc ->
        (toTree loc) <#> (\rec ->
          { level: rec.level
          , text: rec.text
          , url: absoluteFileUrl <> "#L" <> show rec.lineNumber
          }
        )
      )

extractAllMarkdownHeaders :: WebUrl -> Array String -> List (Tree HeaderInfo)
extractAllMarkdownHeaders absoluteFileUrl lines =
  let
    result = foldlWithIndex (\index acc nextLine ->
        case runParser plainTextLinewithMarkdownHeaders nextLine of
          Left _ -> acc
          Right header ->
            maybe
              (acc { loc = Just $ fromTree (header :< Nil) })
              (\loc' -> recursiveCheck acc.list loc' header _.level)
              acc.loc
        ) { list: Nil, loc: Nothing } lines
    listOfLocs = maybe result.list (\loc -> loc : result.list) result.loc

  in (reverse listOfLocs) <#> (\loc ->
        (toTree loc) <#> (\rec ->
          { level: rec.level
          , text: rec.text
          , url: absoluteFileUrl <> "#" <> rec.anchor
          }
        )
      )

recursiveCheck :: forall a. List (Loc a) -> Loc a -> a -> (a -> Int) -> { list :: List (Loc a), loc :: Maybe (Loc a) }
recursiveCheck list stored next getHeaderLevel =
  if (getHeaderLevel next) <= (getHeaderLevel $ value stored)
    then { list: stored : list
         , loc: Just $ fromTree (next :< Nil)
         }
    else
         { list: list
         , loc: Just $
            case lastChild stored of
              Nothing -> insertChild (next :< Nil) stored
              Just child -> root $ recursiveCheck' child next getHeaderLevel
         }

recursiveCheck' :: forall a. Loc a -> a -> (a -> Int) -> Loc a
recursiveCheck' stored next getHeaderLevel =
  if (getHeaderLevel next) <= (getHeaderLevel $ value stored)
    then insertAfter (next :< Nil) stored
    else
      case lastChild stored of
        Nothing -> insertChild (next :< Nil) stored
        Just child -> recursiveCheck' child next getHeaderLevel

codeLineWithMarkdownHeaders :: Parser (Int -> CodeHeaderInfo)
codeLineWithMarkdownHeaders = ado
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
  in (\ln -> { level: headerLevel, lineNumber: ln, text: headerText })

plainTextLinewithMarkdownHeaders :: Parser MarkdownHeaderInfo
plainTextLinewithMarkdownHeaders = ado
  -- account for possibility of whitespace preceding any text
  ignorePossibleTabsAndSpaces
  -- only include headers with level 2 or more
  headerLevel <- String.length <$> regex "#{2,}"
  ignorePossibleTabsAndSpaces
  headerText <- regex ".*"
  eof
  in { level: headerLevel
     , text: headerText
     , anchor: produceLink headerText
     }

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
