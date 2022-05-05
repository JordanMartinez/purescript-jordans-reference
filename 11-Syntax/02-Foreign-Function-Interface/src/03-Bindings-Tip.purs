module Syntax.FFI.BindingsTip where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn2, runEffectFn2)

foreign import otherBindings :: forall a. a -> Int
