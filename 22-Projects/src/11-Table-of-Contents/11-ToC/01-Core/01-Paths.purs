module Projects.ToC.Core.Paths
  ( FileExtension
  , PathType(..)
  , DirectoryPath(..)
  , FilePath
  , WebUrl
  , PathUri
  , AddPath
  , addPath'
  , RootToParentDir(..)
  ) where

import Data.Semigroup ((<>))
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Show (class Show)

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

type FilePath = String

type WebUrl = String

-- | Works with `AddPath` to efficiently add a file path to both its
-- | file-system version and its website url version
type PathUri = { fs :: FilePath
               , url :: WebUrl
               }

type AddPath = PathUri -> FilePath -> PathUri

-- | Creates an `AddPath` given a backend-specific way to get the file separator
-- | character.
addPath' :: String -> AddPath
addPath' fsSeparator =
  (\pUri path ->
    { fs: pUri.fs <> fsSeparator <> path
    , url: pUri.url <> "/" <> path
    }
  )

newtype RootToParentDir = RootToParentDir String
