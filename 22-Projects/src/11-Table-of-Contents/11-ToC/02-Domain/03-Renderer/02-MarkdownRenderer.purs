module Projects.ToC.Domain.Renderer.MarkdownRenderer
  ( module Projects.ToC.Domain.Renderer.MarkdownRenderer
  ) where

import Prelude

import Control.Comonad.Cofree (head, tail)
import Control.Monad.Rec.Class (Step(..), tailRec)
import Data.Foldable (foldl)
import Data.List (List(..), (:))
import Data.Maybe (Maybe(..))
import Data.String (Pattern(..), Replacement(..), replace, replaceAll, toLower)
import Data.Tree (Tree)
import Projects.ToC.Core.FileTypes (HeaderInfo)
import Projects.ToC.Core.Paths (FilePath, WebUrl)
import Projects.ToC.Domain.FixedLogic (AllTopLevelContent, TopLevelContent)
import Projects.ToC.Domain.Renderer.Markdown (anchorLink, bulletList, emptyLine, h1, h2, indentedBulletList, hyperLink)

formatHyphensInName :: String -> String
formatHyphensInName =
  replace (Pattern "--") (Replacement ": ") >>>
  replaceAll (Pattern "-") (Replacement " ")

renderToC :: AllTopLevelContent -> String
renderToC rec =
      (h1 "Table of Contents") <>
      emptyLine <>
      rec.allToCHeaders <>
      emptyLine <>
      rec.allSections

renderTopLevel :: FilePath -> Array String -> TopLevelContent
renderTopLevel pathSeg renderedPaths =
  let pathWithHyphenFormat = formatHyphensInName pathSeg
  in
    { tocHeader: bulletList (anchorLink pathWithHyphenFormat (toLower pathSeg))
    , section: (h2 pathWithHyphenFormat) <>
               emptyLine <>
               (foldl (<>) "" renderedPaths)
    }

renderDir :: Int -> FilePath -> Array String -> String
renderDir depth pathSeg renderedPaths =
      indentedBulletList depth (formatHyphensInName pathSeg) <>
      (foldl (<>) "" renderedPaths)

renderFile :: Int -> Maybe WebUrl -> FilePath -> List (Tree HeaderInfo) -> String
renderFile depth url pathSeg headers = do
    let formattedName = formatHyphensInName pathSeg
    let startingHeaderDepth = depth + 1
    case url of
      Just link -> do
        let fileLink = hyperLink formattedName link
        indentedBulletList depth fileLink <>
        (renderHeaders (headerWithLink link) startingHeaderDepth)
      Nothing ->
        indentedBulletList depth formattedName <>
        (renderHeaders headerNoLink startingHeaderDepth)

  where
    headerWithLink :: WebUrl -> Int -> HeaderInfo -> String
    headerWithLink fileUrl d' h =
      indentedBulletList d' (hyperLink h.text (fileUrl <> h.anchor))

    headerNoLink :: Int -> HeaderInfo -> String
    headerNoLink d' h =
      indentedBulletList d' h.text

    renderHeaders :: (Int -> HeaderInfo -> String) -> Int -> String
    renderHeaders renderHeader topHeadersDepth =
      tailRec goHeaderList { content: "", current: headers }

      where
        goHeaderList ::      { content :: String, current :: List (Tree HeaderInfo) }
                     -> Step { content :: String, current :: List (Tree HeaderInfo) } String
        goHeaderList { content: c, current: Nil } = Done c
        goHeaderList { content: c, current: nextTree:remainingTrees } =
          Loop { content: c <> renderHeaderTree renderHeader topHeadersDepth nextTree
               , current: remainingTrees
               }

    renderHeaderTree :: (Int -> HeaderInfo -> String) ->
                        Int -> Tree HeaderInfo -> String
    renderHeaderTree renderHeader d currentTree = do
        let root = head currentTree
        let children = tail currentTree
        renderHeader d root <>
        tailRec goHeader { level: d, drawn: "", current: children }

      where
        goHeader :: _ -> Step _ String
        goHeader {level: l, drawn: s, current: Nil} = Done s
        goHeader {level: l, drawn: s, current: c:cs } =
            Loop { level: l
                 , drawn: s <>
                          (renderHeader l (head c)) <>
                          (tailRec goHeader {level: l + 1, drawn: "", current: tail c })
                 , current: cs
                 }
