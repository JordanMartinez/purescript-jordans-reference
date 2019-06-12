module Test.Spec.Examples.Modulated.Runner where

import Prelude
import Effect (Effect)
import Effect.Aff (launchAff_)
-- import Test.Spec (pending, pending', describe, it)
-- import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
-- import Test.Spec.Reporter.Dot (dotReporter)
-- import Test.Spec.Reporter.Spec (specReporter)
-- import Test.Spec.Reporter.Tap (tapReporter)
import Test.Spec.Runner (runSpec)
import Test.Spec.Examples.Modulated.Spec1 as Spec1
import Test.Spec.Examples.Modulated.Spec2 as Spec2
import Test.Spec.Examples.Modulated.Spec3 as Spec3

main :: Effect Unit
main = launchAff_ $ runSpec [consoleReporter] do
  Spec1.spec
  Spec2.spec
  Spec3.spec
