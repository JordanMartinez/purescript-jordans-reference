module Test.ToC.MainLogic.Generators where

import Prelude

import Control.Comonad.Cofree ((:<))
import Control.Monad.Gen (choose, chooseBool, oneOf)
import Data.Array as Array
import Data.List (List(..), fold, (:))
import Data.List as List
import Data.NonEmpty ((:|))
import Data.String.Gen (genAlphaString)
import Data.Tree (Forest, Tree)
import Test.QuickCheck.Gen (Gen, chooseInt, listOf, shuffle)
import Test.ToC.MainLogic.Common (FileSystemInfo(..))
import ToC.Core.FileTypes (HeaderInfo)

-- generators for Tree

genLeaf :: forall a. Gen a -> Gen (Tree a)
genLeaf leafGenerator = do
  leaf <- leafGenerator
  pure (leaf :< Nil)

genBranch :: forall a. Gen a -> Gen (Forest a) -> Gen (Tree a)
genBranch parentGenerator childrenGenerator = do
  children <- childrenGenerator
  parent <- parentGenerator
  pure (parent :< children)

-- Helper generators

genPathName :: Gen String
genPathName = do
  int <- chooseInt 3 5
  chars <- listOf int genAlphaString
  pure $ fold chars

shuffleList :: forall a. List a -> Gen (List a)
shuffleList list = do
  let arrayVersion = Array.fromFoldable list
  shuffle arrayVersion <#> List.fromFoldable

-- FileSystemInfo generators

genFileInfo :: Gen Boolean -> Gen (List (Tree HeaderInfo)) -> Gen Boolean -> Gen FileSystemInfo
genFileInfo includedOrNotGen headerListGenerator verifiedOrNotGen = do
  path <- genPathName
  includedOrNot <- includedOrNotGen
  headerList <- headerListGenerator
  verifiedOrNot <- verifiedOrNotGen
  pure $ FileInfo path includedOrNot headerList verifiedOrNot

genDirectoryInfo' :: Gen String -> Gen Boolean -> Gen FileSystemInfo
genDirectoryInfo' pathNameGen includedOrNotGen = do
  path <- pathNameGen
  includedOrNot <- includedOrNotGen
  pure (DirectoryInfo path includedOrNot)

genDirectoryInfo :: Gen Boolean -> Gen FileSystemInfo
genDirectoryInfo includedOrNotGen = genDirectoryInfo' genPathName includedOrNotGen

genIncludedFileInfo :: Gen (Tree FileSystemInfo)
genIncludedFileInfo = genLeaf $ genFileInfo (pure true) (pure Nil) (pure true)

genIntermediateDirectoryInfo :: forall a. Int -> Gen a -> Gen (Tree a) -> Gen (Tree a)
genIntermediateDirectoryInfo depth branchGenerator childGenerator = do
  amountOfChildren <- chooseInt 1 3
  let realChildGenerator =
        if depth == 1
          then childGenerator
          else genIntermediateDirectoryInfo (depth - 1) branchGenerator childGenerator
  genBranch branchGenerator (listOf amountOfChildren realChildGenerator)

genIncludedDirectoryInfo :: Gen String -> Int -> Gen (Tree FileSystemInfo)
genIncludedDirectoryInfo pathNameGen 1 = do
    includedChild <- genIncludedFileInfo

    numberOfOtherChildren <- chooseInt 0 3
    otherChildren <- listOf numberOfOtherChildren $
      genLeaf $ genFileInfo chooseBool (pure Nil) (pure true)

    let allChildren = includedChild : otherChildren
    genBranch (genDirectoryInfo' pathNameGen $ pure true) (shuffleList allChildren)
genIncludedDirectoryInfo pathNameGen maxDepth = do
    includedChild <- oneOf $ genIncludedFileInfo
                          :| [ genIncludedDirectoryInfo genPathName (maxDepth - 1) ]

    numberOfOtherChildren <- chooseInt 0 3
    otherChildren <- listOf numberOfOtherChildren $
      choose
        (genLeaf $ genFileInfo chooseBool (pure Nil) (pure true))
        (genIntermediateDirectoryInfo
          (maxDepth - 1)
          (genDirectoryInfo chooseBool)
          (genLeaf $ genFileInfo chooseBool (pure Nil) (pure true))
        )

    let allChildren = includedChild : otherChildren
    genBranch (genDirectoryInfo' pathNameGen $ pure true) (shuffleList allChildren)

-- | Generates a file system where the root directory starts with "."
-- | The TestEnv's rootURI file systme path must also start with "."
genFileSystem :: Gen (Tree FileSystemInfo)
genFileSystem = genIncludedDirectoryInfo (pure ".") 3
