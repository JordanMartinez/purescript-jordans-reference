module TLP.IntegerExample.VTAs where

import Prelude

import Data.Reflectable (class Reflectable, reflectType)
import Effect (Effect)
import Effect.Console (log)
import Prim.Int as Int
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
  printAddSubtract
  printMul
  printToString

--- Add ---

intAdd
  :: forall @l @r sum
   . Int.Add l r sum
  => Reflect sum Int
  => Int
intAdd = reflectTy @sum

intSubtract
  :: forall @total @value answer
   . Int.Add answer value total
  => Reflect answer Int
  => Int
intSubtract = reflectTy @answer

printAddSubtract :: Effect Unit
printAddSubtract = do
    printHeader "Add/Subtract"
    printInt " 0 + 1: " $ intAdd @0 @1
    printInt "-1 + 1: " $ intAdd @(-1) @1
    printInt " 0 - 1: " $ intSubtract @0 @1

--- Mul ---

intMultiply
  :: forall @l @r total
   . Int.Mul l r total
  => Reflect total Int
  => Int
intMultiply = reflectTy @total

printMul :: Effect Unit
printMul = do
  printHeader "Mul"
  printInt "1 * 1: " $ intMultiply @1 @1
  printInt "2 * 1_000_000: " $ intMultiply @2 @1_000_000
  printInt "3 * 2: " $ intMultiply @3 @2

--- Compare ---

intCompare
  :: forall @l @r ord
   . Int.Compare l r ord
  => Reflect ord Ordering
  => Ordering
intCompare = reflectTy @ord

printCompare :: Effect Unit
printCompare = do
  printHeader "Compare"
  printOrdering "EQ: " $ intCompare @0 @0
  printOrdering "LT: " $ intCompare @0 @1
  printOrdering "GT: " $ intCompare @1 @0

--- ToString ---

toTLString
  :: forall @i sym
   . Int.ToString i sym
  => Reflect sym String
  => String
toTLString = reflectTy @sym

printToString :: Effect Unit
printToString = do
  printHeader "ToString"
  printLine "       -1: " $ toTLString @(-1)
  printLine "        0: " $ toTLString @0
  printLine "        1: " $ toTLString @1
  printLine "1,000,000: " $ toTLString @1_000_000

--- Reflectable ---


type MaxReflectableInt = 2147483647
type MinReflectableInt = (-2147483648)

printReflectable :: Effect Unit
printReflectable = do
  printHeader "Reflectable"
  log $ "neg1: " <> (show $ reflectTy @(-1))
  log $ "0: " <> (show $ reflectTy @0)
  log $ "1: " <> (show $ reflectTy @1)
  log $ "1,000,000: " <> (show $ reflectTy @1_000_000)
  log ""
  log $ "Type-Level Int values outside the JavaScript range for an integers "
      <> " will not be solved by the compiler"
  log $ "(max)  2147483647: " <> (show $ reflectTy @MaxReflectableInt)
  log $ "(min) -2147483648: " <> (show $ reflectTy @MinReflectableInt)

  -- These two examples will fail to compile since both values are outside the range of JavaScript integer.
  -- log $ " 2147483648: " $ intAdd @MaxReflectableInt @1
  -- log $ "-2147483649: " $ intSubtract @MaxReflectableInt @1

  -- See `purescript-bigints` to reflect the integer to a BigInt as a workaround.

-------------

printHeader :: String -> Effect Unit
printHeader s = log $ "=== " <> s <> " ==="

printOrdering :: String -> Ordering -> Effect Unit
printOrdering subhead ord = printLine subhead case ord of
  LT -> "LT"
  GT -> "GT"
  EQ -> "EQ"

printInt :: String -> Int -> Effect Unit
printInt subhead int = printLine subhead $ show int

printLine :: String -> String -> Effect Unit
printLine s computation = log $ s <> computation
