module Projects.ToC.Domain.Renderer.MarkdownRenderer where

import Prelude

import Control.Alt ((<|>))
import Control.Comonad.Cofree (head, tail)
import Control.Monad.Rec.Class (Step(..), tailRec)
import Data.Either (Either(..))
import Data.Foldable (foldl)
import Data.List (List(..), (:))
import Data.String (Pattern(..), Replacement(..), replace, replaceAll, toLower)
import Data.Tree (Tree)
import Projects.ToC.Core.FileTypes (Directory(..), HeaderInfo, ParsedContent, TopLevelDirectory(..), ParsedDirContent)
import Projects.ToC.Core.Paths (AddPath, DirectoryPath(..), WebUrl)
import Projects.ToC.Domain.Renderer.Markdown (anchorLink, bulletList, emptyLine, h1, h2, hyperLink, indentedBulletList)

renderToCFile :: AddPath -> WebUrl -> List TopLevelDirectory -> { content :: String, links :: List WebUrl }
renderToCFile addUrlPath rootURL results =
  { content: (h1 "Table of Contents") <>
             emptyLine <>
             rec.tocHeader <>
             emptyLine <>
             rec.tocSections
  , links: rec.links
  }

  where
    rec :: { tocHeader :: String, tocSections :: String, links :: List WebUrl }
    rec =
      tailRec goTop { tocHeader: "", tocSections: "", links: Nil, current: results }

    goTop ::      { tocHeader :: String, tocSections :: String, links :: List WebUrl, current :: List TopLevelDirectory }
          -> Step { tocHeader :: String, tocSections :: String, links :: List WebUrl, current :: List TopLevelDirectory }
                  { tocHeader :: String, tocSections :: String, links :: List WebUrl }
    goTop { tocHeader: tocHeader, tocSections: tocSections, links: links, current: Nil } =
          Done { tocHeader: tocHeader, tocSections: tocSections, links: links }
    goTop { tocHeader: tocHeader, tocSections: tocSections, links: links, current: next:remaining } =
        let contentAndLinks = renderSection addUrlPath rootURL next
        in Loop { tocHeader: tocHeader <> renderToC next
                , tocSections: tocSections <> contentAndLinks.content
                , links: contentAndLinks.links <|> links
                , current: remaining
                }

formatHyphensInName :: String -> String
formatHyphensInName =
  replaceAll (Pattern "-") (Replacement " ") <<< replace (Pattern "--") (Replacement ": ")

renderToC :: TopLevelDirectory -> String
renderToC (TopLevelDirectory (DirectoryPath path) _) =
  bulletList (anchorLink (formatHyphensInName path) (toLower path))

renderSection :: AddPath -> WebUrl -> TopLevelDirectory -> { content :: String, links :: List WebUrl }
renderSection addUrlPath rootUrl (TopLevelDirectory (DirectoryPath path) children) =
  { content: h2 (formatHyphensInName path) <>
             emptyLine <>
             rec.content <>
             emptyLine
  , links: rec.links
  }

  where
    rec :: { content :: String, links :: List WebUrl }
    rec =
      tailRec goSection { content: "", links: Nil, current: children }

    goSection ::      {content :: String, links :: List WebUrl, current :: ParsedDirContent }
              -> Step {content :: String, links :: List WebUrl, current :: ParsedDirContent }
                      {content :: String, links :: List WebUrl }
    goSection { content: content, links: links, current: Nil } = Done { content: content, links: links }
    goSection { content: content, links: links, current: next:remaining } =
        let contentAndLinks = renderContent addUrlPath (addUrlPath rootUrl path) 0 next
        in Loop { content: content <> contentAndLinks.content
                , links: contentAndLinks.links <|> links
                , current: remaining
                }

renderContent :: AddPath -> WebUrl -> Int -> ParsedContent -> { content :: String, links :: List WebUrl }
renderContent addUrlPath urlSoFar depth content =
  case content of
    Right file ->
      let
        fullFileUrl = addUrlPath urlSoFar file.fileName
        fileLink = hyperLink (formatHyphensInName file.fileName) fullFileUrl
      in
        { content: indentedBulletList depth fileLink <>
                   (tailRec goFile { content: "", depth: depth + 1, fileURL: fullFileUrl, current: file.headers })
        , links: fullFileUrl : Nil
        }
    Left (Directory (DirectoryPath path) children) ->
      let
        fullDirUrl = addUrlPath urlSoFar path
        contentAndLinks = foldl (\acc next ->
                            let contentAndLinks' = renderContent addUrlPath fullDirUrl (depth + 1) next
                            in { content: acc.content <> contentAndLinks'.content
                               , links: contentAndLinks'.links <|> acc.links
                               }
                          ) { content: "", links: Nil } children
      in
        { content: indentedBulletList depth (formatHyphensInName path) <>
                   contentAndLinks.content
        , links: contentAndLinks.links
        }

  where
    goFile ::      { content :: String, depth :: Int, fileURL :: WebUrl, current :: List (Tree HeaderInfo) }
           -> Step { content :: String, depth :: Int, fileURL :: WebUrl, current :: List (Tree HeaderInfo) }
                   String
    goFile { content: c, depth: d, fileURL: fileURL, current: Nil } = Done c
    goFile { content: c, depth: d, fileURL: fileURL, current: next:remaining } =
      Loop { content: c <> renderHeaderTree depth fileURL next
           , depth: d
           , fileURL: fileURL
           , current: remaining
           }

renderHeaderTree :: Int -> WebUrl -> Tree HeaderInfo -> String
renderHeaderTree d fullFileUrl next =
    renderHeader d (head next) <>
    tailRec goHeader { level: d, drawn: "", current: tail next }

  where
    renderHeader :: Int -> HeaderInfo -> String
    renderHeader depth header =
      indentedBulletList depth $ hyperLink header.text (fullFileUrl <> header.anchor)

    goHeader :: _ -> Step _ String
    goHeader {level: l, drawn: s, current: Nil} = Done s
    goHeader {level: l, drawn: s, current: c:cs } =
        Loop { level: l
             , drawn: s <>
                      (renderHeader l (head c)) <>
                      (tailRec goHeader {level: l + 1, drawn: "", current: tail c })
             , current: cs
             }
