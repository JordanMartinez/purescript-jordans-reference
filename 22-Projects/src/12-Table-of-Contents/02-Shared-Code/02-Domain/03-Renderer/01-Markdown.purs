-- | Helper module for easily creating correctly-formatted Markdown text.
module ToC.Domain.Renderer.Markdown
  ( h1
  , h2
  , anchorLink
  , bulletList
  , emptyLine
  , hyperLink
  , indent
  , indentedBulletList
  ) where

import Prelude

import Data.Monoid (power)

emptyLine :: String
emptyLine = "\n"

h1 :: String -> String
h1 s = "# " <> s <> "\n"

h2 :: String -> String
h2 s = "## " <> s <> "\n"

hyperLink :: String -> String -> String
hyperLink linkText url = "[" <> linkText <> "](" <> url <> ")"

anchorLink :: String -> String -> String
anchorLink linkText anchor = hyperLink linkText ("#" <> anchor)

bulletList :: String -> String
bulletList s = "- " <> s <> "\n"

indent :: Int -> String
indent n = power "    " n

indentedBulletList :: Int -> String -> String
indentedBulletList d s = indent d <> bulletList s
