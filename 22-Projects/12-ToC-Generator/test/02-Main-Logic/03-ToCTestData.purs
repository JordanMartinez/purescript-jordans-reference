module Test.ToC.MainLogic.ToCTestData (ToCTestData(..)) where

import Prelude

import Control.Comonad.Cofree (head, tail)
import Control.Monad.Rec.Class (Step(..), tailRec)
import Data.List (List(..), filter, (:))
import Data.Tree (Tree, Forest, showTree)
import Test.QuickCheck (class Arbitrary)
import Test.ToC.MainLogic.Common (FileSystemInfo(..))
import Test.ToC.MainLogic.Generators (genFileSystem)


newtype ToCTestData = ToCTestData { fileSystem :: Tree FileSystemInfo
                                  , expectedOutput :: String
                                  }

instance showToCTestData :: Show ToCTestData where
  show (ToCTestData rec) = showTree rec.fileSystem

instance arbitraryToCTestData :: Arbitrary ToCTestData where
  arbitrary = do
      fileSystemTree <- genFileSystem
      pure $ ToCTestData
        { fileSystem: fileSystemTree
        , expectedOutput: renderFS fileSystemTree
        }
    where
      renderFS :: Tree FileSystemInfo -> String
      renderFS fsTree =
        let
          rootDirChildren = tail fsTree
          isTopLevelIncludedDir cofree = case head cofree of
            DirectoryInfo _ included | included -> true
            _ -> false
          topLevelIncludedDirs = filter isTopLevelIncludedDir rootDirChildren
        in
          tailRec renderForest { content: "", treeList: topLevelIncludedDirs }

      renderTree :: Tree FileSystemInfo -> String
      renderTree oneTree =
          let
            dirOrFile = head oneTree
            children = tail oneTree
          in
            case dirOrFile of
              DirectoryInfo path included | included ->
                tailRec renderForest { content: path <> "\n", treeList: children }
              FileInfo path included _ _ | included -> path <> "\n"
              _ -> ""

      renderForest ::      { content :: String, treeList :: Forest FileSystemInfo }
                   -> Step { content :: String, treeList :: Forest FileSystemInfo } String
      renderForest { content: c, treeList: Nil } = Done c
      renderForest { content: c, treeList: thisTree:remainingTrees } =
        Loop { content: c <> renderTree thisTree
             , treeList: remainingTrees
             }
