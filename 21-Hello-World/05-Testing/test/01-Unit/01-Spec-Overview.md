# Unit

There are two libraries for Unit Testing in Purescript:
- [Spec](https://pursuit.purescript.org/packages/purescript-spec/3.0.0) (Effect-based testing)
- [test-unit](https://github.com/bodil/purescript-test-unit) (Aff-based testing)

I'm not sure which one is better than the other in some situation. However, I knew about Spec first, so that's what we'll be documenting.

## Spec

Spec is useful for unit testing. Fortunately, the author already has a very clear guide in how to use it [here](https://owickstrom.github.io/purescript-spec/). Read through that and then look at this code for examples.

The Examples folder has two kinds of tests:
- Self-Contained - shows most of the functions in a single file. Its various instances show what the different reporters look like when a test gets run.
- Modulated - shows how one might create a single library-wide spec by combining other specs. See the `Runner` file for the main entry point.

# Test Instructions

To run the tests in this folder, use the following commands:
```bash
# Assuming you are in the top-level "Testing" folder

# To run each self-contained file...
pulp --psc-package test --main Test.Spec.Examples.SelfContained.ConsoleReporter
pulp --psc-package test --main Test.Spec.Examples.SelfContained.DotReporter
pulp --psc-package test --main Test.Spec.Examples.SelfContained.SpecReporter
pulp --psc-package test --main Test.Spec.Examples.SelfContained.TapReporter

# To run the Modulated runner file
pulp --psc-package test --main Test.Spec.Examples.Modulated.Runner
```
