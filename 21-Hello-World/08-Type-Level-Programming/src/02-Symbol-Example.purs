module TLP.SymbolExample where

import Prelude
import Data.Tuple(Tuple(..))
import Data.Symbol (SProxy(..), class IsSymbol, reflectSymbol)
import Effect (Effect)
import Effect.Console (log)
import Prim.Symbol as Symbol
import Type.Data.Ordering (OProxy(..), class IsOrdering, reflectOrdering)

main :: Effect Unit
main = do
  printAppend
  printCons
  printCompare

--- Append ---

apple :: SProxy "apple"
apple = SProxy

app :: SProxy "app"
app = SProxy

le :: SProxy "le"
le = SProxy

combine :: forall l r both
         . Symbol.Append l r both
        => SProxy l -> SProxy r -> SProxy both
combine _ _ = SProxy

prefix :: forall prefix suffix string
        . Symbol.Append prefix suffix string
       => SProxy string -> SProxy suffix -> SProxy prefix
prefix _ _ = SProxy

suffix :: forall prefix suffix string
        . Symbol.Append prefix suffix string
       => SProxy string -> SProxy prefix -> SProxy suffix
suffix _ _ = SProxy

printAppend :: Effect Unit
printAppend = do
    printHeader "Append"
    printSymbol "combine: " $ combine apple apple
    printSymbol "suffix:  " $ suffix apple app
    printSymbol "prefix:  " $ prefix apple le

--- Cons ---

symbolHead :: forall head tail string
            . Symbol.Cons head tail string
           => SProxy string -> SProxy head
symbolHead _ = SProxy

symbolTail :: forall head tail string
            . Symbol.Cons head tail string
           => SProxy string -> SProxy tail
symbolTail _ = SProxy

symbolHeadTail :: forall head tail string
                . Symbol.Cons head tail string
               => SProxy string -> Tuple (SProxy head) (SProxy tail)
symbolHeadTail _ = Tuple SProxy SProxy

appleHead :: SProxy "a"
appleHead = SProxy

appleTail :: SProxy "pple"
appleTail = SProxy

showHeadTail :: forall head tail
              . IsSymbol head
             => IsSymbol tail
             => Tuple (SProxy head) (SProxy tail) -> String
showHeadTail (Tuple h t) =
  "(" <> reflectSymbol h <> ", " <> reflectSymbol t <> ")"

symbolCons :: forall head tail string
            . Symbol.Cons head tail string
           => SProxy head -> SProxy tail -> SProxy string
symbolCons _ _ = SProxy

printCons :: Effect Unit
printCons = do
  printHeader "Cons"
  printSymbol "head: " $ symbolHead apple
  printSymbol "tail: " $ symbolTail apple
  printSymbol "cons: " $ symbolCons appleHead appleTail
  log $ "head tail: " <> (showHeadTail $ symbolHeadTail apple)

--- Compare ---

banana :: SProxy "banana"
banana = SProxy

symbolCompare :: forall left right ordering
               . Symbol.Compare left right ordering
              => SProxy left -> SProxy right -> OProxy ordering
symbolCompare _ _ = OProxy

printCompare :: Effect Unit
printCompare = do
  printHeader "Compare"
  printOrdering "EQ: " $ symbolCompare apple apple
  printOrdering "LT: " $ symbolCompare apple banana
  printOrdering "GT: " $ symbolCompare banana apple

-------------

printHeader :: String -> Effect Unit
printHeader s = log $ "=== " <> s <> " ==="

printOrdering :: forall a. IsOrdering a => String -> OProxy a -> Effect Unit
printOrdering subhead ord = printLine subhead $ show $ reflectOrdering ord

printSymbol :: forall a. IsSymbol a => String -> SProxy a -> Effect Unit
printSymbol subhead sym = printLine subhead $ reflectSymbol sym

printLine :: String -> String -> Effect Unit
printLine s computation = log $ s <> computation
