-- | Provides a CLI interface to our program via the Yargs library.
module ToC.Infrastructure.OptParse (parseCLIArgs) where

import Prelude

import Data.Array (filter, intercalate)
import Data.Array as Array
import Data.Either (Either(..))
import Data.Foldable (elem, notElem)
import Data.String (Pattern(..), length, split, take)
import Data.String as String
import Data.String.Utils (endsWith)
import Node.Path (extname, sep)
import Options.Applicative (Parser, ParserInfo, eitherReader, fullDesc, help, helper, info, long, metavar, option, progDesc, short, showDefault, showDefaultWith, strOption, switch, value)
import Options.Applicative.Types (ReadM)
import ToC.Core.Paths (FilePath, IncludeablePathType(..))
import ToC.Core.Env (ProductionEnv, LogLevel(..))
import ToC.Renderer.MarkdownRenderer (renderFile)

parseCLIArgs :: ParserInfo ProductionEnv
parseCLIArgs =
    info
      ( helper <*> argParser )
      ( fullDesc
     <> progDesc "Produces a Table of Contents file in Markdown whose links \
                 \refer to a GitHub repo's corresponding file."
      )

argParser :: Parser ProductionEnv
argParser =
  createProdEnv <$> parseRootDir
                <*> parseOutputDir
                <*> parseHeaderFile
                <*> parseExcludedTopLevelDirs
                <*> parseExcludedRegularDirs
                <*> parseIncludedFileExtensions
                <*> parseLogLevel
  where
    parseRootDir :: Parser String
    parseRootDir =
      strOption ( long "root-dir"
               <> short 'r'
               <> help "The local computer's file path to the root directory \
                       \that contains this repository."
               <> metavar "ROOT_DIR"
               )

    parseOutputDir :: Parser String
    parseOutputDir =
      strOption ( long "output-directory"
               <> short 'o'
               <> help "The path of the directory which corresponds to the \
                        \`mdbook`'s source directory."
               <> metavar "OUTPUT_DIRECTORY"
                )

    parseHeaderFile :: Parser String
    parseHeaderFile =
      strOption ( long "summary-header-file"
               <> short 's'
               <> help "The path of the file within the output directory \
                       \that should appear before the outputted \
                       \Table of Contents content"
               <> metavar "SUMMARY_HEADER_FILE"
               <> value "Summary-header.md"
               <> showDefault
                )

    multiString :: ReadM (Array String)
    multiString = eitherReader \s ->
      let strArray = filter (not <<< String.null) $ split (Pattern ",") s
      in
        if Array.null strArray
          then Left "got empty string as input"
          else Right strArray

    parseExcludedTopLevelDirs :: Parser (Array String)
    parseExcludedTopLevelDirs =
        option multiString
          ( long "exclude-top-level-dirs"
         <> short 't'
         <> metavar "DIR1,DIR2,...,DIR3"
         <> help "A comma-separated list of top-level directories \
                 \(case-sensitive) to exclude."
         <> value [ ".git", ".github", ".procedures", ".travis", "output", "book", "mdbook"]
         <> showDefaultWith (\array -> intercalate "," array)
          )

    parseExcludedRegularDirs :: Parser (Array String)
    parseExcludedRegularDirs =
        option multiString
          ( long "exclude-regular-dirs"
         <> short 'd'
         <> metavar "DIR1,DIR2,...,DIR3"
         <> help "A comma-separated list of regular directories \
                 \(case-sensitive) to exclude."
         <> value
                -- PS-related directories
                [ ".spago", "generated-docs", ".psci_modules",  "output", "tmp"
                -- NPM and Parcel related things
                , ".cache", "node_modules", "dist"
                -- project-specific files
                , "benchmark-results"
                -- repo-specific files
                , "assets", "modules-used-in-examples"
                -- PS 0.14.x syntax folders
                , "ps-0.14-syntax", "ps-0.14"
                -- Ignore Mdbook work for time being
                , "13-Mdbook-ToC"
                ]
         <> showDefaultWith (\array -> intercalate "," array)
          )

    parseIncludedFileExtensions :: Parser (Array String)
    parseIncludedFileExtensions =
          option multiString
            ( long "include-files-with-extensions"
           <> short 'f'
           <> metavar ".EXT1,.EXT2,...,.EXT3"
           <> help "A comma-separated list of file extensions \
                   \that should be included in the Table of Contents."
           <> value [ ".purs", ".md", ".js"]
           <> showDefaultWith (\array -> intercalate "," array)
            )

    parseLogLevel :: Parser String
    parseLogLevel =
      strOption ( long "log-level"
               <> help "The amount of information to log to the screen. \
                       \Valid options are 'error', 'info', and 'debug'."
               <> metavar "LOG_LEVEL"
               <> value "error"
               <> showDefault
                )

createProdEnv :: FilePath -> FilePath -> FilePath ->
                 Array String -> Array String -> Array String ->
                 String ->
                 ProductionEnv
createProdEnv rootDirectory outputDir headerFile
             excludedTopLevelDirs excludedRegularDir includedFileExtensions
             logLevel
             =
      { rootPath: rootDir
      , includePath: includePath
      , mdbook: { outputDir: outputDir
                , headerFilePath: outputDir <> sep <> headerFile
                , summaryFilePath: outputDir <> sep <> "SUMMARY.md"
                }
      , sortPaths: sortPaths
      , renderFile: renderFile
      , logLevel: level
      }
  where
    rootDir :: FilePath
    rootDir =
        if endsWith sep rootDirectory
          then take ((length rootDirectory) - 1) rootDirectory
          else rootDirectory

    includePath :: IncludeablePathType -> FilePath -> Boolean
    includePath pathType path = case pathType of
      TopLevelDirectory -> notElem path excludedTopLevelDirs
      NormalDirectory -> notElem path excludedRegularDir
      A_File -> elem (extname path) includedFileExtensions

    sortPaths :: FilePath -> FilePath -> Ordering
    sortPaths l r =
      -- ensure that ReadMe files always appear first
      if l == "ReadMe.md" || l == "Readme.md"
        then LT
      else if r == "ReadMe.md" || r == "Readme.md"
        then GT
      else compare l r

    level :: LogLevel
    level =
        case logLevel of
          "info" -> Info
          "debug" -> Debug
          _ -> Error
