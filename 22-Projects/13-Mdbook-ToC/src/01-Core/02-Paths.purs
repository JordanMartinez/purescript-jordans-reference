module ToC.Core.Paths
  ( PathType(..)
  , IncludeablePathType(..)
  , FilePath
  , WebUrl
  , PathRec
  , mkPathRec
  , addPath
  , fullPath
  , UriPath
  , AddPath
  , addPath'
  ) where

import Data.Semigroup ((<>))
import Node.Path (sep)
import Data.Maybe (Maybe(..), maybe)

-- | Backend-independent indicator for whether a path is a directory or a file.
-- | Note: there is no distinction between a top-level directory and a regular
-- | directory.
data PathType
  = Dir
  | File

-- | Similar to 'PathType' but does distinguish between a top-level and normal
-- | directory. This is used to determine whether to include a path or not
-- | when parsing content in the root directory.
data IncludeablePathType
  = TopLevelDirectory
  | NormalDirectory
  | A_File -- prevents naming conflict with "PathType's" "File" constructor.

-- | Backend-independent type for a path on the file system. It could be
-- | "path" in "root/parent/path/child.txt", "file.txt" in
-- | "root/parent/file.txt", or the entirety of "root/parent/file.txt"
type FilePath = String

type PathRec = { root :: FilePath, parent :: Maybe FilePath, path :: FilePath }

mkPathRec :: FilePath -> FilePath -> PathRec
mkPathRec root path = { root, parent: Nothing, path }

addPath :: PathRec -> FilePath -> PathRec
addPath rec path = rec { parent = newParent, path = path }
  where
    newParent = case rec.parent of
      Nothing -> Just rec.path
      Just par -> Just (rec.path <> sep <> rec.path)

fullPath :: PathRec -> FilePath
fullPath { root, parent, path } = root <> parentPart <> sep <> path
  where
    parentPart = maybe "" (\par -> sep <> par) parent

-- | Backend-independent type for a website url. It could be
-- | "https://github.com", "https://github.com/userName", or
-- | "https://github.com/userName/projectName/blob/master/ReadMe.md"
type WebUrl = String

-- | Indicates the absolute path of either a directory or a file
-- | in both 'path versions:' the file system and the website URL
type UriPath = { fs :: FilePath
               , url :: WebUrl
               }

-- | Adds the file path to file system's path using an os-specific file
-- | separator character and to the current WebUrl
type AddPath = UriPath -> FilePath -> UriPath

-- | Creates an `AddPath` given a backend-specific way to get the file separator
-- | character.
addPath' :: String -> UriPath -> FilePath -> UriPath
addPath' fsSep rec path =
  { fs: rec.fs <> fsSep <> path
  , url: rec.url <> "/" <> path
  }
