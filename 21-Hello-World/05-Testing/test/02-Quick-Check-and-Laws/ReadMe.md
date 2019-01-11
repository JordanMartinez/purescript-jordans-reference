# Quick Check and Laws

This folder will cover
- QuickCheck test syntax
- How to generate random data via combinators and `Arbitrary`
- How to use `quickcheck-laws` to quickly check your implementation of core type classes.

For a longer explanation of the original Haskell QuickCheck:
- [A recent "unofficial" tutorial](https://begriffs.com/posts/2017-01-14-design-use-quickcheck.html)
- [The outdated manual](http://www.cse.chalmers.se/~rjmh/QuickCheck/manual.html)

## Compilation Instructions

Use these commands to compare the test results:
```bash
# Unit Tests
pulp --psc-package test -m Test.Spec.Examples.SelfContained.ConsoleReporter
pulp --psc-package test -m Test.Spec.Examples.SelfContained.DotReporter
pulp --psc-package test -m Test.Spec.Examples.SelfContained.SpecReporter
pulp --psc-package test -m Test.Spec.Examples.SelfContained.TapReporter

pulp --psc-package test -m Test.Spec.Examples.Modulated.Runner

# Quick Check
pulp --psc-package test -m Test.QuickCheckSyntax
```
