module ToC.API (ProductionEnv, ProductionRows) where

import Data.List (List)
import Data.Maybe (Maybe)
import Data.Tree (Tree)
import ToC.Core.RenderTypes (TopLevelContent)
import ToC.Core.FileTypes (HeaderInfo)
import ToC.Core.Paths (FilePath, WebUrl)
import ToC.Domain.Types (LogLevel, Env)

type ProductionRows = ( outputFile :: FilePath
                      , parseFile :: FilePath -> String -> List (Tree HeaderInfo)
                      , renderToC :: Array TopLevelContent -> String
                      , renderTopLevel :: FilePath -> Array String -> TopLevelContent
                      , renderDir :: Int -> FilePath -> Array String -> String
                      , renderFile :: Int -> Maybe WebUrl -> FilePath -> List (Tree HeaderInfo) -> String
                      , logLevel :: LogLevel
                      )
type ProductionEnv = Env ProductionRows
