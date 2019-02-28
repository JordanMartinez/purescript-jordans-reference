module Projects.ToC.Core.Paths
  ( FileExtension
  , PathType(..)
  , FilePath
  , WebUrl
  , UriPath
  , AddPath
  , addPath'
  ) where

import Data.Semigroup ((<>))

-- | Indicates whether a path is a directory or a file.
data PathType
  = Dir
  | File

-- | Indicates that a String is a file extension that includes the '.'
-- | character. For example, ".purs", ".md", etc.
type FileExtension = String

type FilePath = String

type WebUrl = String

type UriPath = { fs :: FilePath
               , url :: WebUrl
               }

type AddPath = UriPath -> FilePath -> UriPath

-- | Creates an `AddPath` given a backend-specific way to get the file separator
-- | character.
addPath' :: String -> UriPath -> FilePath -> UriPath
addPath' fsSep rec path =
  { fs: rec.fs <> fsSep <> path
  , url: rec.url <> "/" <> path
  }
