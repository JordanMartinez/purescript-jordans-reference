-- | Provides a CLI interface to our program via the Yargs library.
module ToC.Infrastructure.OptParse (parseCLIArgs) where

import Prelude

import Data.Array (filter, intercalate)
import Data.Array as Array
import Data.Either (Either(..))
import Data.Foldable (elem, notElem)
import Data.List (List(..))
import Data.String (Pattern(..), length, split, take)
import Data.String as String
import Data.String.Utils (endsWith)
import Data.Tree (Tree)
import Node.Path (extname, sep)
import Options.Applicative (Parser, ParserInfo, eitherReader, fullDesc, help, helper, info, long, metavar, option, progDesc, short, showDefault, showDefaultWith, strOption, switch, value)
import Options.Applicative.Types (ReadM)
import ToC.API (ProductionEnv)
import ToC.Core.FileTypes (HeaderInfo)
import ToC.Core.GitHubLinks (renderGHPath)
import ToC.Core.Paths (FilePath, IncludeablePathType(..), WebUrl, addPath')
import ToC.Domain.Parser (extractMarkdownHeaders, extractPurescriptHeaders)
import ToC.Domain.Renderer.MarkdownRenderer (renderDir, renderFile, renderToC, renderTopLevel)
import ToC.Domain.Types (LogLevel(..))
import ToC.Infrastructure.OSFFI (endOfLine)

parseCLIArgs :: ParserInfo ProductionEnv
parseCLIArgs =
    info
      ( helper <*> argParser )
      ( fullDesc
     <> progDesc "Produces a Table of Contents file in Markdown whose links \
                 \refer to a GitHub repo's corresponding file."
      )

argParser :: Parser ProductionEnv
argParser = ado
    rootDir <- parseRootDir
    outputFile <- parseOutputFile
    excludedTopLevelDirs <- parseExcludedTopLevelDirs
    excludedRegularDir <- parseExcludedRegularDirs
    includedFileExtensions <- parseIncludedFileExtensions
    username <- parseGitHubUsername
    project <- parseGitHubProject
    ref <- parseGitHubRef
    logLevel <- parseLogLevel
    skipUrlCheck <- parseSkipUrlCheck
    in createProdEnv
        rootDir outputFile
        excludedTopLevelDirs excludedRegularDir includedFileExtensions
        username project ref
        logLevel skipUrlCheck
  where
    parseRootDir :: Parser String
    parseRootDir =
      strOption ( long "root-dir"
               <> short 'r'
               <> help "The local computer's file path to the root directory \
                       \that contains this repository."
               <> metavar "ROOT_DIR"
               )

    parseOutputFile :: Parser String
    parseOutputFile =
      strOption ( long "output-file"
               <> short 'o'
               <> help "The path of the file to which to write the \
                        \program's Table of Contents output"
               <> metavar "OUTPUT_FILE"
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
         <> value [ ".git", ".github", ".procedures", ".travis", "output"]
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

    parseGitHubUsername :: Parser String
    parseGitHubUsername =
      strOption ( long "github-username"
               <> short 'u'
               <> help "The username part of the GitHub repository's URL."
               <> metavar "USERNAME"
               <> value "JordanMartinez"
               <> showDefault
                )

    parseGitHubProject :: Parser String
    parseGitHubProject =
      strOption ( long "github-project"
               <> short 'p'
               <> help "The project name part of the GitHub repository's URL."
               <> metavar "PROJECT_NAME"
               <> value "purescript-jordans-reference"
               <> showDefault
                )

    parseGitHubRef :: Parser String
    parseGitHubRef =
      strOption ( long "github-reference"
               <> help "The name of the project's branch or tag to use when \
                        \producing the hyperlinks to files and their headers."
               <> metavar "TAG_OR_BRANCH"
               <> value "development"
               <> showDefault
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

    parseSkipUrlCheck :: Parser Boolean
    parseSkipUrlCheck =
      switch ( long "skip-url-verification"
            <> help "Do not verify whether hyperlinks work, \
                    \but still render the ToC file with them."
             )

createProdEnv :: FilePath -> FilePath ->
                 Array String -> Array String -> Array String ->
                 String -> String -> String ->
                 String -> Boolean ->
                 ProductionEnv
createProdEnv rootDirectory outputFile
             excludedTopLevelDirs excludedRegularDir includedFileExtensions
             ghUsername ghProjectName ghBranchName
             logLevel skipVerification
             =
      { rootUri: { fs: rootDir
                 , url: rootURL
                 }
      , addPath: addPath' sep
      , includePath: includePath
      , outputFile: outputFile
      , sortPaths: sortPaths
      , parseFile: parseFile
      , renderToC: renderToC
      , renderTopLevel: renderTopLevel
      , renderDir: renderDir
      , renderFile: renderFile
      , logLevel: level
      , shouldVerifyLinks: not skipVerification
      }
  where
    rootDir :: FilePath
    rootDir =
        if endsWith sep rootDirectory
          then take ((length rootDirectory) - 1) rootDirectory
          else rootDirectory

    rootURL :: WebUrl
    rootURL = renderGHPath { username: ghUsername
                             , repo: ghProjectName
                             , ref: ghBranchName
                             }

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

    parseFile :: FilePath -> String -> List (Tree HeaderInfo)
    parseFile filePath content =
        case extname filePath of
          ".purs" -> extractPurescriptHeaders $ split (Pattern endOfLine) content
          ".md" -> extractMarkdownHeaders $ split (Pattern endOfLine) content
          _ -> Nil

    level :: LogLevel
    level =
        case logLevel of
          "info" -> Info
          "debug" -> Debug
          _ -> Error
