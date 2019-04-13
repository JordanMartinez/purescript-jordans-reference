module Test.ToC.ReaderT (IncludedOrNot, VerifiedOrNot, FileSystemInfo(..), TestRows, TestEnv, TestState, TestM(..), runTestM, programAsTest, separator) where

import Prelude

import Control.Comonad.Cofree (head)
import Control.Monad.Reader (class MonadAsk, ReaderT, asks, runReaderT)
import Control.Monad.State (class MonadState, State, get, put, runState)
import Data.Array (fold, foldl, last)
import Data.List (List(..))
import Data.Maybe (Maybe(..), fromJust)
import Data.String (Pattern(..), split)
import Data.Tree (Tree)
import Data.Tree.Zipper (Loc, children, findFromRootWhere, fromTree, value)
import Data.Tuple (Tuple)
import Partial.Unsafe (unsafePartial)
import ToC.Core.FileTypes (HeaderInfo)
import ToC.Core.Paths (FilePath, PathType(..), WebUrl)
import ToC.Core.RenderTypes (TopLevelContent)
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

newtype TestM a = TestM (ReaderT TestEnv (State TestState) a)

runTestM :: forall a. TestEnv -> TestM a -> Tuple a String
runTestM env (TestM program) =
  runState (runReaderT program env) ""

programAsTest :: forall m.
                 Monad m =>
                 -- capabilities that `program` requires,
                 -- which are implemented via the ReaderT part
                 MonadAsk TestEnv m =>
                 Logger m =>
                 ReadPath m =>
                 FileParser m =>
                 Renderer m =>
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
  get

instance monadAskTestM :: TypeEquals e TestEnv => MonadAsk e TestM where
  ask = TestM $ asks from

derive newtype instance functorTestM :: Functor TestM
derive newtype instance applyTestM :: Apply TestM
derive newtype instance applicativeTestM :: Applicative TestM
derive newtype instance bindTestM :: Bind TestM
derive newtype instance monadTestM :: Monad TestM
derive newtype instance monadStateTestM :: MonadState String TestM

-- helper functions
separator :: String
separator = "/"

getPathName :: FileSystemInfo -> String
getPathName = case _ of
  DirectoryInfo name _ -> name
  FileInfo name _ _ _ -> name

-- implement type classes

instance logToConsoleTestM :: Logger TestM where
  log _ _ = pure unit

instance readPathTestM :: ReadPath TestM where
  readDir :: FilePath -> TestM (Array FilePath)
  readDir path = do
      fileSystemLoc <- asks \e -> fromTree e.fileSystem
      let maybeArrayPaths = getChildren fileSystemLoc

      -- catch possible bugs in our randomly-generated data
      pure $ unsafePartial $ fromJust maybeArrayPaths

    where
      getChildren :: Loc FileSystemInfo -> Maybe (Array FilePath)
      getChildren fileSystemLoc = do
        let pathSegments = split (Pattern separator) path
        lastPath <- last pathSegments
        foundLoc <- findFromRootWhere (\a -> getPathName a == lastPath) fileSystemLoc
        case value foundLoc of
          DirectoryInfo _ _ -> do
            let pathList = children foundLoc <#> (\cofree -> getPathName $ head cofree)
            let pathArray = foldl (\acc next -> acc <> [next]) [] pathList
            pure pathArray
          _ -> Nothing

  readFile :: FilePath -> TestM String
  readFile path = pure ""

  readPathType :: FilePath -> TestM (Maybe PathType)
  readPathType path = do
      fileSystemLoc <- asks \e -> fromTree e.fileSystem
      pure $ getPathType fileSystemLoc

    where
      getPathType :: Loc FileSystemInfo -> Maybe PathType
      getPathType fileSystemLoc = do
        let pathSegments = split (Pattern separator) path
        lastPath <- last pathSegments
        foundLoc <- findFromRootWhere (\a -> getPathName a == lastPath) fileSystemLoc
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
  renderDir _ path childrenContent = pure $ path <> "\n" <> fold childrenContent

  renderTopLevel :: FilePath -> Array String -> TestM TopLevelContent
  renderTopLevel path childrenContent =
    pure { tocHeader: ""
         , section: path <> "\n" <> fold childrenContent
         }

  renderToC :: Array TopLevelContent -> TestM String
  renderToC allContent = pure $ foldl (\acc next -> acc <> next.section) "" allContent

instance writeToFileTestM :: WriteToFile TestM where
  writeToFile :: String -> TestM Unit
  writeToFile content = do
    put content

instance verifyLinksTestM :: VerifyLink TestM where
  verifyLink :: WebUrl -> TestM Boolean
  verifyLink url = do
      fileSystemLoc <- asks \e -> fromTree e.fileSystem
      let maybeVerified = getFileLink fileSystemLoc

      -- catch possible bugs in our randomly-generated data
      pure $ unsafePartial $ fromJust maybeVerified
    where
      getFileLink :: Loc FileSystemInfo -> Maybe Boolean
      getFileLink fileSystemLoc = do
        let pathSegments = split (Pattern "/") url
        lastPath <- last pathSegments
        foundLoc <- findFromRootWhere (\a -> getPathName a == lastPath) fileSystemLoc
        case value foundLoc of
          FileInfo _ _ _ verified -> Just verified
          _ -> Nothing
