module Test.ToC.MainLogic.QuickCheckTest where

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
import Test.ToC.MainLogic.Run (runDomain)
import Test.ToC.MainLogic.ToCTestData (ToCTestData(..))
import ToC.Core.Paths (addPath')
import ToC.ReaderT.Domain as ReaderT
import ToC.Run.Domain as Run


main :: Effect Unit
main = do

  -- in case one wants to see what the randomly-generated file system looks like
  -- showSample 4

  log "ReaderT quickcheck test"
  -- quickCheck' 1000 $ testApproach (\env -> runTestM env ReaderT.program)
  quickCheck $ testApproach (\env -> runTestM env ReaderT.program)

  log ""
  log "Run quickcheck test"
  -- quickCheck' 1000 $ testApproach (\env -> runDomain env Run.program)
  quickCheck $ testApproach (\env -> runDomain env Run.program)

showSample :: Int -> Effect Unit
showSample sampleNumber = do
  array <- randomSample' 5 genFileSystem
  for_ array \sample -> do
    log $ showTree sample
    log "============"

testApproach :: (TestEnv -> String) -> ToCTestData -> Result
testApproach runProgramPurely (ToCTestData generatedData) =
  let
    -- run the program using our TestM monad (ReaderT)
    -- or using a different set of interpreters/algebras (Run)
    outputFileContents = runProgramPurely (testEnv generatedData.fileSystem)

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
