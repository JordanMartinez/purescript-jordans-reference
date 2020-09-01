module ToC.Domain.Renderer.MarkdownRenderer
  ( module ToC.Domain.Renderer.MarkdownRenderer
  ) where

import Prelude

import Control.Comonad.Cofree (head, tail)
import Control.Monad.Rec.Class (Step(..), tailRec)
import Data.Foldable (foldl)
import Data.List (List(..), (:))
import Data.Maybe (Maybe(..))
import Data.String (Pattern(..), Replacement(..), replace, replaceAll, toLower)
import Data.Tree (Tree)
import ToC.Core.FileTypes (HeaderInfo)
import ToC.Core.Paths (FilePath, WebUrl)
import ToC.Core.RenderTypes (AllTopLevelContent, TopLevelContent)
import ToC.Domain.Renderer.Markdown (anchorLink, bulletList, emptyLine, h1, h2, indentedBulletList, hyperLink)

formatHyphensInName :: String -> String
formatHyphensInName =
  replace (Pattern "--") (Replacement ": ") >>>
  replaceAll (Pattern "-") (Replacement " ")

-- | Renders the final String that will be written to the output file.
renderToC :: Array TopLevelContent -> String
renderToC = renderToCContent <<< foldTopLevelContentArray

-- | Renders the final String that will be written to the output file.
renderToCContent :: AllTopLevelContent -> String
renderToCContent rec =
      (h1 "Table of Contents") <>
      emptyLine <>
      rec.allToCHeaders <>
      emptyLine <>
      rec.allSections

-- | Accumulates all TopLevelContent records into a single record.
foldTopLevelContentArray :: Array TopLevelContent -> AllTopLevelContent
foldTopLevelContentArray array = do
  let rec = foldl (\acc next ->
              if acc.init
                then { init: false
                     , tocHeader: next.tocHeader
                     , section: next.section
                     }
                else acc { tocHeader = acc.tocHeader <> next.tocHeader
                         , section = acc.section <> "\n" <> next.section
                         }
            ) { init: true, tocHeader: "", section: "" } array
  { allToCHeaders: rec.tocHeader, allSections: rec.section }

-- | Renders a top-level directory
renderTopLevel :: FilePath -> Array String -> TopLevelContent
renderTopLevel pathSeg renderedPaths =
  let pathWithHyphenFormat = formatHyphensInName pathSeg
  in
    { tocHeader: bulletList (anchorLink pathWithHyphenFormat (toLower pathSeg))
    , section: (h2 pathWithHyphenFormat) <>
               emptyLine <>
               (foldl (<>) "" renderedPaths)
    }

-- | Renders a non-top-level directory
renderDir :: Int -> FilePath -> Array String -> String
renderDir depth pathSeg renderedPaths =
      indentedBulletList depth (formatHyphensInName pathSeg) <>
      (foldl (<>) "" renderedPaths)

-- | Renders a file and its headers. When passed a `Just webUrl` argument,
-- | the file's entry and its headers will be rendered as hyperlinks to
-- | the corresponding website. When passed as 'Nothing' argument for the
-- | `Maybe WebUrl` argument, it will simply render the file's name and
-- | its headers as plain text.
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
    -- | Renders all the headers of a single file.
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

    -- | Renders one Tree of markdown headers
    renderHeaderTree :: (Int -> HeaderInfo -> String) ->
                        Int -> Tree HeaderInfo -> String
    renderHeaderTree renderHeader d currentTree = do
        let root = head currentTree
        let children = tail currentTree
        renderHeader d root <>
          tailRec goHeader { level: d + 1, drawn: "", current: children }

      where
        goHeader :: _ -> Step _ String
        goHeader {level: l, drawn: s, current: Nil} = Done s
        goHeader {level: l, drawn: s, current: c:cs } =
            Loop { level: l
                 , drawn: s <>
                          (renderHeader l (head c)) <>
                          -- recursively renders the tree's next-level headers
                          (tailRec goHeader {level: l + 1, drawn: "", current: tail c })
                 , current: cs
                 }

-- | Renders a header as a hyperlink
headerWithLink :: WebUrl -> Int -> HeaderInfo -> String
headerWithLink fileUrl d' h =
  indentedBulletList d' (hyperLink h.text (fileUrl <> h.anchor))

-- | Renders a header as plain text
headerNoLink :: Int -> HeaderInfo -> String
headerNoLink d' h =
  indentedBulletList d' h.text
