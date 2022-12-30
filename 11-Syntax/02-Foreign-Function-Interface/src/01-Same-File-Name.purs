module Syntax.FFI.Simple where

import Prelude

import Data.Function.Uncurried (Fn3)
import Effect (Effect)
import Effect.Uncurried (EffectFn2, runEffectFn2)

foreign import data DataType :: Type

foreign import data HigherKindedType :: Type -> Type

foreign import basicValue :: Number

foreign import basicEffect :: Effect Number

foreign import basicCurriedFunction :: Number -> Number

foreign import threeArgCurriedFunction :: Number -> Number -> Number -> Number

foreign import curriedFunctionProducingEffect :: String -> Effect String

foreign import threeArgUncurriedFunction :: Fn3 Int Int Int Int

foreign import twoArgUncurriedEffectfulFunction :: EffectFn2 Number Number Number

foreign import twoArgCurriedFunctionImpl :: EffectFn2 String String Unit

twoArgFunction :: String -> String -> Effect Unit
twoArgFunction = runEffectFn2 twoArgCurriedFunctionImpl
