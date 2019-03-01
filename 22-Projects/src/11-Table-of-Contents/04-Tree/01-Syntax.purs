module Learn.Tree.Syntax where

import Prelude

import Control.Comonad.Cofree (Cofree, head, mkCofree, tail, (:<))
import Control.Monad.Rec.Class (Step(..), tailRec)
import Data.List.Types (List(..), (:))
import Data.Maybe (Maybe, maybe)
import Data.Monoid (power)
import Data.Tree (Tree)
import Data.Tree.Zipper (fromTree, toTree, modifyValue, down, next, root)
import Effect (Effect)
import Effect.Console (log)

-- Serves only to make this file runnable
main :: Effect Unit
main = do
  log "rootOnly_alias"
  log $ drawTree' rootOnly_alias
  log "----"
  log "rootWithLeaves"
  log $ drawTree' rootWithLeaves
  log "----"
  log "rootWithBranchesAndLeaves"
  log $ drawTree' rootWithBranchesAndLeaves
  log "----"
  log "exampleZipper"
  log $ maybe "" identity exampleZipper


-- These examples show how to create a Tree
rootOnly_mkCoFree :: Tree String
rootOnly_mkCoFree = mkCofree "root" Nil

rootOnly_alias :: Tree String
rootOnly_alias = "root" :< Nil -- `:<` is the alias for `mkCofree`

rootWithLeaves :: Tree String
rootWithLeaves =
  "root" :<
    ( ( "leaf" :< Nil )
    : ( "leaf" :< Nil )
    : ( "leaf" :< Nil )
    : Nil
    )

rootWithBranchesAndLeaves :: Tree String
rootWithBranchesAndLeaves =
  "1" :<
    ( ( "1.1" :<
          ( ( "1.1.1" :< Nil )
          : ( "1.1.2" :< Nil )
          : Nil
          )
      )
    : ( "1.2" :< Nil )
    : ( "1.3" :<
          ( ( "1.3.1" :< Nil )
          : ( "1.3.2" :< Nil )
          : Nil
          )
      )
    : Nil
    )

-- In our code, we will need to iterate through a Tree and do something
-- with each of its contents. Such a function has already been done
-- via `drawTree`, which iterates through a tree's contents
-- and converts it into a String, indenting them according to their respective
-- level:
-- https://github.com/dmbfm/purescript-tree/blob/v1.3.2/src/Data/Tree.purs#L21-L21

-- The below example is a reproduction of the above code but differs from
-- it in that the names are more clearly defined to make it easier to see
-- the pattern one will follow.

drawTree' :: Tree String -> String
drawTree' tree =
  let
    root = head tree
    children = tail tree
  in
    tailRec go {level: 1, result: root <> "\n", current: children }
  where
    go ::      { level :: Int, result :: String, current :: List (Cofree List String) }
       -> Step { level :: Int, result :: String, current :: List (Cofree List String) }  String
    go     {level: l, result: s, current: Nil } = Done s
    go rec@{level: l, result: s, current: (Cons thisTree remainingTrees) } =
      let
        levelRoot = head thisTree
        levelChildren = tail thisTree
        content = (power " " l) <> levelRoot <> "\n"
      in Loop
          rec { current = remainingTrees
              , result = rec.result <> content <>
                    (tailRec go { level: l + 1, result: "", current: levelChildren })
              }


-- Since we'll also be using the Zipper for the Tree (the `Loc` type),
-- we need to know how that works. For a clearer idea of what a 'Zipper' is,
-- see 'Design Patterns/Zipper.md':
exampleZipper :: Maybe String
exampleZipper = do
  let node1 = fromTree rootWithBranchesAndLeaves
  node1_1 <- down node1
  node1_1_1 <- down node1_1
  node1_1_2 <- next node1_1_1
  let node1_1_2a = modifyValue (\s -> s <> " a") node1_1_2
  let rootWithModification = root node1_1_2a
  pure $ drawTree' $ toTree rootWithModification
