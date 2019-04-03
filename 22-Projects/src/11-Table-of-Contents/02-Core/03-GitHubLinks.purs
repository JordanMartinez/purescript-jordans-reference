module ToC.Core.GitHubLinks
  ( GitHubRepo
  , renderGHPath
  ) where

import Data.Semigroup ((<>))
import ToC.Core.Paths (WebUrl)

-- | All the info needed to render the URL to a file in the given
-- | GitHub repository.
type GitHubRepo = { username :: String
                  , repo :: String
                  , ref :: String
                  }

-- | Produces a WebUrl that can be used as the url in UriPath for the
-- | initial path.
renderGHPath :: GitHubRepo -> WebUrl
renderGHPath gh =
  "https://github.com/" <> gh.username <> "/" <> gh.repo <> "/blob/" <> gh.ref
