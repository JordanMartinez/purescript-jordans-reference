module Test.Spec.Examples.FocusedSpec where

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
import Test.Spec (describe, it, focus)

main :: Effect Unit
main = launchAff_ $ runSpec [consoleReporter] do
  describe "This group doesn't get run because the other group is 'focused'" do
    it "First unfocused test" $ pure unit
    it "Second unfocused test" $ pure unit
    it "Third unfocused test" $ pure unit
  focus $ describe "This group does get run because it's 'focused'" do
    it "First focused test" $ pure unit
    it "Second focused test" $ pure unit
    it "Third focused test" $ pure unit
