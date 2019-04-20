module Test.ToC.MainLogic.ReaderT (TestState, TestM(..), runTestM) where

import Prelude

import Control.Comonad.Cofree (head)
import Control.Monad.Reader (class MonadAsk, ReaderT, asks, runReaderT)
import Control.Monad.State (class MonadState, StateT, put, runStateT)
import Control.Monad.Trampoline (Trampoline, runTrampoline)
import Data.Array (fold, foldl, last)
import Data.List (List(..))
import Data.Maybe (Maybe(..))
import Data.String (Pattern(..), split)
import Data.Tree (Tree)
import Data.Tree.Zipper (Loc, children, findFromRootWhere, fromTree, value)
import Data.Tuple (Tuple(..))
import Partial.Unsafe (unsafeCrashWith)
import Test.ToC.MainLogic.Common (FileSystemInfo(..), TestEnv, separator, getPathName)
import ToC.Core.FileTypes (HeaderInfo)
import ToC.Core.Paths (FilePath, PathType(..), WebUrl)
import ToC.Core.RenderTypes (TopLevelContent)
import ToC.ReaderT.Domain (class FileParser, class Logger, class ReadPath, class Renderer, class VerifyLink, class WriteToFile)
import Type.Equality (class TypeEquals, from)

type TestState = String

newtype TestM a = TestM (ReaderT TestEnv (StateT String Trampoline) a)

runTestM :: forall a. TestEnv -> TestM a -> String
runTestM env (TestM program) =
  let (Tuple unit_ content) = runTrampoline $ runStateT (runReaderT program env) ""
  in content

instance monadAskTestM :: TypeEquals e TestEnv => MonadAsk e TestM where
  ask = TestM $ asks from

derive newtype instance functorTestM :: Functor TestM
derive newtype instance applyTestM :: Apply TestM
derive newtype instance applicativeTestM :: Applicative TestM
derive newtype instance bindTestM :: Bind TestM
derive newtype instance monadTestM :: Monad TestM
derive newtype instance monadStateTestM :: MonadState String TestM

-- implement type classes

instance logToConsoleTestM :: Logger TestM where
  log _ _ = pure unit

instance readPathTestM :: ReadPath TestM where
  readDir :: FilePath -> TestM (Array FilePath)
  readDir path = do
      fileSystemLoc <- asks \e -> fromTree e.fileSystem
      let maybeArrayPaths = getChildren fileSystemLoc

      -- catch possible bugs in our randomly-generated data
      pure $ case maybeArrayPaths of
        Just array -> array
        Nothing ->
          unsafeCrashWith "readDir failed. There is a problem with our generator."

    where
      getChildren :: Loc FileSystemInfo -> Maybe (Array FilePath)
      getChildren fileSystemLoc = do
        -- let _ = spy "path" path
        let pathSegments = split (Pattern separator) path
        -- let _ = spy "pathSegments" pathSegments
        lastPath <- last pathSegments
        -- let _ = spy "lastPath" lastPath
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
      pure $ case maybeVerified of
        Just v -> v
        Nothing ->
          unsafeCrashWith "verifyLink failed. There is a problem with our generator"
    where
      getFileLink :: Loc FileSystemInfo -> Maybe Boolean
      getFileLink fileSystemLoc = do
        let pathSegments = split (Pattern "/") url
        lastPath <- last pathSegments
        foundLoc <- findFromRootWhere (\a -> getPathName a == lastPath) fileSystemLoc
        case value foundLoc of
          FileInfo _ _ _ verified -> Just verified
          _ -> Nothing
