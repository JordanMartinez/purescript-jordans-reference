module Projects.ToC.Renderer
  ( renderToCFile
  , RootURL(..)
  , renderGHPath
  ) where

import Prelude

import Control.Comonad.Cofree (head, tail)
import Control.Monad.Rec.Class (Step(..), tailRec)
import Data.Either (Either(..))
import Data.Foldable (foldl)
import Data.List (List(..), (:))
import Data.String (Pattern(..), Replacement(..), replace, replaceAll, toLower)
import Data.Tree (Tree)
import Projects.ToC.Core.FileTypes (GenHeaderLink, Directory(..), ParsedContent, TopLevelDirectory(..))
import Projects.ToC.Core.GitHubLinks (GitHubRepo)
import Projects.ToC.Core.Paths (DirectoryPath(..), RootToParentDir(..))
import Projects.ToC.Domain.Markdown (anchorLink, bulletList, emptyLine, h1, h2, hyperLink, indentedBulletList)

newtype RootURL = RootURL String

renderToCFile :: RootURL -> List TopLevelDirectory -> String
renderToCFile rootURL results =
  (h1 "Table of Contents") <>
  emptyLine <>
  (foldl (\acc next -> acc <> renderToC next) "" results) <>
  emptyLine <>
  (foldl (\acc next -> acc <> renderSection rootURL next) "" results)

replaceDashesWithSpace :: String -> String
replaceDashesWithSpace =
  replaceAll (Pattern "-") (Replacement " ") <<< replace (Pattern "--") (Replacement ": ")

renderToC :: TopLevelDirectory -> String
renderToC (TopLevelDirectory (DirectoryPath path) _) =
  bulletList (anchorLink (replaceDashesWithSpace path) (toLower path))

renderSection :: RootURL -> TopLevelDirectory -> String
renderSection r@(RootURL rootURL) (TopLevelDirectory (DirectoryPath path) children) =
  (h2 (replaceDashesWithSpace path)) <>
  emptyLine <>
  (foldl (\acc next -> acc <> (renderContent r (RootToParentDir (path <> "/")) 0 next)) "" children) <>
  emptyLine

renderContent :: RootURL -> RootToParentDir -> Int -> ParsedContent -> String
renderContent r@(RootURL rootURL) (RootToParentDir dirPath) depth content =
  case content of
    Right file ->
      let
        fullFilePath = rootURL <> dirPath <> file.fileName
      in
        indentedBulletList depth (hyperLink (replaceDashesWithSpace file.fileName) fullFilePath) <>
        (foldl (\acc next -> acc <> (renderHeaderTree (depth + 1) fullFilePath next)) "" file.headers)
    Left (Directory (DirectoryPath path) children) ->
      let
        rootToParent = RootToParentDir $ dirPath <> path <> "/"
      in
        indentedBulletList depth (replaceDashesWithSpace path) <>
        foldl (\acc next -> acc <> (renderContent r rootToParent (depth + 1) next)) "" children

renderHeaderTree :: Int -> String -> Tree GenHeaderLink -> String
renderHeaderTree d filePath next =
  let
    genHeaderLink = head next
  in
    genHeaderLink d filePath <>
    tailRec go {level: d, drawn: "", current: tail next }

  where
    go :: _ -> Step _ String
    go {level: l, drawn: s, current: Nil} = Done s
    go {level: l, drawn: s, current: c:cs } =
      let
        genHeaderLink' = head c
        drawn = genHeaderLink' l filePath
      in
        Loop { level: l
             , drawn: s <> drawn <> (tailRec go {level: l + 1, drawn: "", current: (tail c)})
             , current: cs
             }

-- ## Renderers for GitHub links

renderGHPath :: GitHubRepo -> String
renderGHPath gh =
  "https://www.github.com/" <> gh.username <> "/" <> gh.repo <> "/blob/" <> gh.ref <> "/"
