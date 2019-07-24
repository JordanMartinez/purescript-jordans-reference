# Coarbitrary

The Dual or `Arbitrary` is `Coarbitrary`. To understand how this works, see [CoArbitrary in Haskell (SO Answer)](https://stackoverflow.com/questions/47849407/coarbitrary-in-haskell#47910875).

In case one wants to randomly generate functions, one will need to use a `Coarbitrary` constraint to implement that function's `Arbitrary` instance.

Implementing `Coarbitrary` isn't hard. Looking at [`Number`'s instance](https://github.com/purescript/purescript-quickcheck/blob/v6.1.0/src/Test/QuickCheck/Arbitrary.purs#L78), [`Boolean`'s instance](https://github.com/purescript/purescript-quickcheck/blob/v6.1.0/src/Test/QuickCheck/Arbitrary.purs#L71), and [`Char`'s instance](https://github.com/purescript/purescript-quickcheck/blob/v6.1.0/src/Test/QuickCheck/Arbitrary.purs#L102), you can start to see a pattern.
