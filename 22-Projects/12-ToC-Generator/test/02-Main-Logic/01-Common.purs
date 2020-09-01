module Test.ToC.MainLogic.Common (IncludedOrNot, VerifiedOrNot, FileSystemInfo(..), TestRows, TestEnv, separator, getPathName, includePath, isDirectoryInfo, isFileInfo) where

import Prelude

import Data.Tree (Tree, Forest)
import ToC.Core.FileTypes (HeaderInfo)
import ToC.Core.Paths (FilePath)
import ToC.Domain.Types (Env)

type IncludedOrNot = Boolean
type VerifiedOrNot = Boolean

data FileSystemInfo
  = DirectoryInfo FilePath IncludedOrNot
  | FileInfo FilePath IncludedOrNot (Forest HeaderInfo) VerifiedOrNot

instance showFileSystemInfo :: Show FileSystemInfo where
  show (DirectoryInfo path includedOrNot) =
    "DirectoryInfo(path=" <> path <> " includedOrNot=" <> show includedOrNot <> ")"
  show (FileInfo path includedOrNot headerList verifiedOrNot) =
    "FileInfo(path=" <> path <> " includedOrNot=" <> show includedOrNot <>
    " headers=<headerList> verifiedOrNot=" <> show verifiedOrNot <> ")"

type TestRows = ( fileSystem :: Tree FileSystemInfo
                )
type TestEnv = Env TestRows

-- helper functions
separator :: String
separator = "/"

getPathName :: FileSystemInfo -> String
getPathName = case _ of
  DirectoryInfo name _ -> name
  FileInfo name _ _ _ -> name

includePath :: FileSystemInfo -> Boolean
includePath (DirectoryInfo _ value) = value
includePath (FileInfo _ value _ _) = value

isDirectoryInfo :: FileSystemInfo -> Boolean
isDirectoryInfo (DirectoryInfo _ _) = true
isDirectoryInfo _ = false

isFileInfo :: FileSystemInfo -> Boolean
isFileInfo (FileInfo _ _ _ _) = true
isFileInfo _ = false
