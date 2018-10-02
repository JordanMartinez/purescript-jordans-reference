# Test

While I would like to test (and later benchmark) my code here, to do so using QuickCheck requires using monadic effects, which do not seem to be currently supported within QuickCheck and would require porting over additional code from the original Haskell library. So, this folder shows what I would do to get there. Perhaps, at a later time, I'll get to finish it.

For context, see this [discourse question](https://discourse.purescript.org/t/how-do-i-write-a-quickcheck-test-interpreter-for-a-free-based-program/410).
