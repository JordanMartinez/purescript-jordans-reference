module Projects.ToC.Core.FileTypes
  ( PathType(..)
  , GenHeaderLink
  , FileWithHeaders
  , DirectoryPath(..)
  , Directory(..)
  , ParsedContent
  , ParsedDirContent
  , TopLevelDirectory(..)
  ) where

import Prelude

import Data.Either (Either)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.List.Types (List)
import Data.Tree (Tree)

-- | Indicates whether a path is a directory or a file.
data PathType
  = Dir
  | File

-- | a function takes the URL to a file and produces a markdown hyperlink
-- | for one of its headers. In other words:
-- | ```purescript
-- |  (\indentNumber absoluteURLToFile ->
-- |     "[" <> headerText <> "](#" <> absoluteURLToFile <>
-- |                            "#" <> anchorLink <> ")"
-- | )
-- | ```
type GenHeaderLink = Int -> String -> String

-- | A file that includes headers within it.
type FileWithHeaders =
  { fileName :: String
  , headers :: List (Tree GenHeaderLink)
  }

-- | Indicates that a String is a part of the absolute path name for a file.
-- | For example, "child" in "root/parent/child/folder/file.txt"
newtype DirectoryPath = DirectoryPath String

derive instance genericDirectoryPath :: Generic DirectoryPath _

instance showDirectoryPath :: Show DirectoryPath where
  show x = genericShow x

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
