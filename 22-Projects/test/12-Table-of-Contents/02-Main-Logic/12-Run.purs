module Test.ToC.MainLogic.Run (runDomain) where

import Prelude

import Control.Comonad.Cofree (head)
import Data.Array (fold, foldl, last)
import Data.List (List(..))
import Data.Maybe (Maybe(..))
import Data.String (Pattern(..), split)
import Data.Tree.Zipper (Loc, children, findFromRootWhere, fromTree, value)
import Data.Tuple (Tuple, fst)
import Partial.Unsafe (unsafeCrashWith)
import Run (Run, case_, extract, interpret, on, send)
import Run.Reader (READER, ask, runReader)
import Run.State (STATE, put, runState)
import Test.ToC.MainLogic.Common (FileSystemInfo(..), TestEnv, separator, getPathName)
import ToC.Core.Paths (FilePath, PathType(..))
import ToC.Run.Domain (FILE_PARSER, FileParserF(..), LOGGER, LoggerF(..), READ_PATH, ReadPathF(..), RENDERER, RendererF(..), VERIFY_LINK, VerifyLinkF(..), WRITE_TO_FILE, WriteToFileF(..), _logger, _fileParser, _readPath, _renderer, _verifyLink, _writeToFile)
import Type.Row (type (+))

runDomain :: TestEnv ->
             Run ( reader :: READER TestEnv
                 , state :: STATE String
                 | READ_PATH
                 + FILE_PARSER
                 + RENDERER
                 + WRITE_TO_FILE
                 + VERIFY_LINK
                 + LOGGER
                 + ()
                 )
                 Unit
             -> String
runDomain testEnv program =
  program
    -- use "interpret" and "send" to reinterpret capabilities into
    -- the reader / state monad
    # interpret (
        send
          # on _readPath readPathAlgebra
          # on _fileParser fileParserAlgebra
          # on _renderer rendererAlgebra
          # on _writeToFile writeToFileAlgebra
          # on _verifyLink verifyLinkAlgebra
      )

    -- use "runX" for MTL effects
    # runReader testEnv
    # runState ""

    -- Since logger isn't interpreted into an effect or capbility,
    -- just interpret it into a pure value
    # interpret (case_ # on _logger loggerAlgebra)

    -- now extract the state output so we can get the file's contents
    # extractStateOuput

  where
    extractStateOuput :: Run () (Tuple String Unit) -> String
    extractStateOuput = fst <<< extract

    readPathAlgebra :: forall r. ReadPathF ~> Run (reader :: READER TestEnv | r)
    readPathAlgebra = case _ of
        ReadDir path reply -> do
          env <- ask
          let fileSystemLoc = fromTree env.fileSystem
          let maybeArrayPaths = getChildren path fileSystemLoc

          -- catch possible bugs in our randomly-generated data
          pure $ reply $ case maybeArrayPaths of
            Just array -> array
            Nothing ->
              unsafeCrashWith "readDir failed. There is a problem with our generator."
        ReadFile path reply -> do
          pure $ reply ""
        ReadPathType path reply -> do
          env <- ask
          let fileSystemLoc = fromTree env.fileSystem
          pure $ reply $ getPathType path fileSystemLoc
      where
        getChildren :: FilePath -> Loc FileSystemInfo -> Maybe (Array FilePath)
        getChildren path fileSystemLoc = do
          let pathSegments = split (Pattern separator) path
          lastPath <- last pathSegments
          foundLoc <- findFromRootWhere (\a -> getPathName a == lastPath) fileSystemLoc
          case value foundLoc of
            DirectoryInfo _ _ -> do
              let pathList = children foundLoc <#> (\cofree -> getPathName $ head cofree)
              let pathArray = foldl (\acc next -> acc <> [next]) [] pathList
              pure pathArray
            _ -> Nothing

        getPathType :: FilePath -> Loc FileSystemInfo -> Maybe PathType
        getPathType path fileSystemLoc = do
          let pathSegments = split (Pattern separator) path
          lastPath <- last pathSegments
          foundLoc <- findFromRootWhere (\a -> getPathName a == lastPath) fileSystemLoc
          pure $ case value foundLoc of
            DirectoryInfo _ _ -> Dir
            FileInfo _ _ _ _ -> File

    fileParserAlgebra :: forall r. FileParserF ~> Run (reader :: READER TestEnv | r)
    fileParserAlgebra (ParseFile path content reply) = do
      pure $ reply Nil

    rendererAlgebra :: forall r. RendererF ~> Run (reader :: READER TestEnv | r)
    rendererAlgebra = case _ of
      RenderFile indent url path headers reply -> do
        pure $ reply $ path <> "\n"
      RenderDir indent path renderedChildren reply -> do
        pure $ reply $ path <> "\n" <> fold renderedChildren
      RenderTopLevel path renderedChildren reply -> do
        pure $ reply $ { tocHeader: ""
                       , section: path <> "\n" <> fold renderedChildren
                       }
      RenderToC allContent reply -> do
        pure $ reply $ foldl (\acc next -> acc <> next.section) "" allContent

    writeToFileAlgebra :: forall r. WriteToFileF ~> Run (state :: STATE String | r)
    writeToFileAlgebra (WriteToFile content next) = do
      put content
      pure next

    verifyLinkAlgebra :: forall r. VerifyLinkF ~> Run (reader :: READER TestEnv | r)
    verifyLinkAlgebra (VerifyLink url reply) = do
        env <- ask
        let fileSystemLoc = fromTree env.fileSystem
        let maybeVerified = getFileLink fileSystemLoc

        -- catch possible bugs in our randomly-generated data
        pure $ reply $ case maybeVerified of
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

    loggerAlgebra :: LoggerF ~> Run ()
    loggerAlgebra (Log _ _ next) = do
      pure next
