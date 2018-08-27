module Syntax.TypeLevel.RowSyntax where

-- a Row has kind "# Type"

-- Its proxy object is defined in the purescript-prelude package
data RProxy (a :: # Type) = RProxy

one_Key_Value_Pair :: RProxy (key :: Int)
one_Key_Value_Pair = RProxy

two_Key_Value_Pairs :: RProxy (key1 :: Int, key2 :: Int)
two_Key_Value_Pairs = RProxy

many_Key_Value_Pair :: RProxy ( key1 :: Int
                              , key2 :: String
                           -- , ...
                              , keyN :: (Int -> String)
                              )
many_Key_Value_Pair = RProxy

nested_Key_Value_Pair :: RProxy (outerKey :: RProxy (innerKey :: Int))
nested_Key_Value_Pair = RProxy

{-
Just like Symbol, Row's other type-level programming constructs
are defined in the purescript-prelude and Prim packages
-}
