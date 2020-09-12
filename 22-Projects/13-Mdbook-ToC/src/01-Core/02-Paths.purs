module ToC.Core.Paths where

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
      Just par -> Just (par <> sep <> rec.path)

addParentPrefix :: PathRec -> FilePath -> PathRec
addParentPrefix rec parent = rec { parent = newParent }
  where
    newParent = case rec.parent of
      Nothing -> Just parent
      Just par -> Just (parent <> sep <> par)

parentPath :: PathRec -> FilePath
parentPath { root, parent } = root <> parentPart
  where
    parentPart = maybe "" (\par -> sep <> par) parent

fullPath :: PathRec -> FilePath
fullPath { root, parent, path } = root <> parentPart <> sep <> path
  where
    parentPart = maybe "" (\par -> sep <> par) parent
