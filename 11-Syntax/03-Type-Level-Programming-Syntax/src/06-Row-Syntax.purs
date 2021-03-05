module Syntax.TypeLevel.RowSyntax where

-- "row kinds" look like "Row k" where 'k' is another kind.
-- Usually, it's used with the kind, `Type`, to make Records (e.g. "Row Type")
-- You cannot find that much documentation on `Row` kinds because
-- they are built into the compiler.

type Example_of_an_Empty_Row :: forall k. Row k
type Example_of_an_Empty_Row = ()

type Example_of_a_Single_Row_of_Types = (fieldName :: ValueType)
type Example_of_a_Multiple_Row_of_Types = (first :: ValueType, second :: ValueType)

data Proxy :: forall k. k -> Type
data Proxy kind = Proxy

one_Key_Value_Pair :: Proxy (key :: Int)
one_Key_Value_Pair = Proxy

two_Key_Value_Pairs :: Proxy (key1 :: Int, key2 :: Int)
two_Key_Value_Pairs = Proxy

many_Key_Value_Pair :: Proxy ( key1 :: Int
                              , key2 :: String
                           -- , ...
                              , keyN :: (Int -> String)
                              )
many_Key_Value_Pair = Proxy

nested_Key_Value_Pair :: Proxy (outerKey :: Proxy (innerKey :: Int))
nested_Key_Value_Pair = Proxy

-- Since row kinds can be used with other kinds, one could also define
-- a row of Symbols:
type Example_of_a_Single_Row_of_Symbols = (a :: "a symbol")
type Example_of_a_Multiple_Row_of_Symbols = (a :: "a symbol", b :: "another symbol")

-- These can also be used with the quoted-key syntax (explained previously in the
-- Records folder):
type Quoted_Key_Row_of_Symbols = ("the key" :: "the symbol")

row_of_symbols_proxy :: Proxy ( firstField :: "this is a symbol"
                              , secondField :: "this is another symbol"
                              )
row_of_symbols_proxy = Proxy

{-
Just like Symbol, Row's other type-level programming constructs
are defined in the built-in `Prim` package and the `purescript-prelude` library.
-}

-- needed to compile
type ValueType = String
