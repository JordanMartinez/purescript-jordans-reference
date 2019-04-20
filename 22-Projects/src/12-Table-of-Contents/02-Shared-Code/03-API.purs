module ToC.API (ProductionEnv, ProductionRows) where

import Data.List (List)
import Data.Maybe (Maybe)
import Data.Tree (Tree)
import ToC.Core.RenderTypes (TopLevelContent)
import ToC.Core.FileTypes (HeaderInfo)
import ToC.Core.Paths (FilePath, WebUrl)
import ToC.Domain.Types (LogLevel, Env)

-- | Production Rows completes our Env type for the production monad
-- | - a file to which we write the output when finished
-- | - a function for parsing a file's content. One could use a different parser
-- |   library is so desired:
-- |    - `parseFile`
-- | - functions that render specific parts of the content. One could render
-- |   it as Markdown or as HTML:
-- |    - `renderToC`
-- |    - `renderTopLevel`
-- |    - `renderDir`
-- |    - `renderFile`
-- | - A level that indicates how much information to log to the console
-- |    - `logLevel`
type ProductionRows = ( outputFile :: FilePath
                      , parseFile :: FilePath -> String -> List (Tree HeaderInfo)
                      , renderToC :: Array TopLevelContent -> String
                      , renderTopLevel :: FilePath -> Array String -> TopLevelContent
                      , renderDir :: Int -> FilePath -> Array String -> String
                      , renderFile :: Int -> Maybe WebUrl -> FilePath -> List (Tree HeaderInfo) -> String
                      , logLevel :: LogLevel
                      )
type ProductionEnv = Env ProductionRows
