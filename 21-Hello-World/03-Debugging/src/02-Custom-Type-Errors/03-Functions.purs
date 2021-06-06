module Debugging.CustomTypeErrors.Functions where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Type.Proxy (Proxy(..))

import Prim.TypeError (Text, Quote, Above, Beside, QuoteLabel, class Warn, class Fail)

data Doc_
  = Text_ String      -- wraps a Symbol
  | Quote_ String     -- the Type's name as a Symbol
  | QuoteLabel_ String -- Similar to Text but handles things differently
                       -- Used particularly for 'labels', the 'keys'
                       -- in rows/records (see below)
  | Beside_ Doc_ Doc_ -- Similar to "left <> right" ("leftright") in that
                      -- it places documents side-by-side. However, it's
                      -- different in that these documents are aligned at
                      -- the top.
  | Above_ Doc_ Doc_  -- same as "top" <> "\n" <> "bottom" ("top\nbottom")

-- The following aliases are taken from purescript-typelevel-eval:
-- https://pursuit.purescript.org/packages/purescript-typelevel-eval/0.2.0/docs/Type.Eval
-- I would use it and import them here, but it's not yet in the default package set
infixr 2 type Beside as <>
infixr 1 type Above as |>

besideExample :: Warn
  (  Text "Beside lays out documents side-by-side, aligned at the top:"
  |> Text ""
  |> ( (  Text "A"
       |> Text "B"
       ) <> Text "C"
     )
  |> Text ""
  |> ( Text "C" <> (  Text "A"
                   |> Text "B"
                   )
     )

  ) => Int
besideExample = 2

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
  ) => Proxy l -> String
labelAsText _ = ""

labelAsQuote :: forall l. Warn
  ( Text "Quote Label " <> QuoteLabel l
  ) => Proxy l -> String
labelAsQuote _ = ""

main :: Effect Unit
main = do
  log $ show regularValue
  log $ show warnValue

  log $ show besideExample

  -- Demonstrates the difference between Text and QuoteLabel
  log $ show (labelAsText (Proxy :: Proxy "boo"))
  log $ show (labelAsQuote (Proxy :: Proxy "boo"))

  log $ show (labelAsText (Proxy :: Proxy "b\"oo"))
  log $ show (labelAsQuote (Proxy :: Proxy "b\"oo"))

  log $ show (labelAsText (Proxy :: Proxy "b o o"))
  log $ show (labelAsQuote (Proxy :: Proxy "b o o"))

  -- Uncomment the next line, save the file, run it, and see what happens
  -- log $ show failValue
