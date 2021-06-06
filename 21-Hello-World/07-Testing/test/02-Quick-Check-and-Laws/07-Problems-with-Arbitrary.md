# Problems with Arbitrary

In the examples so far, we have shown you how to run your tests using `Arbitrary`. The downside of `Arbitrary` is that you might want to generate a slightly different value for the same type. This approach will quickly run afoul of two problems. Both problems can be resolved by defining a newtype over the original type and an instance that differs from the original instance:
- the problem of Overlapping Instances
- the problem of Orphan Instances

We will provide two brief examples showing this problem below. For more context and why these two problems are bad, read to `FP Philosophical Foundations/Type Clases.md#Type Class Instances: Global vs Local` or read the beginning part of [Avoid overlapping instances with closed type families](https://kseo.github.io/posts/2017-02-05-avoid-overlapping-instances-with-closed-type-families.html).

**The Problem of Overlapping Instances**:
```purescript
newtype MyRec = MyRec { a :: String, b :: Int }
instance Arbitrary MyRec where
  arbitrary = do
    a <- genString
    b <- chooseInt 1 100
    pure $ MyRec { a, b }

newtype MyRecVariation = MyRecVariation MyRec
instance Arbitrary MyRecVariation where
  arbitrary = do
    a <- map (\str -> str <> " and more") genString
    b <- chooseInt 1 200
    pure $ MyRecVariation { a, b }

main :: Effect Unit
main = do
  quickCheck \(MyRec r) -> length r.a == r.b
  quickCheck \(MyRecVariation r) -> ((length r.a) * 2) == r.b
```

**The Problem of Orphan Instances.** Another problem you might experience is that a library has defined a type and its `Arbitrary` instance. However, their version of the instance isn't the implementation you want. Since the `Arbitrary` type class and the type you wish to use were both defined in modules you can't control, you can't define an instance for that type. Thus, you must use resort to the newtype solution.

Fortunately, quickcheck provides a way around this: we don't have to use `Arbitrary` to generate a value/test. Rather, we can use plain `Gen`:

| Description | Uses `Arbitrary` | Uses `Gen` |
| - | - | - |
| Run a test 100 times | [quickCheck](https://pursuit.purescript.org/packages/purescript-quickcheck/docs/Test.QuickCheck#v:quickCheck) | [quickCheckGen](https://pursuit.purescript.org/packages/purescript-quickcheck/docs/Test.QuickCheck#v:quickCheckGen) |
| Run a test a specified number of times | [quickCheck'](https://pursuit.purescript.org/packages/purescript-quickcheck/docs/Test.QuickCheck#v:quickCheck') | [quickCheckGen'](https://pursuit.purescript.org/packages/purescript-quickcheck/docs/Test.QuickCheck#v:quickCheckGen') |
| Run a test a specified number of times with access to the seed  | [quickCheckWithSeed](https://pursuit.purescript.org/packages/purescript-quickcheck/docs/Test.QuickCheck#v:quickCheckWithSeed) | [quickCheckGenWithSeed](https://pursuit.purescript.org/packages/purescript-quickcheck/docs/Test.QuickCheck#v:quickCheckGenWithSeed) |
| Run a test a specified number of times with access to the seed, returning all the results of the test as a list | [quickCheckPure](https://pursuit.purescript.org/packages/purescript-quickcheck/docs/Test.QuickCheck#v:quickCheckPure) | [quickCheckGenPure](https://pursuit.purescript.org/packages/purescript-quickcheck/docs/Test.QuickCheck#v:quickCheckGenPure) |
| Run a test a specified number of times with access to the seed, returning all the results of the test as a list, including the seed used when running a particular test | [quickCheckPure'](https://pursuit.purescript.org/packages/purescript-quickcheck/docs/Test.QuickCheck#v:quickCheckPure') | [quickCheckGenPure'](https://pursuit.purescript.org/packages/purescript-quickcheck/docs/Test.QuickCheck#v:quickCheckGenPure') |

Thus, we could rewrite our above example test to...
```purescript
newtype MyRec = MyRec { a :: String, b :: Int }

genMyRec :: Gen MyRec
genMyRec = do
  a <- genString
  b <- chooseInt 1 100
  pure $ MyRec { a, b }

genMyRecVariation :: Gen MyRec
genMyRecVariation = do
  a <- map (\str -> str <> " and more") genString
  b <- chooseInt 1 200
  pure $ MyRecVariation { a, b }

main :: Effect Unit
main = do
  quickCheckGen do
    (MyRec r) <- genMyRec
    pure $ length r.a == r.b

  quickCheckGen do
    (MyRecVariation r) <- genMyRecVariation
    pure $ ((length r.a) * 2) == r.b

  -- or just inline `genMyRecVariation` and its test
  quickCheckGen do
    a <- map (\str -> str <> " and more") genString
    b <- chooseInt 1 200
    pure $ length a == b
```
