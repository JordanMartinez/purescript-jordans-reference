# A Better TODO

Many times, when we are modeling an application's domain, we are focusing on the type signatures for the function's we'll need instead of how we'll implement them. Thus, we might end up writing something like this:
```haskell
-- TODO: implement this later
someFunctionName :: Int -> Int -> SpecialDomainType
someFunctionName _ = unsafeCoerce
```
It might be better to output a compiler warning at the type-level and throw an exception at the value-level:
```haskell
someFunctionName :: Warn (Text "Implement someFunctionName later") =>
                    Int -> Int -> SpecialDomainType
someFunctionName _ = unsafeThrow "Implement someFunctionName later"
```
[unsafeThrow](https://pursuit.purescript.org/packages/purescript-exceptions/4.0.0/docs/Effect.Exception.Unsafe#v:unsafeThrow) is found in the `purescript-exceptions` package.
