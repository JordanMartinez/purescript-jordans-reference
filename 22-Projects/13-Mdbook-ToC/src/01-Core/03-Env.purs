module ToC.Core.Env where

import Prelude

import ToC.Core.Paths (FilePath, IncludeablePathType, PathRec)

-- | The Environment type specifies the following ideas:
-- | - a backend-independent way to create file system paths. For example,
-- |   one could run the program via Node, C++, C, Erlang, or another such
-- |   backend:
-- |    - `rootUri`
-- |    - `addPath`
-- | - a function for sorting paths (e.g. ReadMe.md file appears first before
-- |      all others)
-- | - a function to determine which directories and files to include/exclude:
-- |    - `includepath`
-- | - A flag that indicates whether to verify links or not
type Env r = { rootPath :: FilePath
             , sortPaths :: FilePath -> FilePath -> Ordering
             , includePath :: IncludeablePathType -> FilePath -> Boolean
             , mdbook :: { outputDir :: FilePath
                         , headerFilePath :: FilePath
                         , summaryFilePath :: FilePath
                         }
             | r
             }

-- | The amount and type of information to log.
data LogLevel
  = Error
  | Info
  | Debug

derive instance eqLogLevel :: Eq LogLevel
derive instance ordLogLevel :: Ord LogLevel

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
type ProductionRows = ( renderFile :: Int -> FilePath -> PathRec -> String
                      , logLevel :: LogLevel
                      )
type ProductionEnv = Env ProductionRows
