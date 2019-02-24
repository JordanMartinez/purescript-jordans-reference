module Projects.ToC.Core.GitHubLinks
  ( GitHubRepo
  , renderGHPath
  ) where

import Data.Semigroup ((<>))

type GitHubRepo = { username :: String
                  , repo :: String
                  , ref :: String
                  }

renderGHPath :: GitHubRepo -> String
renderGHPath gh =
  "https://www.github.com/" <> gh.username <> "/" <> gh.repo <> "/blob/" <> gh.ref
