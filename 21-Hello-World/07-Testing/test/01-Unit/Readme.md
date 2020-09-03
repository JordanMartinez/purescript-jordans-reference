# Unit

There are two libraries for Unit Testing in Purescript:
- [Spec](https://github.com/purescript-spec/purescript-spec) (Aff-based testing)
- [test-unit](https://github.com/bodil/purescript-test-unit) (Aff-based testing)

I'm not sure which one is better than the other in some situation. However, I knew about Spec first, so that's what we'll be documenting.

## Spec

Spec is useful for unit testing. The author already has a very clear guide in how to use it. Unfortunately, the links don't point to the correct version of the documentation. So, read through these links and then look at this code for examples:
- [Writing Specs](https://github.com/purescript-spec/purescript-spec/blob/master/docs/writing-specs.md)
- [Running Specs](https://github.com/purescript-spec/purescript-spec/blob/master/docs/running.md)

The Examples folder has two kinds of tests:
- Self-Contained - shows most of the functions in a single file. It shows what the different reporters output when a test gets run.
- Modulated - shows how one might create a single library-wide spec by combining other specs. See the `Runner` file for the main entry point.

## Test Instructions

To run the tests in this folder, use the following commands:
```bash
# Assuming you are in the top-level "Testing" folder

# To run each self-contained file...
spago test --main Test.Spec.Examples.SelfContained.ConsoleReporter
spago test --main Test.Spec.Examples.SelfContained.DotReporter
spago test --main Test.Spec.Examples.SelfContained.SpecReporter
spago test --main Test.Spec.Examples.SelfContained.TapReporter

# To run the Modulated runner file
spago test --main Test.Spec.Examples.Modulated.Runner

# To run the focused spec example
spago test --main Test.Spec.Examples.FocusedSpec
```
