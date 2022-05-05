{-
This file will show how to use QuickCheck Laws to quickly
and easily test whether one's instances for various core
type classes are correct. To see the full list, see its documentation here:
https://pursuit.purescript.org/packages/purescript-quickcheck-laws/4.0.0

The library approach uses type-level programming to check the laws.
-}
module Test.QuickCheckLaws where

import Prelude
import Effect (Effect)
import Data.Array.NonEmpty as NEA
import Data.Maybe (fromJust)
import Test.QuickCheck.Gen (Gen, elements)
import Test.QuickCheck.Arbitrary (class Arbitrary, arbitrary)
import Partial.Unsafe (unsafePartial)

-- new imports
import Test.QuickCheck.Laws (checkLaws, A, B, C)
import Test.QuickCheck.Laws.Control as Control
import Test.QuickCheck.Laws.Data as Data

-- necessary to compile
import Type.Proxy (Proxy(..))

-- Given a type...
-- (e.g. our Box type from before)
data Box a = Box a

-- ... that implements some type classes...
-- (instances appear at the bottom of the file)

-- ... and an Arbitrary for our Box type
instance (Arbitrary a) => Arbitrary (Box a) where
  arbitrary = map pure arbitrary

-- ... and a helper function for checking all of them at once
checkBox :: Effect Unit
checkBox = do
  -- checkLaws "data type" do
  --   type-class 1 check
  --   type-class 2 check
  --   ...

  checkLaws "Box (using Arbitrary instance)" do
    let
      -- When using type classes like `Eq` or `Ord` that
      -- are not higher-kinded types, use `prxBoxA`
      -- `A` is a filler type from the laws package
      prxBoxA = Proxy :: Proxy (Box A)

      -- When using type classes like `Functor` or `Apply` that
      -- are higher-kinded types, use `prxBox`
      prxBox = Proxy ∷ Proxy Box

    -- type classes with concrete types
    Data.checkEq  prxBoxA
    Data.checkOrd prxBoxA

    -- type classes with higher-kinded types
    Data.checkFunctor        prxBox
    Control.checkApply       prxBox
    Control.checkApplicative prxBox
    Control.checkBind        prxBox
    Control.checkMonad       prxBox

  checkLaws "Box (using specific generator)" do
    let
      boxAGenerator :: Gen (Box A)
      boxAGenerator = Box <$> (arbitrary :: Gen A)
      boxAToBGenerator :: Gen (Box (A -> B))
      boxAToBGenerator = Box <$> (arbitrary :: Gen (A -> B))
      boxBToCGenerator :: Gen (Box (B -> C))
      boxBToCGenerator = Box <$> (arbitrary :: Gen (B -> C))
      boxAToBoxAGenerator :: Gen (A -> Box A)
      boxAToBoxAGenerator = map Box <$> (arbitrary :: Gen (A -> A))
    -- type classes with concrete types
    Data.checkEqGen boxAGenerator
    Data.checkOrdGen boxAGenerator

    -- type classes with higher-kinded types
    Data.checkFunctorGen boxAGenerator
    Control.checkApplyGen boxAGenerator boxAToBGenerator boxBToCGenerator
    Control.checkApplicativeGen boxAGenerator boxAToBGenerator boxBToCGenerator
    Control.checkBindGen boxAGenerator boxAToBoxAGenerator
    Control.checkMonadGen boxAGenerator boxAToBoxAGenerator

-- We can test multiple types' instances to insure they adhere to those
-- type classes' laws.
main :: Effect Unit
main = do
  checkBox

  -- Fruit's type, arbitrary, and instances appear after
  -- the "Box's instances" section
  checkFruit

-- Box's instances

instance (Eq a) => Eq (Box a) where
  eq (Box a1) (Box a2) = eq a1 a2

instance (Ord a) => Ord (Box a) where
  compare (Box a1) (Box a2) = compare a1 a2

instance Functor Box where
  map :: forall a b. (a -> b) -> Box a -> Box  b
  map f (Box a) = Box (f a)

instance Apply Box where
  apply :: forall a b. Box (a -> b) -> Box a -> Box  b
  apply (Box f) (Box a) = Box (f a)

instance Bind Box where
  bind :: forall a b. Box a -> (a -> Box b) -> Box b
  bind (Box a) f = f a

instance Applicative Box where
  pure :: forall a. a -> Box a
  pure a =  Box a

instance Monad Box

-- Fruit's type, arbitrary, and instances

data Fruit = Apple | Orange

instance Arbitrary Fruit where
  arbitrary = elements $ unsafePartial fromJust $ NEA.fromArray [Apple, Orange]

derive instance Eq Fruit

instance Ord Fruit where
  compare Apple Orange = LT
  compare Orange Apple = GT
  compare _ _ = EQ

checkFruit :: Effect Unit
checkFruit = do
  checkLaws "Fruit (using Arbitrary instance)" do
    let
      -- since Fruit is not a higher-kinded type,
      -- we don't need the filler `A` type here
      prxFruit = Proxy :: Proxy Fruit

    Data.checkEq  prxFruit
    Data.checkOrd prxFruit

  checkLaws "Fruit (using specific generator)" do
    let fruitGen = elements $ unsafePartial fromJust $ NEA.fromArray [Apple, Orange]
    Data.checkEqGen fruitGen
    Data.checkOrdGen fruitGen
