module Syntax.TypeLevel.RowSyntax where

-- "row kinds" look like "# k" where 'k' is another kind.
-- Usually, it's used with the kind, `Type`, to make Records (e.g. "# Type")
-- You cannot find that muchd documentation on "row kinds" because
-- they are built into the compiler.

type Example_of_an_Empty_Row = ()
type Example_of_a_Single_Row_of_Types = (fieldName :: ValueType)
type Example_of_a_Multiple_Row_of_Types = (first :: ValueType, second :: ValueType)

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

-- Since row kinds can be used with other kinds, one could also define
-- a row of Symbols:
type Example_of_a_Single_Row_of_Symbols = (a :: "a symbol")
type Example_of_a_Multiple_Row_of_Symbols = (a :: "a symbol", b :: "another symbol")

-- These can also be used with the quoted-key syntax (explained previously in the
-- Records folder):
type Quoted_Key_Row_of_Symbols = ("the key" :: "the symbol")

-- And here is an example proxy type for a row of symbols
data RowOfSymbolsProxy (a :: # Symbol) = RoSProxy

row_of_symbols_proxy :: RowOfSymbolsProxy ( firstField :: "this is a symbol"
                                          , secondField :: "this is another symbol"
                                          )
row_of_symbols_proxy = RoSProxy

{-
Just like Symbol, Row's other type-level programming constructs
are defined in the purescript-prelude and Prim packages
-}

-- needed to compile
type ValueType = String
