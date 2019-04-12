module Test.ToC.ReaderT where

import Prelude

import Control.Monad.Maybe.Trans (runMaybeT)
import Control.Monad.Reader (class MonadAsk, ReaderT(..), ask, asks, lift, runReaderT)
import Control.Monad.State (class MonadState, State, gets, put, runState)
import Data.Array (last)
import Data.List (List(..))
import Data.Map (Map)
import Data.Maybe (Maybe(..), fromJust, fromMaybe)
import Data.String (Pattern(..), split)
import Data.Tree (Tree)
import Data.Tree.Zipper (children, findFromRoot, fromTree, value)
import Partial.Unsafe (unsafePartial)
import TOC.Core.RenderTypes (TopLevelContent)
import ToC.Core.FileTypes (HeaderInfo)
import ToC.Core.Paths (FilePath, PathType(..), WebUrl)
import ToC.Domain.Types (Env)
import ToC.ReaderT.Domain (class FileParser, class Logger, class ReadPath, class Renderer, class VerifyLink, class WriteToFile, program)
import Type.Equality (class TypeEquals, from)

type IncludedOrNot = Boolean
type VerifiedOrNot = Boolean

data FileSystemInfo
  = DirectoryInfo FilePath IncludedOrNot
  | FileInfo FilePath IncludedOrNot (List (Tree HeaderInfo)) VerifiedOrNot

type TestRows = ( fileSystem :: Tree FileSystemInfo
                )
type TestEnv = Env TestRows

type TestState = String

newtype TestM a = TestM (ReaderT Env (State TestState) a)

runTestM :: forall state a. state -> TestEnv -> TestM a -> a
runTestM initialState env (TestM program) =
  runState initialState (runReaderT program env)

programAsTest :: forall m.
                 Monad m =>
                 -- capabilities that `program` requires,
                 -- which are implemented via the ReaderT part
                 MonadAsk TestEnv m =>
                 Logger m =>
                 ReadPath m =>
                 VerifyLink m =>

                 -- Monad state that simulates impure code
                 WriteToFile m =>
                 MonadState TestState m =>

                 -- Since the `m` here is a pure monad
                 -- (i.e. either `Identity` or `Trampoline`),
                 -- this is the same as returning 'Boolean',
                 -- which indicates whether this test passed or not
                 m String
programAsTest = do
  -- run the program, which will "write" its output into the state monad
  program
  -- get the final output
  gets (\state -> state.content)

instance monadAskTestM :: TypeEquals e Env => MonadAsk e TestM where
  ask = TestM $ lift $ asks from

derive newtype instance functorTestM :: Functor TestM
derive newtype instance applyTestM :: Apply TestM
derive newtype instance applicativeTestM :: Applicative TestM
derive newtype instance bindTestM :: Bind TestM
derive newtype instance monadTestM :: Monad TestM
derive newtype instance monadStateTestM :: MonadState state TestM

-- helper functions
separator :: String
separator = "/"

-- implement type classes

instance logToConsoleTestM :: Logger TestM where
  log _ _ = pure unit

instance readPathTestM :: ReadPath TestM where
  readDir :: FilePath -> TestM (Array FilePath)
  readDir path = do
    fileSystemLoc <- asks \e -> fromTree e.fileSystem
    maybeArrayPaths <- runMaybeT do
      let pathSegments = split (Pattern separator) path
      lastPath <- last pathSegments
      foundLoc <- findFromRoot path fileSystemLoc
      case value foundLoc of
        DirectoryInfo _ _ -> pure $ (children foundLoc) <#> (\childLoc ->
            case value childLoc of
              DirectoryInfo path _ -> path
              FileInfo path _ _ _ -> path
          )
        _ -> Nothing

    -- catch possible bugs in our randomly-generated data
    pure $ unsafePartial $ fromJust maybeArrayPaths

  readFile :: FilePath -> TestM String
  readFile path = pure ""

  readPathType :: FilePath -> TestM (Maybe PathType)
  readPathType path = do
    fileSystemLoc <- asks \e -> fromTree e.fileSystem
    runMaybeT do
      let pathSegments = split (Pattern separator) path
      lastPath <- last pathSegments
      foundLoc <- findFromRoot lastPath fileSystemLoc
      pure $ case value foundLoc of
        DirectoryInfo _ _ -> Dir
        FileInfo _ _ _ _ -> File

instance parseFileTestM :: FileParser TestM where
  parseFile :: FilePath -> String -> TestM (List (Tree HeaderInfo))
  parseFile path content = pure Nil

instance rendererTestM :: Renderer TestM where
  renderFile :: Int -> Maybe WebUrl -> FilePath -> List (Tree HeaderInfo) -> TestM String
  renderFile _ _ path _ = pure $ path <> "\n"

  renderDir :: Int -> FilePath -> Array String -> TestM String
  renderDir _ path childrenContent = pure $ path <> "\n" <> childrenContent

  renderTopLevel :: FilePath -> Array String -> TestM TopLevelContent
  renderTopLevel path childrenContent =
    pure $ { tocHeader: ""
           , section: path <> "\n" <> childrenContent
           }

  renderToC :: Array TopLevelContent -> TestM String
  renderToC allContent = pure allContent.allSections

instance writeToFileTestM :: WriteToFile TestM where
  writeToFile :: String -> TestM Unit
  writeToFile content = do
    put content

instance verifyLinksTestM :: VerifyLink TestM where
  verifyLink :: WebUrl -> TestM Boolean
  verifyLink url = do
    fileSystemLoc <- asks \e -> fromTree e.fileSystem
    maybeVerified <- runMaybeT do
      let pathSegments = split (Pattern "/") url
      lastPath <- last pathSegments
      foundLoc <- findFromRoot lastPath fileSystemLoc
      case foundLoc of
        FileInfo _ _ _ verified -> Just verified
        _ -> Nothing

    -- catch possible bugs in our randomly-generated data
    pure $ unsafePartial $ fromJust maybeVerified
