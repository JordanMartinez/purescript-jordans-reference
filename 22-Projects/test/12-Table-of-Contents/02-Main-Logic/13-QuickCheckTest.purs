module Test.ToC.QuickCheckTest where

import Prelude

import Data.Foldable (for_)
import Data.Maybe (fromMaybe)
import Data.Tree (Tree, showTree)
import Data.Tree.Zipper (findFromRootWhere, fromTree, value)
import Effect (Effect)
import Effect.Console (log)
import Test.QuickCheck (Result, quickCheck, (<?>))
import Test.QuickCheck.Gen (randomSample')
import Test.ToC.MainLogic.Common (FileSystemInfo(..), TestEnv, separator, getPathName)
import Test.ToC.MainLogic.Generators (genFileSystem)
import Test.ToC.MainLogic.ReaderT (runTestM)
import Test.ToC.MainLogic.ToCTestData (ToCTestData(..))
import ToC.Core.Paths (addPath')
import ToC.ReaderT.Domain (program)


main :: Effect Unit
main = do

  -- showSample 4

  -- quickCheck' 1000 testReaderT -- swap this line with next
  quickCheck testReaderT

showSample :: Int -> Effect Unit
showSample sampleNumber = do
  array <- randomSample' 5 genFileSystem
  for_ array \sample -> do
    log $ showTree sample
    log "============"

testReaderT :: ToCTestData -> Result
testReaderT (ToCTestData generatedData) =
  let
    -- run the program using our TestM monad
    outputFileContents = runTestM (testEnv generatedData.fileSystem) program

  in
    -- check whether the contents of the two lists are the same
    -- (same size, same items, same order).
    outputFileContents == generatedData.expectedOutput <?>
      "Expected list: " <> generatedData.expectedOutput <> "\n" <>
      "===============\n" <>
      "Actual list: " <> outputFileContents

testEnv :: Tree FileSystemInfo -> TestEnv
testEnv fileSystem =
        { rootUri: {fs: ".", url: "."}
        , addPath: addPath' separator
        , sortPaths: \_ _ -> LT -- don't sort anything
        , includePath: \_ path -> fromMaybe false $ findPath path
        , shouldVerifyLinks: true
        , fileSystem: fileSystem
        }
  where
    fileSystemLoc = fromTree fileSystem

    findPath path = do
      foundLoc <- findFromRootWhere (\a -> getPathName a == path) fileSystemLoc
      pure $ case value foundLoc of
        FileInfo _ includePath _ _ -> includePath
        DirectoryInfo _ includePath -> includePath
