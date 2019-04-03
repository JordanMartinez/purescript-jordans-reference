module ToC.Core.FileTypes
  ( HeaderInfo
  ) where

-- | Stores all the information needed to render
-- | a markdown header in a nested format.
type HeaderInfo = { level :: Int
                  , text :: String
                  , anchor :: String
                  }
