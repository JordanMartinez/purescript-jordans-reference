-- This file uses Proxy arguments in its examples
module TLP.SymbolExample.Proxy where

import Prelude
import Data.Tuple(Tuple(..))
import Data.Symbol (class IsSymbol, reflectSymbol)
import Data.Reflectable (class Reflectable, reflectType)
import Effect (Effect)
import Effect.Console (log)
import Prim.Symbol as Symbol
import Type.Proxy (Proxy(..))

-- Note: the `Data.Symbol` imports will likely be removed
-- and replaced with `Data.Reflectable` imports in PureScript `0.16.0`.

main :: Effect Unit
main = do
  printAppend
  printCons
  printCompare

--- Append ---

apple :: Proxy "apple"
apple = Proxy

app :: Proxy "app"
app = Proxy

le :: Proxy "le"
le = Proxy

combine :: forall l r both
         . Symbol.Append l r both
        => Proxy l -> Proxy r -> Proxy both
combine _ _ = Proxy

prefix :: forall prefix suffix string
        . Symbol.Append prefix suffix string
       => Proxy string -> Proxy suffix -> Proxy prefix
prefix _ _ = Proxy

suffix :: forall prefix suffix string
        . Symbol.Append prefix suffix string
       => Proxy string -> Proxy prefix -> Proxy suffix
suffix _ _ = Proxy

printAppend :: Effect Unit
printAppend = do
    printHeader "Append"
    printSymbol "combine: " $ combine apple apple
    printSymbol "suffix:  " $ suffix apple app
    printSymbol "prefix:  " $ prefix apple le

--- Cons ---

symbolHead :: forall head tail string
            . Symbol.Cons head tail string
           => Proxy string -> Proxy head
symbolHead _ = Proxy

symbolTail :: forall head tail string
            . Symbol.Cons head tail string
           => Proxy string -> Proxy tail
symbolTail _ = Proxy

symbolHeadTail :: forall head tail string
                . Symbol.Cons head tail string
               => Proxy string -> Tuple (Proxy head) (Proxy tail)
symbolHeadTail _ = Tuple Proxy Proxy

appleHead :: Proxy "a"
appleHead = Proxy

appleTail :: Proxy "pple"
appleTail = Proxy

showHeadTail :: forall head tail
              . IsSymbol head
             => IsSymbol tail
             => Tuple (Proxy head) (Proxy tail) -> String
showHeadTail (Tuple h t) =
  "(" <> reflectSymbol h <> ", " <> reflectSymbol t <> ")"

symbolCons :: forall head tail string
            . Symbol.Cons head tail string
           => Proxy head -> Proxy tail -> Proxy string
symbolCons _ _ = Proxy

printCons :: Effect Unit
printCons = do
  printHeader "Cons"
  printSymbol "head: " $ symbolHead apple
  printSymbol "tail: " $ symbolTail apple
  printSymbol "cons: " $ symbolCons appleHead appleTail
  log $ "head tail: " <> (showHeadTail $ symbolHeadTail apple)

--- Compare ---

banana :: Proxy "banana"
banana = Proxy

symbolCompare :: forall left right ordering
               . Symbol.Compare left right ordering
              => Proxy left -> Proxy right -> Proxy ordering
symbolCompare _ _ = Proxy

printCompare :: Effect Unit
printCompare = do
  printHeader "Compare"
  printOrdering "EQ: " $ symbolCompare apple apple
  printOrdering "LT: " $ symbolCompare apple banana
  printOrdering "GT: " $ symbolCompare banana apple

--- Reflectable ---

-- toValueLevel
--   :: forall sym
--    . Data.Reflectable i String
--   => Proxy sym
--   -> String
-- toValueLevel = reflectType

printReflectable :: Effect Unit
printReflectable = do
  printHeader "Reflectable"
  log $ "apple: " <> reflectType apple
  log $ "banana: " <> reflectType banana

-------------

printHeader :: String -> Effect Unit
printHeader s = log $ "=== " <> s <> " ==="

printOrdering :: forall a. Reflectable a Ordering => String -> Proxy a -> Effect Unit
printOrdering subhead ord = printLine subhead $ show $ reflectType ord

printSymbol :: forall a. Reflectable a String => String -> Proxy a -> Effect Unit
printSymbol subhead sym = printLine subhead $ reflectType sym

printLine :: String -> String -> Effect Unit
printLine s computation = log $ s <> computation
