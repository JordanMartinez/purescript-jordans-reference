module Projects.ToC.Core.Paths
  ( PathType(..)
  , DirectoryPath(..)
  , FileExtension
  , FsPath
  , WebUrl
  , PathUri
  , addPath'
  , RootToParentDir(..)
  ) where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)

-- | Indicates whether a path is a directory or a file.
data PathType
  = Dir
  | File

-- | Indicates that a String is a part of the absolute path name for a file.
-- | For example, "child" in "root/parent/child/folder/file.txt"
newtype DirectoryPath = DirectoryPath String

derive instance genericDirectoryPath :: Generic DirectoryPath _
instance showDirectoryPath :: Show DirectoryPath where
  show x = genericShow x

type FileExtension = String

-- | A backend-independent type for a String that is an absolute or relative
-- | path on the file system.
-- | For example: ".", "./Documents", "absolute/path/file.md"
type FsPath = String

-- | A string that is a website URL.
-- | For example, 'https://www.github.com/user/project/'
type WebUrl = String

type PathUri = { fs :: FsPath
               , url :: WebUrl
               }

-- | Acts like a file-system/url path accumulator adding the corresponding
-- | separator character followed by the path.
type AddPath = PathUri -> FsPath -> PathUri

-- | Backend-independent helper function for creating an `AddPath` function.
addPath' :: String -> AddPath
addPath' fsSeparator uri path =
  { fs:  uri.fs <> fsSeparator <> path
  , url: uri.fs <> "/" <> path
  }

newtype RootToParentDir = RootToParentDir String
