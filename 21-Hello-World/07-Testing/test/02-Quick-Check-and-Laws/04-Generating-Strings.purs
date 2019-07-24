-- | The focus of this file is on using String/Char's
-- | generators to produce random String values.
module Test.RandomDataGeneration.Strings where

import Prelude

import Data.Char.Gen (genAlpha, genAlphaLowercase, genAlphaUppercase, genAsciiChar, genAsciiChar', genDigitChar, genUnicodeChar)
import Data.Enum (toEnumWithDefaults)
import Data.FoldableWithIndex (forWithIndex_)
import Data.String.Gen (genAlphaLowercaseString, genAlphaString, genAlphaUppercaseString, genAsciiString, genAsciiString', genDigitString, genString, genUnicodeString)
import Data.Traversable (fold)
import Effect (Effect)
import Effect.Console (log)
import Test.QuickCheck.Gen (Gen, chooseInt, listOf, randomSample)

-- Prints the results of the combinators in Data.Char.Gen
-- and Data.String.Gen
main :: Effect Unit
main = do                                                                 {-
  printData "explanation" $
    combinator arg1 arg2 -- if args are required                          -}

  log "*** Basic Char combinators ***"

  printData "genUnicodeChar - generates a character of the Unicode basic \
            \multilingual plane. Since Asian languages take up a big chunk \
            \of the plane, most of the characters will be an Asian character" $
    genUnicodeChar

  printData "genAsciiChar - generates a character in the ASCII character set, \
            \excluding control codes" $
    genAsciiChar

  printData "genAsciiChar' - generates a character in the ASCII character set" $
    genAsciiChar'

  printData "genDigitChar - generates a character that is a numeric digit" $
    genDigitChar

  printData "genAlpha - generates a character from the basic latin alphabet" $
    genAlpha

  printData "genAlphaLowercase - generates a lowercase character from the \
            \basic latin alphabet" $
    genAlphaLowercase

  printData "genAlphaUppercase - generates an uppercase character from the \
            \basic latin alphabet" $
    genAlphaUppercase


  let
    customCharGenerator :: Int -> Int -> Gen Char
    customCharGenerator lower upper =
      toEnumWithDefaults bottom top <$> chooseInt lower upper

  printData "custom Char generator - generates a character between the 65 \
            \1200 character points, inclusive" $
    customCharGenerator 65 1200

  log "*** Basic String combinators ***"

  printData "genUnicodeString - generates a 1-character String of the Unicode \
            \basic multilingual plane. Since Asian languages take up a big \
            \chunk of the plane, most of the characters will be an Asian \
            \character" $
    genUnicodeString

  printData "genAsciiString - generates a 1-character String in the ASCII \
            \character set, excluding control codes" $
    genAsciiString

  printData "genAsciiString' - generates a 1-character String in the ASCII \
            \character set" $
    genAsciiString'

  printData "genDigitString - generates a 1-character String that is a \
            \numeric digit" $
    genDigitString

  printData "genAlpha - generates a 1-character String from the basic latin \
            \alphabet" $
    genAlphaString

  printData "genAlphaLowercase - generates a lowercase 1-character String from \
            \the basic latin alphabet" $
    genAlphaLowercaseString

  printData "genAlphaUppercase - generates an uppercase 1-character String \
            \from the basic latin alphabet" $
    genAlphaUppercaseString

  printData "custom String generator - generates a 1-character String using \
            \the character generator you provide. (In this case, the character \
            \will be between the 65 and 1200 character points, inclusive" $
    genString $ customCharGenerator 65 1200

  log "*** Actual String combinators ***"

  let
    produceStringWith20Chars :: String -> Gen String -> Effect Unit
    produceStringWith20Chars msg stringGenerator = do
      printData msg $ fold <$> listOf 20 stringGenerator

  produceStringWith20Chars "genUnicodeString" genUnicodeString
  produceStringWith20Chars "genAsciiString" genAsciiString
  produceStringWith20Chars "genAsciiString'" genAsciiString'
  produceStringWith20Chars "genDigitString" genDigitString
  produceStringWith20Chars "genAlphaString" genAlphaString
  produceStringWith20Chars "genAlphaLowercaseString" genAlphaLowercaseString
  produceStringWith20Chars "genAlphaUppercaseString" genAlphaUppercaseString
  produceStringWith20Chars "genString with custom Char generator" $
    genString $ customCharGenerator 65 1200

-- Helper functions

printData :: forall a. Show a => String -> Gen a -> Effect Unit
printData explanation generator = do
  log $ "=== " <> explanation
  result <- randomSample generator
  forWithIndex_ result (\index item ->
    log $ "Item: " <> show index <> ": " <> show item)
  log "=== Finished\n"
