module Learn.StringParsers.Syntax where

import Prelude hiding (between)

import Control.Alt ((<|>))
import Data.Either (Either(..))
import Data.Foldable (foldl, sum)
import Data.List.Types (NonEmptyList)
import Effect (Effect)
import Effect.Console (log, logShow)
import Text.Parsing.StringParser (Parser, fail, runParser, unParser)
import Text.Parsing.StringParser.CodePoints (char, eof, regex, string, anyChar)
import Text.Parsing.StringParser.Combinators (between, endBy1, many, many1, sepBy1, (<?>))

-- Serves only to make this file runnable
main :: Effect Unit
main = printResults

printResults :: Effect Unit
printResults = do
  log "" -- empty blank line to separate output from function call
  doBoth "fail" ((fail "example failure message") :: Parser Unit)
  doBoth "numberOfAs" numberOfAs
  doBoth "removePunctuation" removePunctuation
  doBoth "replaceVowelsWithUnderscore" replaceVowelsWithUnderscore
  doBoth "tokenizeContentBySpaceChars" tokenizeContentBySpaceChars
  doBoth "extractWords" extractWords
  doBoth "badExtractWords" badExtractWords
  doBoth "quotedLetterExists" quotedLetterExists

exampleContent :: String
exampleContent =
  "How many 'a's are in this sentence, you ask? Not that many."

numberOfAs :: Parser Int
numberOfAs = do
  let
    oneIfA = 1 <$ string "a" <?> "Letter was 'a'"
    zeroIfNotA = 0 <$ regex "[^a]" <?> "Letter was not 'a'"
    letterIsOneOrZero = oneIfA <|> zeroIfNotA <?>
                            "The impossible happened: \
                            \a letter was not 'a', and was not not-'a'."
    convertLettersToList = many1 letterIsOneOrZero
                                                                        {-
  list <- convertLettersToList                                          -}
  list <- many1
          (  (1 <$ string "a")
         <|> (0 <$ regex "[^a]")
          )
  -- calculate total number by adding Ints in list together
  pure $ sum list

removePunctuation :: Parser String
removePunctuation = do                                                      {-
  let
    charsAndSpaces = regex "[a-zA-Z ]+"
    everythingElse = regex "[^a-zA-Z ]+"
    ignoreEverythingElse = "" <$ everythingElse
    zeroOrMoreFragments = many1 $ charsAndSpaces <|> ignoreEverythingElse   -}
  list <- many1
              ( regex "[a-zA-Z ]+"
             <|> ("" <$ regex "[^a-zA-Z ]+" )
              )

  -- combine the list's contents together via '<>'
  pure $ foldl (<>) "" list

replaceVowelsWithUnderscore :: Parser String
replaceVowelsWithUnderscore = do
  list <- many1 $ (  ( "_" <$ regex "[aeiou]")
                 <|> regex "[^aeiou]+"
                  )

  pure $ foldl (<>) "" list

tokenizeContentBySpaceChars :: Parser (NonEmptyList String)
tokenizeContentBySpaceChars = do
  sepBy1 (regex "[^ ]+") (string " ")

extractWords :: Parser (NonEmptyList String)
extractWords = do
  endBy1 (regex "[a-zA-Z]+")
         -- try commenting out one of the "<|> string ..." lines and see what happens
         (many1 (  string " " <?> "Failed to match space as a separator"
               <|> string "'" <?> "Failed to match single-quote char as a separator"
               <|> string "," <?> "Failed to match comma as a separator"
               <|> string "?" <?> "Failed to match question mark as a separator"
               <|> string "." <?> "Failed to match period as a separator"
               <?> "Could not find a character that separated the content..."
                )
         )

badExtractWords :: Parser (NonEmptyList String)
badExtractWords = do
  list <- endBy1 (regex "[a-zA-Z]+")
                 -- try commenting out the below "<|> string ..." lines
                 (many1 (  string " " <?> "Failed to match space as a separator"
                       <|> string "'" <?> "Failed to match single-quote char as a separator"
                       <|> string "," <?> "Failed to match comma as a separator"
                       -- <|> string "?" <?> "Failed to match question mark as a separator"
                       -- <|> string "." <?> "Failed to match period as a separator"
                       <?> "Could not find a character that separated the content..."
                        )
                 )
  -- short for 'end of file' or 'end of content'
  eof <?> "Entire content should have been parsed but wasn't."
  pure list

-- there are better ways of doing this using `whileM`, but this explains
-- the basic idea:
quotedLetterExists :: Parser Boolean
quotedLetterExists = do
  list <- many (   true <$ (between (string "'") (string "'") (char 'a') <?> "No 'a' found.")
              <|> false <$ anyChar
               )
  pure $ foldl (||) false list

-- Helper functions

doBoth :: forall a. Show a => String -> Parser a -> Effect Unit
doBoth parserName parser = do
  doRunParser parserName parser
  doUnParser parserName parser

-- | Shows the results of calling `unParser`. You typically want to use
-- | this function when writing a parser because it includes other info
-- | to help you debug your code.
doUnParser :: forall a. Show a => String -> Parser a -> Effect Unit
doUnParser parserName parser = do
  log $ "(unParser) Parsing content with '" <> parserName <> "'"
  case unParser parser { str: exampleContent, pos: 0 } of
    Left rec -> log $ "Position: " <> show rec.pos <> "\n\
                      \Error: " <> show rec.error
    Right rec -> log $ "Result was: " <> show rec.result <> "\n\
                       \Suffix was: " <> show rec.suffix
  log "-----"


-- | Shows the results of calling `runParser`. You typically don't want to use
-- | this function when writing a parser because it doesn't help you debug
-- | your code when you write it incorrectly.
doRunParser :: forall a. Show a => String -> Parser a -> Effect Unit
doRunParser parserName parser = do
  log $ "(runParser) Parsing content with '" <> parserName <> "'"
  case runParser parser exampleContent of
    Left error -> logShow error
    Right result -> log $ "Result was: " <> show result
  log "-----"
