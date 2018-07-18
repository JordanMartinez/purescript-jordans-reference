
quickCheck \arg1 arg2 {- argN... -} ->
  5 != 4 -- test line
  <?> "5 Does not equal 4" -- better error messages

quickCheckPure (mkSeed seed) numOfTests \a b c ->
  test

class Arbitrary t where
  arbitrary :: Gen t
