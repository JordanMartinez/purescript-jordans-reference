# Property Testing Libraries Comparison

Besides QuickCheck, there are two other property testing libraries in the Purescript ecosystem:
- [StrongCheck](https://pursuit.purescript.org/packages/purescript-strongcheck/4.1.1/docs/Test.StrongCheck.Perturb) and its corresponding [StrongCheck-Laws](https://pursuit.purescript.org/packages/purescript-strongcheck-laws/2.0.0/docs/Test.StrongCheck.Laws) package
- [Jack](https://pursuit.purescript.org/packages/purescript-jack/2.0.0) (currently doesn't work for `0.12.0`)

Here's a comparison table between the three:

| Feature | QuickCheck | StrongCheck | Jack |
| - | - | - | - |
| Equivalent Haskell Library | QuickCheck | QuickCheck | Hedgehog |
| Uses Arbitrary | Yes | Yes | No
| Supports "Shrinking" | No | No | Yes
| Supports "exhaustive" testing | No | Yes | No
| Supports "statistical" testing | No | Yes | No
| Can generate functions<br><br>Supports monadic tests | Yes | Yes | No

Besides the table above, here's a few more differences between QuickCheck (QC) and StrongCheck (SC):
- SC includes a few out-of-box newtypes for generating some typical data (e.g. AlphaNumString, Negative/NonZero/Positive Int, DateTime) whereas QC does not
- QC provides assertion operators that include standard output messages (e.g. `==?` and `/=?`)
- QC's `Gen` type and combinators are used in Benchotron, the Purescript benchmarking library (covered next)
