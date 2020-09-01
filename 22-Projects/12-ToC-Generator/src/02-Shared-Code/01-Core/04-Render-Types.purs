module ToC.Core.RenderTypes (AllTopLevelContent, TopLevelContent) where

type AllTopLevelContent = { allToCHeaders :: String
                          , allSections :: String
                          }

type TopLevelContent = { tocHeader :: String
                       , section :: String
                       }
