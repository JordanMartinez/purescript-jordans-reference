-- | Provides a CLI interface to our program via the Yargs library.
module Projects.ToC.Infrastructure.CLI.Yargs (runProgramViaCLI) where

import Prelude

import Data.Either (Either(..))
import Data.Foldable (elem, notElem)
import Data.List (List(..))
import Data.Maybe (Maybe(..))
import Data.String (Pattern(..), split)
import Data.String.CodeUnits (length, take)
import Data.String.Utils (endsWith)
import Data.Tree (Tree)
import Effect (Effect)
import Node.Path (extname, sep)
import Node.Yargs.Applicative (runY, yarg)
import Node.Yargs.Setup (YargsSetup, example, usage)
import Projects.ToC.Core.FileTypes (HeaderInfo)
import Projects.ToC.Core.GitHubLinks (renderGHPath)
import Projects.ToC.Core.Paths (FilePath, WebUrl, addPath')
import Projects.ToC.Domain.BusinessLogic (Env, LogLevel(..))
import Projects.ToC.Domain.Parser (extractMarkdownHeaders, extractPurescriptHeaders)
import Projects.ToC.Domain.Renderer.MarkdownRenderer (renderToC, renderTopLevel, renderDir, renderFile)
import Projects.ToC.Infrastructure.OSFFI (endOfLine)

usageAndExample :: YargsSetup
usageAndExample =
       usage "Produces a Table of Contents file in Markdown whose links \
             \refer to a GitHub repo's corresponding file."
    <> example
         "node 22-Projects/dist/table-of-contents/ghtoc.js \
            \-r \".\" -o \"./table-of-contents.md\""
         "Produces a Table of Contents file in the shell's current working \
         \directory."
    <> example
         "node 22-Projects/dist/table-of-contents/ghtoc.js \
            \-r \".\" -o \"./table-of-contents.md\" --log-level info"
         "Runs the program with the log level set to 'info'"
    <> example
         "node ghtoc.js -r \"/home/user/purescript-jordans-reference/\" \
         \-o \"/home/user/purescript-jordans-reference/table-of-contents.md\""
         "Produces a Table of Contents file using absolute paths."
    <> example
         "node 22-Projects/dist/table-of-contents/ghtoc.js \
            \-r \".\" -o \"./table-of-contents.md\" \
            \-ref \"development\""
         "Produces a Table of Contents file whose hyperlinks use the \
         \'development' branch name instead of `latestRelease`."

runProgramViaCLI :: (Env -> Effect Unit) -> Effect Unit
runProgramViaCLI runOnceEnvConfigured = do
  runY usageAndExample $ (setupEnv runOnceEnvConfigured)
        <$> yarg "r" ["root-dir"]
              (Just "The local computer's file path to the root directory that \
                    \contains this repository.")
              (Right "You need to provide the path to the root directory.") true
        <*> yarg "o" ["output-file"]
              (Just "The path of the file to which to write the \
                    \program's Table of Contents output")
              (Right "You must specify a path for the output of the program") true
        <*> yarg "t" ["exclude-top-level-dirs"]
              (Just "An array of top-level directories (case-sensitive) to exclude. \
                    \By default, this is '.git', '.github', '.travis' and 'output'")
              (Left [ ".git", ".github", ".procedures", ".travis", "output"]) true
        <*> yarg "d" ["exclude-regular-dirs"]
              (Just "An array of directories (case-sensitive) to exclude \
                    \when recursively examining the directories and files of \
                    \the top-level directories.")
              (Left
                -- PS-related directories
                [ ".psc-package", ".pulp-cache", ".psci_modules", "node_modules", "output", "tmp", "dist"
                -- project-specific files
                , "benchmark-results"
                -- repo-specific files
                , "images", "modules-used-in-examples", "resources"
                ]) true
        <*> yarg "f" ["include-files-with-extensions"]
              (Just "An array of file extensions that indicate which files \
                    \should be included in the Table of Contents. By default, \
                    \this is '.purs', '.md', and '.js'")
              (Left [ ".purs", ".md", ".js"]) true
        <*> yarg "u" ["github-username"]
              (Just "The username part of the GitHub repo's URL. By default, \
                    \this is 'JordanMartinez'")
              (Left "JordanMartinez") true
        <*> yarg "p" ["github-project"]
              (Just "The project name part of the GitHub repository's URL. \
                    \By default, this is 'purescript-jordans-reference'")
              (Left "purescript-jordans-reference") true
        <*> yarg "ref" ["github-reference"]
              (Just "The name of the project's branch or tag to use when \
                    \producing the hyperlinks to files and their headers. \
                    \By default, this is 'development'")
              (Left "development") true
        <*> yarg "log-level" []
              (Just "The amount of information to log to the screen. \
                    \Valid options are 'error', 'info', and 'debug'. \
                    \Default is 'error'.")
              (Left "error") true

setupEnv :: (Env -> Effect Unit) ->
            FilePath -> FilePath ->
            Array String -> Array String -> Array String ->
            String -> String -> String ->
            String ->
            Effect Unit
setupEnv runProgramWithEnvironmentConfig
             rootDirectory outputFile
             excludedTopLevelDirs excludedRegularDir includedFileExtensions
             ghUsername ghProjectName ghBranchName
             logLevel
             = do
  runProgramWithEnvironmentConfig
    { rootUri: { fs: rootDir
               , url: rootURL
               }
    , addPath: addPath' sep
    , matchesTopLevelDir: \path -> notElem path excludedTopLevelDirs
    , includeRegularDir: \path -> notElem path excludedRegularDir
    , includeFile: \path -> elem (extname path) includedFileExtensions
    , outputFile: outputFile
    , sortPaths: sortPaths
    , parseFile: parseFile
    , renderToC: renderToC
    , renderTopLevel: renderTopLevel
    , renderDir: renderDir
    , renderFile: renderFile
    , logLevel: level
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
