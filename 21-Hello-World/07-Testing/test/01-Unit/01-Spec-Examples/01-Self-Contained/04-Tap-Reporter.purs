module Test.Spec.Examples.SelfContained.TapReporter where

import Prelude
import Effect (Effect)
import Effect.Aff (launchAff_)
import Test.Spec (pending, pending', describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Tap (tapReporter)
import Test.Spec.Runner (runSpec)

main :: Effect Unit
main = launchAff_ $ runSpec [tapReporter] do
  describe "Describe: Outer Group" do
    describe "Describe: Inner Group" do
      it "It: Test 1 - Successful" do
        (1 + 1) `shouldEqual` 2
      it "It: Test 2 - Failure" do
        (1 + 1) `shouldEqual` 0
    it "It: Test 1" do
      pure unit
    pending "Pending Test: need to write it; will write it later"
      -- cannot have a body!
    pending' "Pending Test: started writing it; will finish it later." do
      -- can have a body but it is ignored
      (1 + 1) `shouldEqual` 4 -- this will fail if it runs
