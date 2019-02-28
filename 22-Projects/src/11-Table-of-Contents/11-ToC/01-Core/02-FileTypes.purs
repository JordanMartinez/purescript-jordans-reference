module Projects.ToC.Core.FileTypes
  ( HeaderInfo
  ) where

type HeaderInfo = { level :: Int
                  , text :: String
                  , anchor :: String
                  }
