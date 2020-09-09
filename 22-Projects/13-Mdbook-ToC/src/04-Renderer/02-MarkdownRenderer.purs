module ToC.Renderer.MarkdownRenderer
  ( module ToC.Renderer.MarkdownRenderer
  ) where

import Prelude

import Control.Comonad.Cofree (head, tail)
import Control.Monad.Rec.Class (Step(..), tailRec)
import Data.Foldable (foldl)
import Data.List (List(..), (:))
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Int as Int
import Data.String (Pattern(..), Replacement(..), take, replace, replaceAll, toLower, drop, stripSuffix)
import Data.Tree (Tree)
import ToC.Core.Paths (FilePath, WebUrl, PathRec, fullPath)
import ToC.Renderer.Markdown (anchorLink, bulletList, emptyLine, h1, h2, indentedBulletList, hyperLink)

formatHyphensInName :: String -> String
formatHyphensInName =
  replace (Pattern "--") (Replacement ": ") >>>
  replaceAll (Pattern "-") (Replacement " ")

removeNumberedPrefix :: String -> String
removeNumberedPrefix s =
  let
    first = take 1 s
  in case Int.fromString first of
    Just _ -> removeNumberedPrefix $ drop 1 s
    Nothing
      | first == " " -> drop 1 s
      | otherwise -> s

removeMdFileExtension :: String -> String
removeMdFileExtension s = fromMaybe s $ stripSuffix (Pattern ".md") s

cleanString :: String -> String
cleanString =
  formatHyphensInName
    >>> removeNumberedPrefix
    >>> removeMdFileExtension

renderDir :: Int -> FilePath -> Array String -> String
renderDir depth pathSeg renderedPaths = do
  let urlNoLink = hyperLink (cleanString pathSeg) ""
  indentedBulletList depth urlNoLink <> (foldl (<>) "" renderedPaths)

-- | Renders a file and its headers. When passed a `Just webUrl` argument,
-- | the file's entry and its headers will be rendered as hyperlinks to
-- | the corresponding website. When passed as 'Nothing' argument for the
-- | `Maybe WebUrl` argument, it will simply render the file's name and
-- | its headers as plain text.
renderFile :: Int -> FilePath -> PathRec -> String
renderFile depth linkText urlPathRec = do
    let fileLink = hyperLink (cleanString linkText) (fullPath urlPathRec)
    indentedBulletList depth fileLink
