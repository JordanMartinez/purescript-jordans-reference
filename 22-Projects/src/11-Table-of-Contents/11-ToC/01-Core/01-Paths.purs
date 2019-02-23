module Projects.ToC.Core.Paths
  ( FileExtension
  , PathType(..)
  , DirectoryPath(..)
  , RootToParentDir(..)
  ) where

import Data.Show (class Show)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)

-- | Indicates whether a path is a directory or a file.
data PathType
  = Dir
  | File

-- | Indicates that a String is a file extension that includes the '.'
-- | character. For example, ".purs", ".md", etc.
type FileExtension = String

-- | Indicates that a String is a part of the absolute path name for a file.
-- | For example, "child" in "root/parent/child/folder/file.txt"
newtype DirectoryPath = DirectoryPath String

derive instance genericDirectoryPath :: Generic DirectoryPath _

instance showDirectoryPath :: Show DirectoryPath where
  show x = genericShow x

newtype RootToParentDir = RootToParentDir String
