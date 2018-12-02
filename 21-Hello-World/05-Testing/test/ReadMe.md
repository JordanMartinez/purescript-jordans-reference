# Unit Testing vs Property Testing

## What is Unit Testing

Unit- / behavior- / example-testing verifies that a function (e.g. `reverse`) that receives a specific instance (e.g. `"apple"`) of some data type (e.g. `String`) will output a specific instance (e.g. `"elppa"`) of the same/different data type. In code:
```purescript
unitTest :: Boolean
unitTest = (reverse "apple") == "elppa"
```

If we want to test `reverse` for a different instance of `String` (e.g. "pineapple"), we would need to write a second test:
```purescript
unitTest2 :: Boolean
unitTest2 = (reverse "pineapple") == "elppaenip"
```
If we the function can take `n` different intputs, we need to write `n` different unit tests.

## Why Unit Testing Fails

1. **Bad "time : code-coverage" ratio**
    - To verify that our code works in all possible situations, we must write `n` unit tests to verify that a function that takes `n` different inputs will output the correct `n` outputs, **per function**.
2. **Poor tester creativity**
    - A test-writer may forget to write or not be "creative" enough to realize that he/she should write the one test that exposes a bug in the code.
3. **Poor data generation**
    - Some data instances are hard to create, such as those that interact with a large and complicated database. If one tries to model that data and the model is off even slightly, the tests aren't verifying anything.
4. **'Large' bug-exposing instances don't "shrink" to 'small' instances.**
    - Some tests that expose a bug use a "large" and complicated instance of some data type. Unfortunately, they don't help us figure out what is the 'smallest' version of some instance that reproduces the bug.
    - For example, if one was testing a function that took numbers that are larger than 1 million, it can be hard to determine what is causing the bug with a number like 8,423,522 whereas a number like 1,000,001 might make it much clearer.

## What is Property Testing and Why It Succeeds

Property-testing verifies that a function (e.g. `reverse`) that receives **any** instance of some data type (e.g. `String`) will output an expected instance of the same/different data type; the expected instance is calculated using the given input.

One might immediately think of this code beore realizing that it doesn't work:
```purescript
propertyTestFail :: String -> Boolean
propertyTestFail input = (reverse input) == -- ???
```
What should the expected output be? One way to resolve this is to call reverse twice on the input and see if it matches the original input. In code:
```purescript
propertyTest :: String -> Boolean
propertyTest input = (reverse (reverse input)) == input
```

In a few lines, we have made it possible to test every possible instance of `String` on the function `reverse`. We spent only a few seconds and got 100% coverage (solving the above Problem 1). Moreover, the test doesn't require any creativity on our part. Whether the `String` instance uses alphabetical characters, or numbers, or special symbols, or even characters from Asian languages, the test covers all of them (solving the above Problem 2)

The only problem left remaining is the data generation. While we may have a function that can test reverse, its useless unless we can generate random `String` instances. Fortunately, a good property-testing library (like QuickCheck) provides the necessary API to generate such data according to one's needs (solving the above Problem 3).

Lastly, Problem 4 is solved with a feature called "shrinking." While a unit test cannot shrink `8,423,522` to `1,000,001`, a property test can. This feature exists in the originaly Haskell library, but unfortunately, it does not yet seem to exist in Purescript's port of the library.

## The Trustworthiness of Property Testing

In some cases, such as `Boolean`, one has a finite number of input instances to verify:
```purescript
testBooleanWithAnd :: Boolean -> Boolean
testBooleanWithAnd randomBoolean = (randomBoolean && true) == randomBoolean
```
After proving that the above property is true for both the `true` and `false` instances of `Boolean`, one does not need to retest it again with either instances. In such a case, the test can be proven exhaustively and one's certainty in the code is 100%.

On another hand, to successfully prove that `reverse` works as expected, one would need to test an infinite number of `String` instances. Since we don't have enough time for that, we usually stop testing it after 100 tests pass successfully. 100 tests does not guarantee that our function is correct as there could still be a case where it fails. However, it makes us highly confident in it. The option to increase the number of tests is always present if that's not enough for you.

## The Limits of Property Testing

Usually, people who have never heard of property testing will think it is a "silver bullet" when it comes to writing tests. However, property testing can only cover a select number of tests cases before one must resort to unit testing. Rather than explaining it here, see [this article](https://fsharpforfunandprofit.com/posts/property-based-testing-2/) that demonstrates 7 situations where property testing works. If a test falls outside of that pattern, one will likely need to use unit testing instead.

Still, before deciding that one must use unit tests, consider using [state machine testing](http://qfpl.io/posts/intro-to-state-machine-testing-1/)

## Conclusion

As much as possible, use Property Testing. When that does not suffice, one must resort back to unit testing.
