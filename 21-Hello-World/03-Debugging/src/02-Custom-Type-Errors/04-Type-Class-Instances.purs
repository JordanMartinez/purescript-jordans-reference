module Debugging.CustomTypeErrors.TypeClassInstances where

import Effect (Effect)
import Effect.Console (log)
import Data.Show (show)
import Data.Unit (Unit)
import Data.Function (($))

import Prim.TypeError (Text, Above, class Warn, class Fail)

infixr 1 type Above as |>

class ExampleClass a where
  emitMessage :: a -> String

instance ExampleClass Int where
  emitMessage _ = "an integer I'm sure..."

data WarnType = WarnType
data FailType = FailType

instance Warn
  (  Text "No worries! This warning is supposed to happen!"
  |> Text ""
  |> Text "[Some warning message here...]"
  ) => ExampleClass WarnType where
  emitMessage _ = "The message!"

instance Fail
  (  Text "Using this instance will cause code to fail"
  ) => ExampleClass FailType where
  emitMessage _ = "This will never occur"

useInstanceOfExampleClass :: forall a. ExampleClass a => a -> String
useInstanceOfExampleClass a = emitMessage a

main :: Effect Unit
main = do
  log $ show regularInstance

regularInstance :: String
regularInstance = useInstanceOfExampleClass 0

-- Even though this is never used in main,
-- it still emits a warning.
warnInstance :: String
warnInstance = useInstanceOfExampleClass WarnType

-- Even though this is never used in main,
-- it still emits a compiler error
-- failInstance :: String
-- failInstance = useInstanceOfExampleClass FailType
