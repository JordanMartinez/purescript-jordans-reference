module Debugging.CustomTypeErrors.Functions where

import Prelude
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Console (log)

-- Prelude is not imported to prevent some of its functon aliases
-- from clashing with ones defined below (e.g. "<>")
import Data.Show (show)
import Data.Unit (Unit)
import Data.Function (($))
import Control.Bind (discard)

import Prim.TypeError (kind Doc, Text, Quote, Above, Beside, QuoteLabel, class Warn, class Fail)

data Doc_
  = Text_ String      -- wraps a Symbol
  | Quote_ String     -- the Type's name as a Symbol
  | QuoteLabel_ String -- Similar to Text but handles things differently
                       -- Used particularly for 'labels', the 'keys'
                       -- in rows/records (see below)
  | Beside_ Doc_ Doc_ -- same as "left <> right" ("leftright")
  | Above_ Doc_ Doc_  -- same as "top" <> "\n" <> "bottom" ("top\nbottom")

-- The following aliases are taken from purescript-typelevel-eval:
-- https://pursuit.purescript.org/packages/purescript-typelevel-eval/0.2.0/docs/Type.Eval
-- I would use it and import them here, but it's not yet in the default package set
infixr 2 type Beside as <>
infixr 1 type Above as |>

warnValue :: Warn
  (  Text "This warning appears only when you use this value or function"
  |> Text ""
  |> Text "The requested value of type, " <> Quote Int <> Text ","
  |> Text "is no longer something you should use!"
  |> Text ""
  |> Text "Use betterValue instead since it is of type " <> Quote Number
  ) => Int
warnValue = 5

betterValue :: Number
betterValue = 5.0

failValue :: Fail
  (  Text "This error only appears when you use this value"
  |> Text ""
  |> Text "Error: Value is no longer valid"
  ) => Int
failValue = 20

regularValue :: Int
regularValue = 4

-- QuoteLabel vs Text
labelAsText :: forall l. Warn
  ( Text "Text Label " <> Text l
  ) => SProxy l -> String
labelAsText _ = ""

labelAsQuote :: forall l. Warn
  ( Text "Quote Label " <> QuoteLabel l
  ) => SProxy l -> String
labelAsQuote _ = ""

main :: Effect Unit
main = do
  log $ show regularValue
  log $ show warnValue

  -- Demonstrates the difference between Text and QuoteLabel
  log $ show (labelAsText (SProxy :: SProxy "boo"))
  log $ show (labelAsQuote (SProxy :: SProxy "boo"))

  log $ show (labelAsText (SProxy :: SProxy "b\"oo"))
  log $ show (labelAsQuote (SProxy :: SProxy "b\"oo"))

  log $ show (labelAsText (SProxy :: SProxy "b o o"))
  log $ show (labelAsQuote (SProxy :: SProxy "b o o"))

  -- Uncomment the next line, save the file, run it, and see what happens
  -- log $ show failValue
