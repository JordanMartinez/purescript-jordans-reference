module ConsoleLessons.CustomTypeErrors.Functions where

import Effect (Effect)
import Effect.Console (log)

-- Prelude is not imported to prevent some of its functon aliases
-- from clashing with ones defined below (e.g. "<>")
import Data.Show (show)
import Data.Unit (Unit)
import Data.Function (($))
import Control.Bind (discard)

import Prim.TypeError (kind Doc, Text, Quote, Above, Beside, class Warn, class Fail)

data Doc_
  = Text_ String      -- wraps a Symbol
  | Quote_ String     -- the Type's name as a Symbol
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

main :: Effect Unit
main = do
  log $ show regularValue
  log $ show warnValue

  -- Uncomment the next line, save the file, run it, and see what happens
  -- log $ show failValue
