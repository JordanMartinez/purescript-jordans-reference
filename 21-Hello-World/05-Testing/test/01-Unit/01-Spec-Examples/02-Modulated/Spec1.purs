module Test.Spec.Examples.Modulated.Spec1 (spec) where

import Prelude
import Test.Spec (Spec, describe, it)

spec :: Spec Unit
spec =
  describe "Spec1 spec" do
    it "First test" $ pure unit
    it "Second test" $ pure unit
    it "Third test" $ pure unit
    describe "First group" do
      it "First test" $ pure unit
      it "Second test" $ pure unit
      it "Third test" $ pure unit
    describe "Second group" do
      it "First test" $ pure unit
      it "Second test" $ pure unit
      it "Third test" $ pure unit
