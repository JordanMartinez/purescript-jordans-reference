-- This file uses Visible Type Applications in its examples
module TLP.SymbolExample.VTAs where

import Prelude

import Data.Reflectable (class Reflectable, reflectType)
import Data.Symbol (class IsSymbol, reflectSymbol)
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Console (log)
import Prim.Ordering as O
import Prim.Symbol as Symbol
import Type.Proxy (Proxy(..))

-- Note: `Data.Reflectable` still uses Proxy arguments. 
-- It should be defined as
--   class Reflectable t v | t -> v where
--     reflectType :: v
--
-- This will be fixed in the PureScript 0.16.0 ecosystem update.
-- So for now, we'll define our own type class to show how things would work.

class Reflect :: forall k. k -> Type -> Constraint
class Reflect ty val | ty -> val where
  reflectTy :: val

instance (Reflectable ty val) => Reflect ty val where
  reflectTy = reflectType (Proxy  :: Proxy ty)

main :: Effect Unit
main = do
  printAppend
  printCons
  printCompare

--- Append ---

combine :: forall @l @r both
         . Symbol.Append l r both
        => Reflect both String
        => String
combine = reflectTy @both

prefix :: forall @string @suffix prefix
        . Symbol.Append prefix suffix string
       => Reflect prefix String
       => String
prefix = reflectTy @prefix

suffix :: forall @string @prefix suffix
        . Symbol.Append prefix suffix string
       => Reflect suffix String
       => String
suffix = reflectTy @suffix

printAppend :: Effect Unit
printAppend = do
    printHeader "Append"
    printLine "combine: " $ combine @"apple" @"apple"
    printLine "suffix:  " $ suffix @"apple" @"app"
    printLine "prefix:  " $ prefix @"apple" @"le"

--- Cons ---

symbolHead :: forall @string head tail
            . Symbol.Cons head tail string
           => Reflect head String
           => String
symbolHead = reflectTy @head

symbolTail :: forall @string head tail
            . Symbol.Cons head tail string
           => Reflect tail String
           => String
symbolTail = reflectTy @tail

symbolCons :: forall @head @tail string
            . Symbol.Cons head tail string
           => Reflect string String
           => String
symbolCons = reflectTy @string

printCons :: Effect Unit
printCons = do
  printHeader "Cons"
  printLine "head: " $ symbolHead @"apple"
  printLine "tail: " $ symbolTail @"apple"
  printLine "cons: " $ symbolCons @"a" @"pple"

--- Compare ---

banana :: Proxy "banana"
banana = Proxy

symbolCompare :: forall @left @right ordering
               . Symbol.Compare left right ordering
              => Reflect ordering Ordering
              => Ordering
symbolCompare = reflectTy @ordering

printCompare :: Effect Unit
printCompare = do
  printHeader "Compare"
  printOrdering "EQ: " $ symbolCompare @"apple" @"apple"
  printOrdering "LT: " $ symbolCompare @"apple" @"banana"
  printOrdering "GT: " $ symbolCompare @"banana" @"apple"

--- Reflectable ---

printReflectable :: Effect Unit
printReflectable = do
  printHeader "Reflectable"
  log $ "apple: " <> reflectTy @"apple"
  log $ "banana: " <> reflectTy @"banana"

-------------

printHeader :: String -> Effect Unit
printHeader s = log $ "=== " <> s <> " ==="

printOrdering :: String -> Ordering -> Effect Unit
printOrdering subhead ord = printLine subhead case ord of
  LT -> "LT"
  GT -> "GT"
  EQ -> "EQ"

printLine :: String -> String -> Effect Unit
printLine s computation = log $ s <> computation
