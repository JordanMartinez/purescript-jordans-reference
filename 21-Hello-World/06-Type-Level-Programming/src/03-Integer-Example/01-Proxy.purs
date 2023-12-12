module TLP.IntegerExample.Proxy where

import Prelude
import Data.Reflectable (class Reflectable, reflectType)
import Effect (Effect)
import Effect.Console (log)
import Prim.Int as Int
import Type.Proxy (Proxy(..))

main :: Effect Unit
main = do
  printAddSubtract
  printMul
  printToString

-- Type-Level Values

_neg1 = Proxy :: Proxy (-1)
_0 = Proxy :: Proxy 0
_1 = Proxy :: Proxy 1
_2 = Proxy :: Proxy 2
_3 = Proxy :: Proxy 3
_1_000_000 = Proxy :: Proxy 1_000_000

--- Add ---

intAdd
  :: forall l r sum
   . Int.Add l r sum
  => Proxy l
  -> Proxy r
  -> Proxy sum
intAdd _ _ = Proxy

intSubtract
  :: forall answer value total
   . Int.Add answer value total
  => Proxy total
  -> Proxy value
  -> Proxy answer
intSubtract _ _ = Proxy

printAddSubtract :: Effect Unit
printAddSubtract = do
    printHeader "Add/Subtract"
    printInt "0 + 1: "       $ intAdd _0 _1
    printInt "-1 + 1:  " $ intAdd _neg1 _1
    printInt "0 - 1: " $ intSubtract _0 _1

--- Mul ---

intMultiply
  :: forall l r sum
   . Int.Mul l r sum
  => Proxy l
  -> Proxy r
  -> Proxy sum
intMultiply _ _ = Proxy

printMul :: Effect Unit
printMul = do
  printHeader "Mul"
  printInt "1 * 1: " $ intMultiply _1 _1
  printInt "2 * 1_000_000: " $ intMultiply _2 _1_000_000
  printInt "3 * 2: " $ intMultiply _3 _2

--- Compare ---

intCompare
  :: forall l r sum
   . Int.Compare l r sum
  => Proxy l
  -> Proxy r
  -> Proxy sum
intCompare _ _ = Proxy

printCompare :: Effect Unit
printCompare = do
  printHeader "Compare"
  printOrdering "EQ: " $ intCompare _0 _0
  printOrdering "LT: " $ intCompare _0 _1
  printOrdering "GT: " $ intCompare _1 _0

--- ToString ---

toTLString
  :: forall i sym
   . Int.ToString i sym
  => Proxy i
  -> Proxy sym
toTLString _ = Proxy

printToString :: Effect Unit
printToString = do
  printHeader "ToString"
  printLine "neg1: " $ reflectType $ toTLString _neg1
  printLine "0: " $ reflectType $ toTLString _0
  printLine "1: " $ reflectType $ toTLString _1
  printLine "1,000,000: " $ reflectType $ toTLString _1_000_000

--- Reflectable ---

-- toValueLevel
--   :: forall i
--    . Data.Reflectable i Int
--   => Proxy i
--   -> Int
-- toValueLevel = reflectType

_maxReflectableInt = Proxy :: Proxy 2147483647
_minReflectableInt = Proxy :: Proxy (-2147483648)

printReflectable :: Effect Unit
printReflectable = do
  printHeader "Reflectable"
  log $ "neg1: " <> (show $ reflectType _neg1)
  log $ "0: " <> (show $ reflectType _0)
  log $ "1: " <> (show $ reflectType _1)
  log $ "1,000,000: " <> (show $ reflectType _1_000_000)
  log ""
  log $ "Type-Level Int values outside the JavaScript range for an integers "
      <> " will not be solved by the compiler"
  log $ "(max)  2147483647: " <> (show $ reflectType _maxReflectableInt)
  log $ "(min) -2147483648: " <> (show $ reflectType _minReflectableInt)

  -- These two examples will fail to compile since both values are outside the range of JavaScript integer.
  -- log $ " 2147483648: " <> show $ reflectType $ intAdd _maxReflectableInt _1
  -- log $ "-2147483649: " <> show $ reflectType $ intSubtract _maxReflectableInt _1

  -- See `purescript-bigints` to reflect the integer to a BigInt as a workaround.

-------------

printHeader :: String -> Effect Unit
printHeader s = log $ "=== " <> s <> " ==="

printOrdering :: forall o. Reflectable o Ordering => String -> Proxy o -> Effect Unit
printOrdering subhead ord = printLine subhead $ show $ reflectType ord

printInt :: forall i. Reflectable i Int => String -> Proxy i -> Effect Unit
printInt subhead int = printLine subhead $ show $ reflectType int

printLine :: String -> String -> Effect Unit
printLine s computation = log $ s <> computation
