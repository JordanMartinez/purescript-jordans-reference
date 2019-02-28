module Projects.ToC.Core.Paths
  ( PathType(..)
  , FilePath
  , WebUrl
  , UriPath
  , AddPath
  , addPath'
  ) where

import Data.Semigroup ((<>))

data PathType
  = Dir
  | File

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
