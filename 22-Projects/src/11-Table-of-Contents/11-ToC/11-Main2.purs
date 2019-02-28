module Projects.ToC.Main2 where

import Prelude

import Control.Comonad.Cofree (head, tail)
import Control.Monad.Rec.Class (tailRec, Step(..))
import Data.Foldable (foldl, elem, notElem)
import Data.List (List(..), (:))
import Data.Maybe (Maybe(..))
import Data.String (Pattern(..), Replacement(..), replace, replaceAll, split, toLower)
import Data.Tree (Tree)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Node.Path (extname, sep)
import Projects.ToC.API.AppM2 (runAppM2)
import Projects.ToC.Core.FileTypes (HeaderInfo)
import Projects.ToC.Core.Paths (FilePath, WebUrl)
import Projects.ToC.Domain.FixedLogic (addPath', TopLevelContent, Env, program, LogLevel(..))
import Projects.ToC.Domain.Parser (extractMarkdownHeaders, extractPurescriptHeaders)
import Projects.ToC.Domain.Renderer.Markdown (anchorLink, bulletList, emptyLine, h1, h2, hyperLink, indentedBulletList)
import Projects.ToC.Infrastructure.OSFFI (endOfLine)

main :: Effect Unit
main = do
  -- let usageAndExample =
  --          usage "Produces a Table of Contents file in Markdown whose links \
  --                \refer to a GitHub repo's corresponding file."
  --       <> example
  --            "node 22-Projects/dist/table-of-contents/ghtoc.js \
  --               \-r \".\" -o \"./table-of-contents.md\""
  --            "Produces a Table of Contents file in the shell's current working \
  --            \directory."
  --       <> example
  --            "node ghtoc.js -r \"/home/user/purescript-jordans-reference/\" \
  --            \-o \"/home/user/purescript-jordans-reference/table-of-contents.md\""
  --            "Produces a Table of Contents file using absolute paths."
  --       <> example
  --            "node 22-Projects/dist/table-of-contents/ghtoc.js \
  --               \-r \".\" -o \"./table-of-contents.md\" \
  --               \-ref \"development\""
  --            "Produces a Table of Contents file whose hyperlinks use the \
  --            \'development' branch name instead of `latestRelease`."
  --
  -- runY usageAndExample $ setupProgram
  --       <$> yarg "r" ["root-dir"]
  --             (Just "The local computer's file path to the root directory that \
  --                   \contains this repository.")
  --             (Right "You need to provide the path to the root directory.") true
  --       <*> yarg "o" ["output-file"]
  --             (Just "The path of the file to which to write the \
  --                   \program's Table of Contents output")
  --             (Right "You must specify a path for the output of the program") true
  --       <*> yarg "t" ["exclude-top-level-dirs"]
  --             (Just "An array of top-level directories (case-sensitive) to exclude. \
  --                   \By default, this is '.git', '.github', '.travis' and 'output'")
  --             (Left [ ".git", ".github", ".travis", "output"]) true
  --       <*> yarg "d" ["exclude-regular-dirs"]
  --             (Just "An array of directories (case-sensitive) to exclude \
  --                   \when recursively examining the directories and files of \
  --                   \the top-level directories.")
  --             (Left
  --               -- PS-related directories
  --               [ ".psc-package", ".pulp-cache", ".psci_modules", "node_modules", "output", "tmp", "dist"
  --               -- project-specific files
  --               , "benchmark-results"
  --               -- repo-specific files
  --               , "images", "modules-used-in-examples", "resources"
  --               ]) true
  --       <*> yarg "f" ["include-files-with-extensions"]
  --             (Just "An array of file extensions that indicate which files \
  --                   \should be included in the Table of Contents. By default, \
  --                   \this is '.purs', '.md', and '.js'")
  --             (Left [ ".purs", ".md", ".js"]) true
  --       <*> yarg "u" ["github-username"]
  --             (Just "The username part of the GitHub repo's URL. By default, \
  --                   \this is 'JordanMartinez'")
  --             (Left "JordanMartinez") true
  --       <*> yarg "p" ["github-project"]
  --             (Just "The project name part of the GitHub repository's URL. \
  --                   \By default, this is 'purescript-jordans-reference'")
  --             (Left "purescript-jordans-reference") true
  --       <*> yarg "ref" ["github-reference"]
  --             (Just "The name of the project's branch or tag to use when \
  --                   \producing the hyperlinks to files and their headers. \
  --                   \By default, this is 'development'")
  --             (Left "development") true
  --       <*> yarg "log-level" []
  --             (Just "The amount of information to log to the screen. \
  --                   \Valid options are 'error', 'info', and 'debug'. \
  --                   \Default is 'info'.")
  --             (Left "info") true
-- setupProgram :: FilePath -> FilePath ->
--                 Array String -> Array String -> Array String ->
--                 String -> String -> String ->
--                 String ->
--                 Effect Unit
-- setupProgram rootDirectory outputFile
--              excludedTopLevelDirs excludedRegularDir includedFileExtensions
--              ghUsername ghProjectName ghBranchName
--              logLevel
--              = do
  -- let rootDir =
  --       if endsWith sep rootDirectory
  --         then take ((length rootDirectory) - 1) rootDirectory
  --         else rootDirectory
  -- let rootURL = renderGHPath { username: ghUsername
  --                            , repo: ghProjectName
  --                            , ref: ghBranchName
  --                            }
  -- let parseContent extName content =
  --       case extName of
  --         ".purs" -> extractPurescriptHeaders $ split (Pattern endOfLine) content
  --         ".md" -> extractMarkdownHeaders $ split (Pattern endOfLine) content
  --         _ -> Nil
  -- let level =
  --       case logLevel of
  --         "info" -> Info
  --         "debug" -> Debug
  --         _ -> Error
  -- let level = Info

  runProgram
    { rootUri: { fs: "."
               , url: "https://github.com/JordanMartinez/purescript-jordans-reference/blob/development"
               }
    , addPath: addPath' sep
    , matchesTopLevelDir: \path -> notElem path excludedTopLevelDirs
    , includeRegularDir: \path -> notElem path excludedRegularDir
    , includeFile: \path -> elem (extname path) includedFileExtensions
    , outputFile: "./table-of-contents.md"
    , parseFile: parseFile
    , renderToC: \array -> renderToC $ foldTopLevelContentArray array
    , renderTopLevel: renderTopLevel
    , renderDir: renderDir
    , renderFile: renderFile
    , logLevel: Info
    }
  where
    runProgram :: Env -> Effect Unit
    runProgram env = launchAff_ (runAppM2 env program)

    excludedTopLevelDirs :: Array FilePath
    excludedTopLevelDirs = [ ".git", ".github", ".travis", "output"]

    excludedRegularDir :: Array FilePath
    excludedRegularDir =
      [ ".psc-package", ".pulp-cache", ".psci_modules", "node_modules", "output", "tmp", "dist"
      -- project-specific files
      , "benchmark-results"
      -- repo-specific files
      , "images", "modules-used-in-examples", "resources"
      ]

    includedFileExtensions :: Array String
    includedFileExtensions = [".purs", ".md", ".js"]

    foldTopLevelContentArray :: Array TopLevelContent -> TopLevelContent
    foldTopLevelContentArray array = do
      let rec = foldl (\acc next ->
                  if acc.init
                    then { init: false
                         , toc: next.toc
                         , section: next.section
                         }
                    else acc { toc = acc.toc <> next.toc
                             , section = acc.section <> "\n" <> next.section
                             }
                ) { init: true, toc: "", section: "" } array
      { toc: rec.toc, section: rec.section }

    parseFile :: FilePath -> String -> List (Tree HeaderInfo)
    parseFile pathSeg fileContent =
      case extname pathSeg of
        ".purs" -> extractPurescriptHeaders $ split (Pattern endOfLine) fileContent
        ".md" -> extractMarkdownHeaders $ split (Pattern endOfLine) fileContent
        _ -> Nil

    renderToC :: TopLevelContent -> String
    renderToC rec =
          (h1 "Table of Contents") <>
          emptyLine <>
          rec.toc <>
          emptyLine <>
          rec.section

    formatHyphensInName :: String -> String
    formatHyphensInName =
      replace (Pattern "--") (Replacement ": ") >>>
      replaceAll (Pattern "-") (Replacement " ")

    renderTopLevel :: FilePath -> Array String -> TopLevelContent
    renderTopLevel pathSeg renderedPaths =
      let pathWithHyphenFormat = formatHyphensInName pathSeg
      in
        { toc: bulletList (anchorLink pathWithHyphenFormat (toLower pathSeg))
        , section: (h2 pathWithHyphenFormat) <>
                   emptyLine <>
                   (foldl (<>) "" renderedPaths)
        }

    renderDir :: Int -> FilePath -> Array String -> String
    renderDir depth pathSeg renderedPaths =
          indentedBulletList depth (formatHyphensInName pathSeg) <>
          (foldl (<>) "" renderedPaths)

    renderFile :: Int -> Maybe WebUrl -> FilePath -> List (Tree HeaderInfo) -> String
    renderFile depth url pathSeg headers = do
        let formattedName = formatHyphensInName pathSeg
        let startingHeaderDepth = depth + 1
        case url of
          Just link -> do
            let fileLink = hyperLink formattedName link
            indentedBulletList depth fileLink <>
            (renderHeaders (headerWithLink link) startingHeaderDepth)
          Nothing ->
            indentedBulletList depth formattedName <>
            (renderHeaders headerNoLink startingHeaderDepth)

      where
        headerWithLink :: WebUrl -> Int -> HeaderInfo -> String
        headerWithLink fileUrl d' h =
          indentedBulletList d' (hyperLink h.text (fileUrl <> h.anchor))

        headerNoLink :: Int -> HeaderInfo -> String
        headerNoLink d' h =
          indentedBulletList d' h.text

        renderHeaders :: (Int -> HeaderInfo -> String) -> Int -> String
        renderHeaders renderHeader topHeadersDepth =
          tailRec goHeaderList { content: "", current: headers }

          where
            goHeaderList ::      { content :: String, current :: List (Tree HeaderInfo) }
                         -> Step { content :: String, current :: List (Tree HeaderInfo) } String
            goHeaderList { content: c, current: Nil } = Done c
            goHeaderList { content: c, current: nextTree:remainingTrees } =
              Loop { content: c <> renderHeaderTree renderHeader topHeadersDepth nextTree
                   , current: remainingTrees
                   }

        renderHeaderTree :: (Int -> HeaderInfo -> String) ->
                            Int -> Tree HeaderInfo -> String
        renderHeaderTree renderHeader d currentTree = do
            let root = head currentTree
            let children = tail currentTree
            renderHeader d root <>
            tailRec goHeader { level: d, drawn: "", current: children }

          where
            goHeader :: _ -> Step _ String
            goHeader {level: l, drawn: s, current: Nil} = Done s
            goHeader {level: l, drawn: s, current: c:cs } =
                Loop { level: l
                     , drawn: s <>
                              (renderHeader l (head c)) <>
                              (tailRec goHeader {level: l + 1, drawn: "", current: tail c })
                     , current: cs
                     }
