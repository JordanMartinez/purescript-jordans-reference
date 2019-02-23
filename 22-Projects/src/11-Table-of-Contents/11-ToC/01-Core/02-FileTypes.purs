module Projects.ToC.Core.FileTypes
  ( GenHeaderLink
  , FileWithHeaders
  , Directory(..)
  , ParsedContent
  , ParsedDirContent
  , TopLevelDirectory(..)
  ) where

import Data.Either (Either)
import Data.List.Types (List)
import Data.Tree (Tree)
import Projects.ToC.Core.Paths (DirectoryPath)

-- | a function takes the URL to a file and produces a markdown hyperlink
-- | for one of its headers. In other words:
-- | ```purescript
-- |  (\indentNumber absoluteURLToFile ->
-- |     "[" <> headerText <> "](#" <> absoluteURLToFile <>
-- |                            "#" <> anchorLink <> ")"
-- | )
-- | ```
type GenHeaderLink = Int -> String

-- | A file that includes headers within it.
type FileWithHeaders =
  { fileName :: String
  , headers :: List (Tree GenHeaderLink)
  }

-- | A directory that includes either instances of FileWithHeaders with
-- | different header types (via row kinds) or additional directories
data Directory =
  Directory
    DirectoryPath
    (List (Either Directory FileWithHeaders))

type ParsedContent = Either Directory FileWithHeaders

type ParsedDirContent = List ParsedContent

-- | Same structure as `Directory`, but this type cannot be nested.
data TopLevelDirectory =
  TopLevelDirectory DirectoryPath ParsedDirContent
